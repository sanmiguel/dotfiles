import { execFile } from "node:child_process";
import { existsSync } from "node:fs";

const GH_CANDIDATES = ["/opt/homebrew/bin/gh", "/usr/local/bin/gh"];
const TIMEOUT_MS = 20_000;
const MAX_BUFFER = 32 * 1024 * 1024;

export type GhErrorKind = "not-found" | "auth" | "timeout" | "failed";

export class GhError extends Error {
  constructor(
    message: string,
    readonly kind: GhErrorKind,
    readonly detail?: string,
  ) {
    super(message);
    this.name = "GhError";
  }
}

export function resolveGh(configured?: string): string {
  const path = configured?.trim();
  if (path) {
    if (existsSync(path)) return path;
    throw new GhError(`gh not found at ${path}`, "not-found", "Check the gh Path preference.");
  }
  const found = GH_CANDIDATES.find((candidate) => existsSync(candidate));
  if (!found) {
    throw new GhError(
      "gh not found",
      "not-found",
      `Checked ${GH_CANDIDATES.join(" and ")}. Set the gh Path preference if it is installed elsewhere.`,
    );
  }
  return found;
}

const AUTH_PATTERN = /auth login|not logged in|HTTP 401|Bad credentials|authentication required|SAML|SSO/i;

function firstLine(text: string): string {
  return (
    text
      .split("\n")
      .map((line) => line.trim())
      .find((line) => line.length > 0) ?? ""
  );
}

/** Run `gh api graphql` against `host` and return the parsed response body. */
export function ghGraphql<T>(ghPath: string, host: string, query: string): Promise<T> {
  return new Promise((resolve, reject) => {
    execFile(
      ghPath,
      ["api", "graphql", "-f", `query=${query}`],
      {
        timeout: TIMEOUT_MS,
        maxBuffer: MAX_BUFFER,
        env: {
          ...process.env,
          // Raycast's environment has a minimal PATH; gh may shell out for keychain access.
          PATH: `/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${process.env.PATH ?? ""}`,
          GH_HOST: host,
          GH_PROMPT_DISABLED: "1",
          GH_NO_UPDATE_NOTIFIER: "1",
          NO_COLOR: "1",
        },
      },
      (error, stdout, stderr) => {
        if (error) {
          const err = error as NodeJS.ErrnoException & { killed?: boolean; signal?: string };
          if (err.killed || err.signal === "SIGTERM") {
            reject(new GhError(`gh timed out after ${TIMEOUT_MS / 1000}s`, "timeout", `Host: ${host}`));
            return;
          }
          if (err.code === "ENOENT") {
            reject(new GhError(`gh not found at ${ghPath}`, "not-found"));
            return;
          }
          const message = firstLine(stderr) || err.message;
          if (AUTH_PATTERN.test(stderr)) {
            reject(new GhError(message, "auth", `Run: gh auth login --hostname ${host}`));
          } else {
            reject(new GhError(message, "failed", `Host: ${host}`));
          }
          return;
        }
        try {
          resolve(JSON.parse(stdout) as T);
        } catch {
          reject(new GhError("Could not parse gh output", "failed", firstLine(stdout).slice(0, 200)));
        }
      },
    );
  });
}
