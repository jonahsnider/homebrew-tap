const { readFile, writeFile } = require("node:fs/promises");
const { join } = require("node:path");

const artifacts = [
  "github-mcp-server_Darwin_arm64.tar.gz",
  "github-mcp-server_Darwin_x86_64.tar.gz",
  "github-mcp-server_Linux_arm64.tar.gz",
  "github-mcp-server_Linux_x86_64.tar.gz",
];

const replaceOnce = (contents, pattern, replacement, description) => {
  const matches = [
    ...contents.matchAll(new RegExp(pattern.source, `${pattern.flags}g`)),
  ];
  if (matches.length !== 1) {
    throw new Error(`Expected exactly one ${description}`);
  }

  return contents.replace(pattern, replacement);
};

const escapeRegex = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

module.exports = async ({ github, core }) => {
  const owner = "github";
  const repo = "github-mcp-server";
  const { data: release } = await github.rest.repos.getLatestRelease({
    owner,
    repo,
  });

  const versionMatch = /^v?(\d+(?:\.\d+)+)$/.exec(release.tag_name);
  if (!versionMatch) {
    throw new Error(`Unexpected release tag: ${release.tag_name}`);
  }

  const version = versionMatch[1];
  const checksums = new Map();

  for (const artifact of artifacts) {
    const asset = release.assets.find(({ name }) => name === artifact);
    if (!asset) {
      throw new Error(`Missing release asset: ${artifact}`);
    }

    const digestMatch = /^sha256:([0-9a-f]{64})$/.exec(asset.digest ?? "");
    if (!digestMatch) {
      throw new Error(`Missing SHA-256 digest for ${artifact}`);
    }

    checksums.set(artifact, digestMatch[1]);
  }

  const formulaPath = join(__dirname, "../Formula/github-mcp-server.rb");
  const originalContents = await readFile(formulaPath, "utf8");
  let contents = replaceOnce(
    originalContents,
    /^  version "[^"]+"$/m,
    `  version "${version}"`,
    "version stanza",
  );

  for (const artifact of artifacts) {
    const checksumPattern = new RegExp(
      `^(\\s+url "[^"\\n]*/${escapeRegex(artifact)}"\\n)(\\s+)sha256 "[0-9a-f]{64}"$`,
      "m",
    );

    contents = replaceOnce(
      contents,
      checksumPattern,
      (_match, url, indentation) =>
        `${url}${indentation}sha256 "${checksums.get(artifact)}"`,
      `URL and checksum for ${artifact}`,
    );
  }

  const changed = originalContents !== contents;
  if (changed) {
    await writeFile(formulaPath, contents);
    core.info(`Updated github-mcp-server to ${version}`);
  } else {
    core.info(`github-mcp-server is already at ${version}`);
  }

  core.setOutput("changed", changed);
  core.setOutput("version", version);
};
