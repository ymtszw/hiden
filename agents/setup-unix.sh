#!/usr/bin/env bash
#
# setup-unix.sh - Deploy agent-dotfiles to OpenAI Codex, GitHub Copilot, and Google Antigravity (AGY)
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

echo "==> [agents] Setting up agent configurations for Unix / macOS..."

# 1. Build consolidated rules (00-core + 10-unix + optional AGENTS.local.md)
mkdir -p "${BUILD_DIR}"
cat "${SCRIPT_DIR}/rules/00-core.md" > "${BUILD_DIR}/AGENTS.md"
echo "" >> "${BUILD_DIR}/AGENTS.md"
cat "${SCRIPT_DIR}/rules/10-unix.md" >> "${BUILD_DIR}/AGENTS.md"

if [[ -f "${SCRIPT_DIR}/AGENTS.local.md" ]]; then
  echo "==> [agents] Merging local override: AGENTS.local.md"
  echo "" >> "${BUILD_DIR}/AGENTS.md"
  cat "${SCRIPT_DIR}/AGENTS.local.md" >> "${BUILD_DIR}/AGENTS.md"
fi

# 2. Deploy rules to OpenAI Codex and GitHub Copilot
mkdir -p "${HOME}/.codex" "${HOME}/.copilot"
ln -sf "${BUILD_DIR}/AGENTS.md" "${HOME}/.codex/AGENTS.md"
ln -sf "${BUILD_DIR}/AGENTS.md" "${HOME}/.copilot/copilot-instructions.md"
echo "  ✓ Linked rules to ~/.codex/AGENTS.md and ~/.copilot/copilot-instructions.md"

# 3. Deploy skills (common + unix) to Codex & Copilot
link_skills_to() {
  local target_dir="$1"
  mkdir -p "${target_dir}"

  for skill_cat in common unix; do
    local src_cat_dir="${SCRIPT_DIR}/skills/${skill_cat}"
    if [[ -d "${src_cat_dir}" ]]; then
      for skill_path in "${src_cat_dir}"/*; do
        if [[ -d "${skill_path}" ]]; then
          local skill_name
          skill_name="$(basename "${skill_path}")"
          ln -sfn "${skill_path}" "${target_dir}/${skill_name}"
        fi
      done
    fi
  done
}

link_skills_to "${HOME}/.codex/skills"
link_skills_to "${HOME}/.copilot/skills"
echo "  ✓ Linked common & unix skills to ~/.codex/skills and ~/.copilot/skills"

# 4. Configure Google Antigravity (AGY)
# AGY can register skills directly via ~/.gemini/config/skills.json
AGY_CONFIG_DIR="${HOME}/.gemini/config"
if [[ -d "${AGY_CONFIG_DIR}" ]]; then
  COMMON_SKILLS_PATH="${SCRIPT_DIR}/skills/common"
  UNIX_SKILLS_PATH="${SCRIPT_DIR}/skills/unix"

  cat > "${AGY_CONFIG_DIR}/skills.json" <<EOF
{
  "entries": [
    {
      "path": "${COMMON_SKILLS_PATH}"
    },
    {
      "path": "${UNIX_SKILLS_PATH}"
    }
  ]
}
EOF
  echo "  ✓ Registered skills with Antigravity at ~/.gemini/config/skills.json"
fi

echo "==> [agents] Deployment completed successfully!"
