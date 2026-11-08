# DPCO V3 Project Overview

## What DPCO V3 is

DPCO V3 is agent-support middleware for a bounded set of mathematical and discrete-geometry tasks. It accepts structured tasks, applies validation and admission policy, dispatches compatible executors, checks returned results, and records outcomes. It is not an AI agent, a general-purpose computer algebra system, or a universal proof engine.

The [original DPCO V3 Core repository](https://github.com/a50kv109/dpco-v3) contains the executable implementation. This `dpco-skill` repository contains only portable agent instructions, examples, and documentation. They are separate projects; updates to runtime contracts or capabilities may require a corresponding Skill documentation update.

## Problem and design philosophy

An AI agent can formulate a mathematical problem and propose an answer, but its own confidence is not an execution record or an independent check. DPCO separates task interpretation from constrained computation and verification. It distinguishes execution status, claim verdict, and verification status; a successful computation does not by itself mean the result is verified.

The operating boundary is intentionally narrow: exact rational arithmetic, supported linear systems, and discrete 2D geometry operations. A listed or registered operation is not necessarily admitted for production execution.

## Responsibility boundaries

```text
AI Agent
   | task interpretation and explanation
   v
DPCO Skill
   | instructions and MCP usage methodology
   v
DPCO MCP
   | structured tool boundary
   v
DPCO V3 Core
   Admission -> Executor -> IndependentVerifier -> Ledger
```

- **Agent:** interprets the user's request, formulates a task, and explains the observed result.
- **Skill:** explains when and how to use DPCO; it does not compute or connect to MCP by itself.
- **MCP:** exposes the Core to a configured host through callable tools.
- **Core:** validates, gates and dispatches tasks and coordinates verification and recording.
- **Executor:** performs only the operation it supports.
- **IndependentVerifier:** checks supported relations on the executor's result. It is not a formal proof assistant and has documented common-mode arithmetic risk.
- **Evidence Registry / Admission:** stores in-memory evidence and grants that determine whether executors are eligible for production dispatch.
- **Ledger:** records pipeline outcomes in a hash-chained sequence; it is not an externally signed or anchored audit service.

See the [DPCO V3 architecture](https://github.com/a50kv109/dpco-v3/blob/main/docs/DPCO_V3_ARCHITECTURE.md) for the source project's component boundaries.

## Confirmed task families

The published capability manifest describes:

- One-variable linear equation solving.
- Legacy single-variable linear systems.
- Multivariable linear systems over rational numbers.
- Exact 2D line intersection, point incidence, point-on-circle, line-circle tangency, and line-circle intersection when the resulting coordinates are rational.

The runtime MCP contract and limitations are summarized in the [capability catalogue](./dpco-capabilities.md). These are operation-specific capabilities, not claims of general algebra or geometry support.

## Runtime and maturity

Real computations require DPCO V3 to be installed and its MCP server configured in a compatible agent host. The public repository documents local STDIO MCP. The local HTTP adapter present in a separate development checkout is not in the currently published `dpco-v3/main` branch; see [MCP integration status](./dpco-mcp-integration.md).

The source project's published status lists its core checks as passing: a 54-case original matrix and 39 multivariable assertions in the 2026-11-08 validation snapshot. Those finite tests do not establish correctness for all inputs. Read [development status](./dpco-development-status.md) before making maturity claims.

## Source navigation

- [DPCO V3 repository](https://github.com/a50kv109/dpco-v3)
- [Project README](https://github.com/a50kv109/dpco-v3/blob/main/README.md)
- [Architecture](https://github.com/a50kv109/dpco-v3/blob/main/docs/DPCO_V3_ARCHITECTURE.md)
- [Capability manifest](https://github.com/a50kv109/dpco-v3/blob/main/src/core/capabilityManifest.ts)
- [Core execution pipeline](https://github.com/a50kv109/dpco-v3/blob/main/src/core/dpcoCore.ts)
- [MCP integration guide](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_INTEGRATION.md)
- [MCP security notes](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_SECURITY.md)
- [Known limitations](https://github.com/a50kv109/dpco-v3/blob/main/docs/KNOWN_LIMITATIONS.md)
