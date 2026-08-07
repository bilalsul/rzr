#!/usr/bin/env node

/**
 * Format changelog for Telegram message with length constraints
 *
 * Telegram message max length: 4096 characters
 * Strategy:
 * 1. Try full changelog
 * 2. If too long, filter key entries + footer message
 * 3. If still too long, truncate to MAX_LENGTH characters
 */

const fs = require('fs');
const path = require('path');

const MAX_LENGTH = 3500;
const HEADER_FOOTER_RESERVE = 200;
const AVAILABLE_LENGTH = MAX_LENGTH - HEADER_FOOTER_RESERVE;

const FOOTER_EN = '\n_For more fixes and improvements, see the full changelog on GitHub._';
const FOOTER_ZH = '\n_更多修复和改进见 GitHub 完整更新日志。_';
const TRUNCATE_SUFFIX_EN = '\n_...and more. See full changelog on GitHub._';
const TRUNCATE_SUFFIX_ZH = '\n_...等更多内容。完整更新日志见 GitHub。_';

/**
 * Extract changelog for a specific version
 */
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
    throw new Error(`Version ${version} not found in changelog`);
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

/**
 * Split changelog into English and Chinese sections
 */
function splitChangelogSections(changelog) {
  const lines = changelog.split('\n');

  let englishLines = [];
  let chineseLines = [];
  let foundSplit = false;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    if (!foundSplit && line.match(/^-\s.*[\u4e00-\u9fa5]/)) {
      foundSplit = true;
    }

    if (foundSplit) {
      chineseLines.push(line);
    } else if (line.trim()) {
      englishLines.push(line);
    }
  }

  return {
    english: englishLines.join('\n').trim(),
    chinese: chineseLines.join('\n').trim()
  };
}

/**
 * Filter only key entries (Feat / Fix) from changelog
 */
function filterKeyEntries(changelog) {
  const lines = changelog.split('\n');
  return lines
    .filter(line => {
      const trimmed = line.trim();
      return trimmed.startsWith('- Feat') || trimmed.startsWith('- Fix') || trimmed === '';
    })
    .join('\n')
    .trim();
}

/**
 * Truncate to last complete line within maxLength
 */
function truncateToLastCompleteLine(text, maxLength) {
  if (text.length <= maxLength) {
    return text;
  }

  const truncated = text.substring(0, maxLength);
  const lastNewline = truncated.lastIndexOf('\n');

  if (lastNewline > 0) {
    return truncated.substring(0, lastNewline).trim();
  }

  return truncated.trim();
}

/**
 * Format changelog with length constraints
 */
function formatChangelog(changelog) {
  if (changelog.length <= AVAILABLE_LENGTH) {
    return changelog;
  }

  const { english, chinese } = splitChangelogSections(changelog);

  const englishKey = filterKeyEntries(english);
  const chineseKey = filterKeyEntries(chinese);

  let filtered = englishKey;
  if (englishKey) {
    filtered += FOOTER_EN;
  }
  if (chineseKey) {
    filtered += '\n\n' + chineseKey;
    filtered += FOOTER_ZH;
  }

  if (filtered.length <= AVAILABLE_LENGTH) {
    return filtered;
  }

  const { english: engKey, chinese: zhKey } = splitChangelogSections(filtered);

  const suffixLength = TRUNCATE_SUFFIX_EN.length + TRUNCATE_SUFFIX_ZH.length + 4;
  const maxContentLength = AVAILABLE_LENGTH - suffixLength;
  const halfSpace = Math.floor(maxContentLength / 2);

  let truncatedEng = engKey;
  let truncatedZh = zhKey;

  if (engKey.length > halfSpace) {
    truncatedEng = truncateToLastCompleteLine(engKey, halfSpace - TRUNCATE_SUFFIX_EN.length);
  }

  if (zhKey.length > halfSpace) {
    truncatedZh = truncateToLastCompleteLine(zhKey, halfSpace - TRUNCATE_SUFFIX_ZH.length);
  }

  let result = truncatedEng;
  if (truncatedEng.length < engKey.length) {
    result += TRUNCATE_SUFFIX_EN;
  }
  if (truncatedZh) {
    result += '\n\n' + truncatedZh;
  }
  if (truncatedZh.length < zhKey.length) {
    result += TRUNCATE_SUFFIX_ZH;
  }

  return result;
}

function main() {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.error('Usage: format_telegram_message.js <changelog_path> <version>');
    process.exit(1);
  }

  const changelogPath = args[0];
  const version = args[1];

  try {
    const changelogContent = fs.readFileSync(changelogPath, 'utf8');
    const versionChangelog = extractVersionChangelog(changelogContent, version);
    const formatted = formatChangelog(versionChangelog);
    console.log(formatted);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { formatChangelog, extractVersionChangelog };
