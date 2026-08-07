#!/usr/bin/env node

/**
 * Format changelog for Mastodon toot with character limit (~480 chars)
 */

const fs = require('fs');

const MAX_TOTAL_LENGTH = 480;

function extractVersionChangelog(changelogContent, version) {
  const lines = changelogContent.split('\n');

  let startIndex = -1;
  let endIndex = lines.length;

  for (let i = 0; i < lines.length; i++) {
    const trimmed = lines[i].trim();
    if (trimmed === `## ${version}` || trimmed === `# ${version}`) {
      startIndex = i;
      break;
    }
  }

  if (startIndex === -1) {
    return `Release ${version}`;
  }

  for (let i = startIndex + 1; i < lines.length; i++) {
    const trimmed = lines[i].trim();
    if (trimmed.startsWith('## ') || (trimmed.startsWith('# ') && !trimmed.toLowerCase().includes('changelog'))) {
      endIndex = i;
      break;
    }
  }

  return lines.slice(startIndex + 1, endIndex).join('\n').trim();
}

function truncateToFit(text, maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  const truncated = text.substring(0, maxLength);
  const lastNewline = truncated.lastIndexOf('\n');
  if (lastNewline > 0) {
    return truncated.substring(0, lastNewline).trim() + '\n...';
  }
  return truncated.trim() + '...';
}

function formatMastodonMessage(changelogPath, version, isBeta, repo, tag) {
  let rawChangelog = `Release ${version}`;
  if (fs.existsSync(changelogPath)) {
    try {
      const content = fs.readFileSync(changelogPath, 'utf8');
      rawChangelog = extractVersionChangelog(content, version);
    } catch (e) {}
  }

  const header = isBeta
    ? `🧪 Beta Version Released!\n🧪 Version: ${version}\n\nWhat's New:\n`
    : `🎉 New Release Available!\n🚀 Version: ${version}\n\nWhat's New:\n`;

  const footer = `\n\n📥 Download: https://github.com/${repo}/releases/tag/${tag}`;

  const availableForNotes = MAX_TOTAL_LENGTH - header.length - footer.length;
  const formattedNotes = truncateToFit(rawChangelog, Math.max(availableForNotes, 50));

  return `${header}${formattedNotes}${footer}`;
}

function main() {
  const args = process.argv.slice(2);
  if (args.length < 5) {
    console.error('Usage: format_mastodon_message.js <changelog_path> <version> <is_beta> <repo> <tag>');
    process.exit(1);
  }

  const changelogPath = args[0];
  const version = args[1];
  const isBeta = args[2] === 'true';
  const repo = args[3];
  const tag = args[4];

  const message = formatMastodonMessage(changelogPath, version, isBeta, repo, tag);
  console.log(message);
}

if (require.main === module) {
  main();
}

module.exports = { formatMastodonMessage };
