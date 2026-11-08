---
name: dpco
description: "Guides agents using DPCO V3 for supported exact arithmetic, linear systems, 2D geometry, task validation, and independent verification. Use when solving or checking a supported mathematical task and DPCO MCP tools are available."
license: MIT
---

# DPCO Agent Skill

Use DPCO as a constrained mathematical execution and verification service. This Skill provides instructions; it is not the engine and does not install DPCO, start its MCP server, or create MCP tools.

## DPCO Runtime Dependency

Real DPCO execution requires the separate [DPCO V3 Core repository](https://github.com/a50kv109/dpco-v3), its Node.js runtime and installed dependencies, and a compatible agent host configured to connect to its MCP server. The published DPCO V3 `main` branch supports local STDIO MCP. The Skill cannot create that connection by linking to or reading the GitHub repository.

If the MCP tools are unavailable, tell the user that DPCO is not connected and direct them to [the DPCO installation and connection guide](./references/installation.md). Do not clone the project, install packages, edit host configuration, or start a server unless the user and host explicitly authorize those actions.

The DPCO MCP interface exposes four tools: `dpco_list_capabilities`, `dpco_validate_task`, `dpco_execute_task`, and `dpco_get_result`. Once connected, discover live capabilities and follow their actual schemas; a registered capability does not imply production admission. See [the tool reference](./references/tool-reference.md).

## Activate when

- A task involves a supported linear equation or linear system.
- A task involves supported exact 2D line, circle, incidence, intersection, or tangency operations.
- An agent needs DPCO to validate a task or independently check a supported result.

Do not claim 3D geometry, nonlinear algebra, arbitrary symbolic computation, geometric construction, or a generic proof checker. Check `dpco_list_capabilities` at runtime; a manifest entry or executor registration does not mean production admission is available.

## Procedure

1. Understand the user's problem and translate it into a precise DPCO operation and parameters. Preserve exact values as strings when appropriate.
2. Confirm that DPCO MCP tools are available. If not, explain the runtime dependency and refer to [installation instructions](./references/installation.md); GitHub access alone is not a runtime connection.
3. Call `dpco_list_capabilities`. Confirm the requested operation is registered and inspect its status and admission requirement.
4. Call `dpco_validate_task` with the proposed task. Inspect `valid`, `executionEligible`, `compatibleExecutors`, `blockedReason`, and `issues`.
5. Execute only if the task is valid and eligible under DPCO's current admission policy. Otherwise report the validation or admission blocker; never try to bypass it.
6. Call `dpco_execute_task` and use its actual response. If a later lookup is needed, call `dpco_get_result` with the same task ID in the same MCP server process/session.
7. Report execution status separately from verification status. Mention evidence IDs and limitations when returned. Never claim a result was verified unless DPCO reports `verificationStatus: "VERIFIED"`.
8. Explain the result and remaining mathematical limits to the user. DPCO results support, but do not replace, a clear explanation.

Read [tool-reference.md](./references/tool-reference.md) before constructing unfamiliar calls, and [verification-semantics.md](./references/verification-semantics.md) before interpreting statuses.

## Correctness and safety

- Never invent tool calls, results, evidence, admission, or capabilities.
- Never describe `BLOCKED`, `FAILED`, `REJECTED`, or `ERROR` as successful execution.
- Never describe `UNVERIFIED` as `VERIFIED`; agent confidence is not a substitute for DPCO verification.
- Never send executor overrides, diagnostic modes, grants, or evidence through task input. The public task contract rejects unsupported task fields.
- If DPCO tools are unavailable, say so. Do not imply that installing this Skill automatically connects or starts DPCO.
- If an operation is not in the live capability response or is unsupported by the documented contract, explain the limitation and solve by another transparent method only if appropriate.
- A `VERIFIED` status has operation-specific limits. For example, a multivariable residual proves the returned vector satisfies the system, not that the solution is unique; the executor and verifier also share rational arithmetic code.

For task schemas, workflows, and setup, see:

- [DPCO V3 project overview](./references/dpco-project-overview.md)
- [DPCO V3 capability catalogue](./references/dpco-capabilities.md)
- [DPCO MCP integration](./references/dpco-mcp-integration.md)
- [DPCO verification model](./references/dpco-verification-model.md)
- [Architecture](./references/architecture.md)
- [Tool reference](./references/tool-reference.md)
- [Mathematical workflows](./references/mathematical-workflows.md)
- [Verification semantics](./references/verification-semantics.md)
- [Installation and connection](./references/installation.md)
