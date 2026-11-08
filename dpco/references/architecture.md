# DPCO Skill Architecture

## Responsibility boundaries

| Layer | Responsibility |
|---|---|
| AI Agent | Understands the user's request, formulates a mathematical task, chooses whether to consult DPCO, and communicates the result. |
| DPCO Skill | Teaches the agent how to discover capabilities, form valid requests, use MCP tools, and interpret outcomes. It is not executable math infrastructure. |
| MCP client and protocol | Exposes server tools to the agent and transports structured requests and responses. |
| DPCO MCP adapter | Validates the external task shape, maps the supported multivariable operation alias, and invokes the Core. |
| DPCO Core | Applies task validation, ContradictionGate, capability/admission dispatch, execution, IndependentVerifier, classification, and Ledger recording. |
| Executor | Computes a supported operation after Core dispatch and admission. |
| IndependentVerifier | Checks operation-specific properties of the executor's result. Its independence is bounded by the implementation. |
| Evidence Registry and Admission | Track qualification evidence and grants; tool registration alone does not grant production permissions. |
| Ledger | Records execution status and provenance. Current ledger persistence is process-local/in-memory for Node MCP servers. |

The intended pipeline remains:

```text
Admission → Executor → IndependentVerifier → Ledger
```

The adapter passes a normal production-mode task to `DPCOCore.processTask`. The MCP server does not expose a task field for executor selection, diagnostic mode, admission mutation, or evidence mutation.

## Keep these concepts separate

- A Skill can be installed without DPCO, but it cannot execute DPCO work by itself.
- MCP tools exist only when a configured MCP client can reach a running server.
- DPCO's Core may block execution even when an operation appears in the manifest or its executor is registered.
- An agent's independent reasoning is not DPCO's IndependentVerifier.

## Transports

The published [`dpco-v3/main`](https://github.com/a50kv109/dpco-v3) includes:

- Local STDIO MCP: `npm run mcp`, implemented in [the server entry point](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/server.ts).

The Streamable HTTP adapter exists only in a separate local DPCO V3 development checkout and is not included in the public `main` branch. It binds to `127.0.0.1`; it is not a public remote service.

The Skill does not automatically configure either transport. Remote hosting, OAuth, and public networking are not implemented. See [the DPCO V3 architecture](https://github.com/a50kv109/dpco-v3/blob/main/docs/DPCO_V3_ARCHITECTURE.md) and [installation instructions](./installation.md).
