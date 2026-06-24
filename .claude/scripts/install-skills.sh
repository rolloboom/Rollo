#!/bin/bash
# Install the curated skill set into the PERSONAL skills dir (~/.claude/skills),
# so the skills are available in every session regardless of which repo it works on.
#
# Use as a Claude Code on the web "Setup script" (per environment), or run once
# in a local terminal. Idempotent: re-running refreshes the skills.
#
# Curated set (58 skills): all marketing/content skills + stop-slop (anti-AI text)
# + 4 context/token-saving skills + the ui-ux design bundle + remotion-video.

set -u
DEST="${HOME}/.claude/skills"
TMP="$(mktemp -d)"
mkdir -p "$DEST"

clone() { git clone --depth 1 "https://github.com/$1.git" "$TMP/$2" >/dev/null 2>&1 || echo "WARN: clone failed $1"; }

clone coreyhaines31/marketingskills                       mk
clone hardikpandya/stop-slop                              ss
clone wshuyi/remotion-video-skill                         rv
clone muratcankoylan/agent-skills-for-context-engineering ce
clone nextlevelbuilder/ui-ux-pro-max-skill               ui

# Marketing + content (45) — every skill in the repo's skills/ dir
cp -r "$TMP"/mk/skills/*/ "$DEST"/ 2>/dev/null

# UI/site-design bundle (7)
cp -r "$TMP"/ui/.claude/skills/*/ "$DEST"/ 2>/dev/null

# Token-saving / context skills (4) — only these, not the agent-engineering ones
for s in context-compression context-degradation context-fundamentals context-optimization; do
  cp -r "$TMP/ce/skills/$s" "$DEST"/ 2>/dev/null
done

# Single-skill repos, copying SKILL.md plus their bundled resources
mkdir -p "$DEST/stop-slop"
cp "$TMP"/ss/SKILL.md "$DEST/stop-slop/" 2>/dev/null
cp -r "$TMP"/ss/references "$DEST/stop-slop/" 2>/dev/null

mkdir -p "$DEST/remotion-video"
cp "$TMP"/rv/SKILL.md "$DEST/remotion-video/" 2>/dev/null
cp -r "$TMP"/rv/scripts "$TMP"/rv/templates "$DEST/remotion-video/" 2>/dev/null

rm -rf "$TMP"
echo "Installed $(find "$DEST" -name SKILL.md | wc -l) skills into $DEST"
