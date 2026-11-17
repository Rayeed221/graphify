#!/bin/bash
set -euo pipefail

# Cloud sessions only
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"
export PATH="$HOME/.local/bin:$PATH"

# Install the graphify CLI + MCP server (editable, from this checkout) if missing
if ! command -v graphify-mcp >/dev/null 2>&1; then
  command -v uv >/dev/null 2>&1 || python3 -m pip install --quiet uv
  uv tool install --editable ".[mcp]"
fi

# Build the code graph if it doesn't exist yet (AST-only, no LLM cost)
if [ ! -f graphify-out/graph.json ]; then
  graphify extract . --code-only
fi
