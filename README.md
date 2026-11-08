# DPCO Agent Skill

DPCO Agent Skill is a portable set of instructions that teaches a compatible AI agent how to use the existing DPCO V3 MCP tools for supported math and 2D geometry tasks.

## The layers

- **Skill:** instructions and usage methodology.
- **MCP:** the callable tool protocol and server.
- **DPCO Core:** task validation, admission, executor dispatch, independent verification, and ledger recording.
- **AI Agent:** interprets the user's request, prepares a task, calls available tools, and explains the result.

Installing this Skill does not install DPCO V3, expose MCP tools, configure a client, or start a server. A compatible agent host must support the Agent Skills format, and the DPCO MCP server must be separately configured and running.

## Supported task families

The checked-in capability manifest and MCP input schemas cover:

- `solve_linear` — a single linear equation `a*x + b = c`.
- `solve_system` — legacy single-variable systems with `eqs`.
- `solve_system_multivar` — linear systems with `matrix` and `rhs`.
- `intersect_lines`.
- `verify_point_on_line`.
- `verify_point_on_circle`.
- `verify_tangency`.
- `intersect_line_circle`, with irrational coordinates explicitly unsupported.

The agent must query `dpco_list_capabilities` at runtime. Registered or implemented capabilities do not imply admission. DPCO does not currently advertise 3D geometry, nonlinear algebra, general symbolic algebra, geometric construction, or generic proof verification.

## Requirements

- An agent host that can load Agent Skills and expose MCP tools to the agent.
- A separately installed DPCO V3 project with dependencies installed.
- A compatible MCP client connection to DPCO. The client must be configured independently.

## Use

Read [SKILL.md](./dpco/SKILL.md), then install the [`dpco/`](./dpco/) directory in an Agent Skills location supported by the host. For example, VS Code documents workspace skills under `.github/skills/<name>/`; other hosts may use different installation paths and behavior.

For DPCO startup and client setup, see [installation.md](./dpco/references/installation.md). For task and response contracts, see [tool-reference.md](./dpco/references/tool-reference.md).

## Compatibility status

- **Format:** follows the published Agent Skills `SKILL.md` directory/frontmatter format.
- **VS Code / GitHub Copilot:** expected to work where the current host enables Agent Skills and MCP together; this Skill package has not been tested with a live Copilot agent.
- **Google Antigravity, Gemini CLI, and other hosts:** expected only if the product supports Agent Skills and MCP connections; compatibility has not been verified here.
- **Real-agent validation:** not yet performed.

## Environment check

The read-only script checks Node.js and npm without a DPCO path. To also check the DPCO project and its dependencies, set `DPCO_PROJECT_DIR`:

```sh
./dpco/scripts/check-dpco-environment.sh
DPCO_PROJECT_DIR=/path/to/DPCO_V3 ./dpco/scripts/check-dpco-environment.sh
```

It does not install dependencies, start servers, modify configuration, or contact external services.

## License

MIT. See [LICENSE](./LICENSE).
