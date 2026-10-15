#!/usr/bin/env node
// Sync the shared skills from the Claude plugin into the Codex plugin.
//
//   node scripts/sync-skills.mjs          copy the shared skills
//   node scripts/sync-skills.mjs --check  check only, exit 1 on drift (for CI)
//
// plugins/fchat-claude/skills is the source of truth. Skills in HOST_SKILLS have a separate
// edition per host and are never overwritten.

import { cpSync, existsSync, readdirSync, readFileSync, rmSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = fileURLToPath(new URL("..", import.meta.url));
const SRC = join(ROOT, "plugins/fchat-claude/skills");
const DEST = join(ROOT, "plugins/fchat-codex/skills");
const HOST_SKILLS = new Set(["fchat-basics"]);

const check = process.argv.includes("--check");

function listFiles(dir) {
  if (!existsSync(dir)) return [];
  return readdirSync(dir).flatMap((name) => {
    const p = join(dir, name);
    return statSync(p).isDirectory() ? listFiles(p) : [p];
  });
}

function sameTree(a, b) {
  const fa = listFiles(a).map((p) => relative(a, p)).sort();
  const fb = listFiles(b).map((p) => relative(b, p)).sort();
  if (fa.join("\n") !== fb.join("\n")) return false;
  return fa.every((f) => readFileSync(join(a, f)).equals(readFileSync(join(b, f))));
}

const shared = readdirSync(SRC).filter((n) => !HOST_SKILLS.has(n) && statSync(join(SRC, n)).isDirectory());
const stale = readdirSync(DEST).filter((n) => !HOST_SKILLS.has(n) && !shared.includes(n));
const drifted = shared.filter((n) => !sameTree(join(SRC, n), join(DEST, n)));

if (check) {
  if (drifted.length || stale.length) {
    for (const n of drifted) console.error(`out of sync: ${n}`);
    for (const n of stale) console.error(`stale: ${n}`);
    console.error("Run: node scripts/sync-skills.mjs");
    process.exit(1);
  }
  console.log(`OK: ${shared.length} shared skills in sync.`);
  process.exit(0);
}

for (const n of stale) {
  rmSync(join(DEST, n), { recursive: true });
  console.log(`removed: ${n}`);
}
for (const n of drifted) {
  rmSync(join(DEST, n), { recursive: true, force: true });
  cpSync(join(SRC, n), join(DEST, n), { recursive: true });
  console.log(`copied: ${n}`);
}
if (!drifted.length && !stale.length) console.log("No changes.");
