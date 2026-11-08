# Installation and MCP Connection

## Runtime dependency

The Skill instructions live in this repository; the executable runtime is the separate [DPCO V3 Core repository](https://github.com/a50kv109/dpco-v3). Reading or installing the Skill does not fetch or run that project.

## Install the Skill

Copy the `dpco/` directory to a skills location supported by the agent host. VS Code documents project skills under `.github/skills/dpco/`; a standalone skills repository may also be installed using host-specific mechanisms.

Installing the Skill only supplies instructions. It does not install DPCO dependencies, make MCP tools appear, configure an MCP client, or start a DPCO server.

## Obtain and prepare DPCO V3

The published DPCO V3 repository documents Node.js 20.19+ and npm. With user authorization, clone the repository and install its dependencies:

```sh
git clone https://github.com/a50kv109/dpco-v3.git
cd dpco-v3
npm install
```

Run commands from the cloned project root. Installation does not grant any executor admission; the default production policy remains fail-closed.

## Configure the published local STDIO MCP server

The public `main` branch defines `npm run mcp`, starting `src/integrations/mcp/server.ts` and connecting the default DPCO Core to the SDK's `StdioServerTransport`. The project-level references are [the MCP integration guide](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_INTEGRATION.md), [the server entry point](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/server.ts), and [the MCP adapter](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/adapter.ts).

Configure the agent host's MCP client using its own supported configuration format. The DPCO V3 example uses this shape; replace the placeholder with the absolute path to the checkout:

```json
{
  "servers": {
    "dpco-v3": {
      "type": "stdio",
      "command": "npm",
      "args": ["run", "mcp"],
      "cwd": "/absolute/path/to/dpco-v3"
    }
  }
}
```

The server process must be running under the client. A Skill cannot start it unless the host separately provides and authorizes that execution.

## Streamable HTTP status

As of the current published `dpco-v3/main`, Streamable HTTP is **not included**: its `http_server.ts`, `mcp:http` script, and local HTTP testing guide are absent from that branch. A separate local DPCO V3 working copy contains an unpublished development implementation bound to `127.0.0.1`; it has no OAuth or client authentication and must not be exposed through a tunnel or public network. Do not expect the public clone steps above to provide HTTP.

Remote Streamable HTTP hosting, OAuth, and Gemini deployment are not implemented in the published repository. Do not provide a public endpoint or credentials based on these local instructions.

## Verify connection

1. Confirm the MCP client reports the server connected.
2. Confirm the four DPCO tool names are exposed.
3. Call `dpco_list_capabilities` and inspect the actual response.
4. Call `dpco_validate_task` with a supported request.
5. Do not assume execution is admitted; inspect `executionEligible` and `blockedReason`.
6. If execution is admitted and requested, call `dpco_execute_task` and interpret the returned statuses as described in [verification semantics](./verification-semantics.md).

If tools cannot be called, report that DPCO MCP is unavailable. Do not substitute invented responses.
