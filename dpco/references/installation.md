# Installation and MCP Connection

## Install the Skill

Copy the `dpco/` directory to a skills location supported by the agent host. VS Code documents project skills under `.github/skills/dpco/`; a standalone skills repository may also be installed using host-specific mechanisms.

Installing the Skill only supplies instructions. It does not install DPCO dependencies, make MCP tools appear, configure an MCP client, or start a DPCO server.

## Configure local STDIO MCP

**Verified in DPCO V3 source:** `package.json` defines `npm run mcp`, which starts `src/integrations/mcp/server.ts`. That entry point constructs the existing default MCP Core and connects it to the SDK `StdioServerTransport`.

Requirements are Node.js 20+ and the DPCO project dependencies installed. Configure the MCP client using its own documented format. The DPCO V3 source repository includes an example at `examples/mcp-client-config.json`; its absolute `cwd` is machine-specific and must be replaced on another computer.

The server process must be running under the client. A Skill cannot start it unless the host separately provides and authorizes that execution.

## Optional local Streamable HTTP

DPCO V3 also provides `npm run mcp:http` at `http://127.0.0.1:3000/mcp` by default. This is only a local protocol-validation alternative. It binds to loopback, has no OAuth or client authentication, and must not be exposed through a tunnel or public network. Further implementation details are in `docs/MCP_HTTP_LOCAL.md` in the DPCO V3 checkout.

Remote Streamable HTTP hosting, OAuth, and Gemini deployment are not implemented. Do not provide a public endpoint or credentials based on these local instructions.

## Verify connection

1. Confirm the MCP client reports the server connected.
2. Call `dpco_list_capabilities` and inspect the actual response.
3. Call `dpco_validate_task` with a supported request.
4. Do not assume execution is admitted; inspect `executionEligible` and `blockedReason`.
5. If execution is admitted and requested, call `dpco_execute_task` and interpret the returned statuses as described in [verification semantics](./verification-semantics.md).

If tools cannot be called, report that DPCO MCP is unavailable. Do not substitute invented responses.
