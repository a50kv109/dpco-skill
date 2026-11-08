# DPCO V3 MCP Integration

## Published transport and availability

The public [DPCO V3 `main` branch](https://github.com/a50kv109/dpco-v3) includes a local STDIO MCP server. Its package script is `npm run mcp`, and its entry point is [src/integrations/mcp/server.ts](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/server.ts). The adapter constructs the default Core and connects it to the SDK `StdioServerTransport`.

**Important source-version distinction:** the inspected public `main` branch does not contain `src/integrations/mcp/http_server.ts`, an `mcp:http` script, or `docs/MCP_HTTP_LOCAL.md`. A separate local DPCO V3 development checkout contains a loopback-only Streamable HTTP implementation, but it is unpublished and is not obtained by the public clone instructions. The public Skill therefore does not promise that HTTP is available to users cloning DPCO V3.

No public/remote MCP hosting, OAuth, or network authentication is implemented in the published Core.

## Four MCP tools

1. **`dpco_list_capabilities`** — returns manifest operations, runtime registrations, and status; registration does not imply production admission.
2. **`dpco_validate_task`** — validates the task and reports eligible candidates/block reasons; it does not execute or grant admission.
3. **`dpco_execute_task`** — submits an ordinary production-mode task to the Core. The adapter does not accept executor overrides, diagnostic-mode requests, grants, or evidence changes.
4. **`dpco_get_result`** — looks up the latest ledger record for a caller-supplied task ID in the current server process.

The tool schemas and output contracts are documented in the Skill's [tool reference](./tool-reference.md) and in the published [MCP contracts](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/contracts.ts) and [adapter](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/adapter.ts).

## Host connection

Install dependencies in the DPCO V3 project and configure the host's MCP client to launch `npm run mcp` with `cwd` set to the absolute DPCO V3 checkout path. The exact client configuration file and restart procedure depend on the host. See [installation and connection](./installation.md) and the original [MCP integration guide](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_INTEGRATION.md).

The Skill does not make tools appear by itself. After connecting, check the host's tool list and call `dpco_list_capabilities` to inspect the live server.

## Security boundaries

- STDIO runs under the operating-system identity and environment of its launcher; it is not a sandbox.
- A fresh production server remains fail-closed; tool requests cannot create grants or qualification evidence.
- The public `main` branch does not offer a remote authenticated service.
- The local unpublished HTTP development implementation binds only to `127.0.0.1`; it has no OAuth/client authentication and must not be tunneled or exposed publicly.
- Sessions/ledger state are process-local. Do not treat this as authenticated multi-tenant isolation or durable audit storage.

See the published [MCP security notes](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_SECURITY.md) and [known limitations](https://github.com/a50kv109/dpco-v3/blob/main/docs/KNOWN_LIMITATIONS.md).
