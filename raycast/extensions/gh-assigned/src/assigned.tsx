import { Action, ActionPanel, Color, Icon, Image, List, getPreferenceValues } from "@raycast/api";
import { useCachedPromise } from "@raycast/utils";
import { ReactElement, useMemo, useState } from "react";
import { Item, Kind, fetchAssigned, groupByRepo } from "./lib/assigned";
import { GhError } from "./lib/gh";

interface Preferences {
  host?: string;
  ghPath?: string;
}

type KindFilter = "all" | Kind;

const DEFAULT_HOST = "hopper-healthcare.ghe.com";

export default function Command() {
  const preferences = getPreferenceValues<Preferences>();
  const host = preferences.host?.trim() || DEFAULT_HOST;
  const ghPath = preferences.ghPath?.trim() ?? "";

  const [kind, setKind] = useState<KindFilter>("all");
  const { data, isLoading, error, revalidate } = useCachedPromise(fetchAssigned, [host, ghPath], {
    keepPreviousData: true,
  });

  const groups = useMemo(() => {
    const items = data?.items ?? [];
    return groupByRepo(kind === "all" ? items : items.filter((item) => item.kind === kind));
  }, [data, kind]);

  const assignedUrl = `https://${host}/issues/assigned`;
  const refresh = (
    <Action
      title="Refresh"
      icon={Icon.ArrowClockwise}
      shortcut={{ modifiers: ["cmd"], key: "r" }}
      onAction={revalidate}
    />
  );

  return (
    <List
      isLoading={isLoading}
      searchBarPlaceholder="Filter by title, #number, repo or label"
      navigationTitle={data ? `${data.issueTotal} issues, ${data.prTotal}${data.prsTruncated ? "+" : ""} PRs` : undefined}
      searchBarAccessory={
        <List.Dropdown tooltip="Type" storeValue onChange={(value) => setKind(value as KindFilter)}>
          <List.Dropdown.Item title="Issues and PRs" value="all" />
          <List.Dropdown.Item title="Issues" value="issue" />
          <List.Dropdown.Item title="Pull requests" value="pr" />
        </List.Dropdown>
      }
    >
      {error && !data ? (
        <List.EmptyView
          icon={{ source: Icon.ExclamationMark, tintColor: Color.Red }}
          title={error.message}
          description={error instanceof GhError ? error.detail : undefined}
          actions={<ActionPanel>{refresh}</ActionPanel>}
        />
      ) : (
        <List.EmptyView
          icon={Icon.CheckCircle}
          title={kind === "all" ? "Nothing assigned to you" : `No ${kind === "pr" ? "pull requests" : "issues"} assigned to you`}
          actions={<ActionPanel>{refresh}</ActionPanel>}
        />
      )}

      {data && (data.issuesTruncated || data.prsTruncated) && (
        <List.Section title="Incomplete results">
          <List.Item
            icon={{ source: Icon.Warning, tintColor: Color.Orange }}
            title={truncationMessage(data.issuesTruncated, data.prsTruncated, data.issueTotal)}
            subtitle="Open the full list on GitHub"
            actions={
              <ActionPanel>
                <Action.OpenInBrowser url={assignedUrl} />
                {refresh}
              </ActionPanel>
            }
          />
        </List.Section>
      )}

      {groups.map((group) => (
        <List.Section key={group.repo} title={group.repo} subtitle={String(group.items.length)}>
          {group.items.map((item) => (
            <AssignedItem key={item.url} item={item} refresh={refresh} />
          ))}
        </List.Section>
      ))}
    </List>
  );
}

function truncationMessage(issues: boolean, prs: boolean, issueTotal: number): string {
  if (issues && prs) return `Showing the first 100 of ${issueTotal} issues; pull requests also truncated`;
  if (issues) return `Showing the first 100 of ${issueTotal} issues`;
  return "Pull request search truncated at 100 before author filtering";
}

function itemIcon(item: Item): Image.ImageLike {
  if (item.kind === "issue") return { source: Icon.CircleProgress, tintColor: Color.Green };
  return item.isDraft
    ? { source: Icon.CircleDisabled, tintColor: Color.SecondaryText }
    : { source: Icon.CircleFilled, tintColor: Color.Purple };
}

function AssignedItem({ item, refresh }: { item: Item; refresh: ReactElement }) {
  const repoName = item.repo.split("/")[1] ?? item.repo;
  const updated = new Date(item.updatedAt);

  const accessories: List.Item.Accessory[] = [
    ...(item.isDraft ? [{ tag: { value: "Draft", color: Color.SecondaryText } }] : []),
    ...item.labels.map((label) => ({ tag: { value: label.name, color: label.color } })),
    { date: updated, tooltip: `Updated ${updated.toLocaleString()}` },
  ];

  return (
    <List.Item
      icon={{ value: itemIcon(item), tooltip: item.kind === "pr" ? (item.isDraft ? "Draft pull request" : "Pull request") : "Issue" }}
      title={item.title}
      subtitle={`#${item.number}`}
      keywords={[`#${item.number}`, String(item.number), item.repo, repoName, ...item.labels.map((l) => l.name)]}
      accessories={accessories}
      actions={
        <ActionPanel>
          <ActionPanel.Section>
            <Action.OpenInBrowser url={item.url} />
            <Action.CopyToClipboard
              title="Copy URL"
              content={item.url}
              shortcut={{ modifiers: ["cmd", "shift"], key: "c" }}
            />
            <Action.CopyToClipboard
              title="Copy Markdown Link"
              content={`[${item.repo}#${item.number}: ${item.title}](${item.url})`}
              shortcut={{ modifiers: ["cmd", "shift"], key: "l" }}
            />
            <Action.CopyToClipboard
              title="Copy Reference"
              content={`${item.repo}#${item.number}`}
              shortcut={{ modifiers: ["cmd", "shift"], key: "n" }}
            />
          </ActionPanel.Section>
          <ActionPanel.Section>{refresh}</ActionPanel.Section>
        </ActionPanel>
      }
    />
  );
}
