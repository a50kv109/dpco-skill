#!/bin/sh

DPCO_DIR=${DPCO_PROJECT_DIR:-}
FAILURES=0

pass() {
  printf 'PASS: %s\n' "$1"
}

warn() {
  printf 'WARN: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  FAILURES=$((FAILURES + 1))
}

if command -v node >/dev/null 2>&1; then
  pass "Node.js is available ($(node --version))"
else
  fail "Node.js is not available on PATH"
fi

if command -v npm >/dev/null 2>&1; then
  pass "npm is available ($(npm --version))"
else
  fail "npm is not available on PATH"
fi

if [ -n "$DPCO_DIR" ]; then
  if [ -d "$DPCO_DIR" ]; then
    pass "DPCO project directory exists: $DPCO_DIR"
  else
    fail "DPCO project directory does not exist: $DPCO_DIR"
  fi

  if [ -f "$DPCO_DIR/package.json" ]; then
    pass "DPCO package.json exists"
  else
    fail "DPCO package.json is missing"
  fi

  if [ -d "$DPCO_DIR/node_modules" ]; then
    pass "node_modules directory exists"
  else
    warn "Dependencies do not appear installed (node_modules is missing)"
  fi

  if [ -d "$DPCO_DIR/node_modules/@modelcontextprotocol/sdk" ]; then
    pass "MCP SDK package directory exists"
  else
    warn "MCP SDK package directory is missing"
  fi

  if [ -f "$DPCO_DIR/src/integrations/mcp/server.ts" ]; then
    pass "Expected STDIO MCP entry point exists"
  else
    fail "Expected entry point is missing: src/integrations/mcp/server.ts"
  fi
else
  warn "DPCO_PROJECT_DIR is not set; provide the DPCO V3 checkout path to check the project"
fi

if [ "$FAILURES" -gt 0 ]; then
  printf 'Environment check completed with %s failure(s).\n' "$FAILURES"
  exit 1
fi

printf 'Environment check completed; review any WARN messages above.\n'
