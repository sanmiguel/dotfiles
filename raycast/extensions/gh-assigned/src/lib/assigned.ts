import { ghGraphql, resolveGh } from "./gh";

// ---- GraphQL ---------------------------------------------------------------

const PAGE_SIZE = 100;
const TIMELINE_WINDOW = 20;

const QUERY = `
query {
  viewer { login }
  issues: search(query: "is:issue is:open archived:false assignee:@me", type: ISSUE, first: ${PAGE_SIZE}) {
    issueCount
    nodes {
      ... on Issue {
        number title url updatedAt
        repository { nameWithOwner }
        labels(first: 10) { nodes { name color } }
      }
    }
  }
  prs: search(query: "is:pr is:open archived:false assignee:@me", type: ISSUE, first: ${PAGE_SIZE}) {
    issueCount
    nodes {
      ... on PullRequest {
        number title url updatedAt isDraft
        author { login }
        repository { nameWithOwner }
        labels(first: 10) { nodes { name color } }
        timelineItems(itemTypes: [ASSIGNED_EVENT], last: ${TIMELINE_WINDOW}) {
          nodes {
            ... on AssignedEvent {
              actor { __typename login }
              assignee { ... on User { login } }
            }
          }
        }
      }
    }
  }
}`;

interface RawLabel {
  name: string;
  color: string;
}

interface RawIssue {
  number: number;
  title: string;
  url: string;
  updatedAt: string;
  repository: { nameWithOwner: string };
  labels: { nodes: RawLabel[] };
}

interface RawAssignedEvent {
  actor?: { __typename: string; login: string } | null;
  assignee?: { login?: string } | null;
}

interface RawPullRequest extends RawIssue {
  isDraft: boolean;
  author: { login: string } | null;
  timelineItems: { nodes: RawAssignedEvent[] };
}

// Search nodes of a non-matching type come back as `{}`.
type Node<T> = T | Record<string, never>;

interface Search<T> {
  issueCount: number;
  nodes: Node<T>[];
}

interface Response {
  data: {
    viewer: { login: string };
    issues: Search<RawIssue>;
    prs: Search<RawPullRequest>;
  };
}

// ---- Result model (JSON-serialisable: it is stored in Raycast's cache) -----

export type Kind = "issue" | "pr";

export interface Label {
  name: string;
  color: string; // "#rrggbb"
}

export interface Item {
  kind: Kind;
  number: number;
  title: string;
  url: string;
  updatedAt: string; // ISO 8601, kept as a string so cached data round-trips
  repo: string;
  labels: Label[];
  isDraft: boolean;
}

export interface Assigned {
  viewer: string;
  items: Item[];
  /** Exact total from search; may exceed the number of issue items returned. */
  issueTotal: number;
  /** Count after author filtering; exact unless prsTruncated. */
  prTotal: number;
  issuesTruncated: boolean;
  prsTruncated: boolean;
}

export interface RepoGroup {
  repo: string;
  items: Item[];
}

// ---- Logic -----------------------------------------------------------------

function isPresent<T extends object>(node: Node<T>): node is T {
  return "number" in node;
}

/**
 * Hide an authored PR only when the latest assignment of `me` is positively
 * known to be by `me` or by a bot. Missing events (outside the timeline window)
 * or unresolvable actors (deleted accounts) fail open: the PR is shown.
 */
function selfOrBotAssigned(pr: RawPullRequest, me: string): boolean {
  const latest = pr.timelineItems.nodes.findLast((event) => event.assignee?.login === me);
  const actor = latest?.actor;
  if (!actor) return false;
  return actor.login === me || actor.__typename === "Bot";
}

function toItem(raw: RawIssue, kind: Kind, isDraft = false): Item {
  return {
    kind,
    number: raw.number,
    title: raw.title,
    url: raw.url,
    updatedAt: raw.updatedAt,
    repo: raw.repository.nameWithOwner,
    labels: raw.labels.nodes.map((label) => ({ name: label.name, color: `#${label.color}` })),
    isDraft,
  };
}

export function transform(response: Response): Assigned {
  const { viewer, issues, prs } = response.data;
  const me = viewer.login;

  const issueItems = issues.nodes.filter(isPresent).map((issue) => toItem(issue, "issue"));

  const prItems = prs.nodes
    .filter(isPresent)
    .filter((pr) => pr.author?.login !== me || !selfOrBotAssigned(pr, me))
    .map((pr) => toItem(pr, "pr", pr.isDraft));

  return {
    viewer: me,
    items: [...issueItems, ...prItems],
    issueTotal: issues.issueCount,
    prTotal: prItems.length,
    issuesTruncated: issues.issueCount > issues.nodes.length,
    prsTruncated: prs.issueCount > prs.nodes.length,
  };
}

/** Group by repository; repos ordered by most recent activity, items newest first. */
export function groupByRepo(items: Item[]): RepoGroup[] {
  const byRepo = new Map<string, Item[]>();
  for (const item of items) {
    const list = byRepo.get(item.repo);
    if (list) list.push(item);
    else byRepo.set(item.repo, [item]);
  }
  const newestFirst = (a: Item, b: Item) => b.updatedAt.localeCompare(a.updatedAt);
  return [...byRepo.entries()]
    .map(([repo, list]) => ({ repo, items: list.sort(newestFirst) }))
    .sort((a, b) => newestFirst(a.items[0], b.items[0]));
}

export async function fetchAssigned(host: string, ghPathPreference: string): Promise<Assigned> {
  const ghPath = resolveGh(ghPathPreference);
  const response = await ghGraphql<Response>(ghPath, host, QUERY);
  return transform(response);
}
