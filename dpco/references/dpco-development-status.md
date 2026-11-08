# DPCO V3 Development Status

This is a documentation snapshot based on the public DPCO V3 source and its published status/validation reports. “Implemented” does not mean every input or use case has been exhaustively proven. Do not describe the local unpublished HTTP work as part of the public release.

## Implemented and tested

The published [status page](https://github.com/a50kv109/dpco-v3/blob/main/docs/STATUS.md) reports:

- Core validation, contradiction gate, registry, and dispatcher.
- Exact rational arithmetic with BigInt.
- Optional multivariable linear solver and residual verifier.
- Discrete 2D geometry operations and verifier.
- Evidence ingestion and fail-closed initialization.
- Hash-chained execution ledger.
- Named local checks in the 2026-11-08 validation snapshot: TypeScript check, production build, original acceptance matrix (54/54), and multivariable suite (39/39).

These are finite test results for listed fixtures, not a proof of correctness for all possible inputs.

## Implemented; deployment or broader validation needed

- **STDIO MCP:** included in public `main` with `npm run mcp` and four registered tools. Host-specific MCP configuration and a running server are required.
- **Production admission:** implemented and fail-closed. A default server does not automatically qualify executors; a capability listing does not imply execution eligibility.
- **MCP integration tests:** source includes a `test:mcp` script, but this Skill documentation update did not execute it. Check the original project's current test records before making a fresh test claim.
- **Process isolation:** an in-process wrapper exists, but it does not provide OS/container isolation or force-stop synchronous computations.

## Planned / designed

- **DEAS-1 external execution runtime:** designed only; no running external executor bridge.
- **SOL runtime / SOL-Triad adapter:** out of the published Core scope; not integrated.

## Not implemented or not established

- Public/remote MCP hosting, OAuth, HTTPS service configuration, and network authentication.
- A public Streamable HTTP service. A loopback-only HTTP implementation exists in a separate local working copy, but its source and `mcp:http` script are absent from public `dpco-v3/main` as inspected on 2026-11-08.
- General symbolic/nonlinear algebra, a generic proof checker, general geometry theorem proving, and 3D geometry.
- Cryptographically authenticated evidence submitters, externally signed admission grants, durable qualification storage, and externally anchored ledger records.
- Complete mathematical correctness or fully independent verifier implementation; rational executor and verifier code share arithmetic components.
- The published status report marks browser/UI behavior, live API integration, process/container isolation, and legacy Python tests as not tested in its validation pass.

## Sources

- [DPCO V3 status](https://github.com/a50kv109/dpco-v3/blob/main/docs/STATUS.md)
- [Validation report](https://github.com/a50kv109/dpco-v3/blob/main/docs/DPCO_V3_VALIDATION_REPORT.md)
- [Architecture](https://github.com/a50kv109/dpco-v3/blob/main/docs/DPCO_V3_ARCHITECTURE.md)
- [Known limitations](https://github.com/a50kv109/dpco-v3/blob/main/docs/KNOWN_LIMITATIONS.md)
- [MCP integration](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_INTEGRATION.md)
