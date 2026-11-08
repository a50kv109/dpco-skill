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

DPCO V3 currently includes:

- Local STDIO MCP: `npm run mcp`.
- Local Streamable HTTP MCP: `npm run mcp:http`, bound to `127.0.0.1`; this is for local protocol validation only.

Neither transport automatically becomes available just by installing the Skill. Remote hosting, OAuth, and public networking are not implemented.
