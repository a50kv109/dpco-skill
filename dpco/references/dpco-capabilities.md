# DPCO V3 Capability Catalogue

This catalogue follows the public [capability manifest](https://github.com/a50kv109/dpco-v3/blob/main/src/core/capabilityManifest.ts) and [MCP input contracts](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/contracts.ts). Query `dpco_list_capabilities` at runtime; capability registration is not admission.

Numeric values accepted by the MCP schema are finite JSON numbers or non-empty numeric strings. Strings are recommended when exact decimal/rational input semantics matter. Geometry line inputs use `a*x + b*y + c = 0`; omitted `c` defaults to zero in the geometry parser.

| Operation | Input under `task.params` | Result and verification | Implementation / production boundary |
|---|---|---|---|
| `solve_linear` | `{ "a": value, "b": value, "c": value }` for `a*x + b = c` | Root; verifier substitutes the candidate into the equation. | Manifest: `AVAILABLE`. Production dispatch still requires an admitted compatible executor. |
| `solve_system` (legacy) | `{ "eqs": [{ "a": value, "b": value, "c": value }, ...] }` | Single-variable root; checks the candidate against the equations. | Manifest: `AVAILABLE`; one-variable systems only. |
| `solve_system_multivar` | `{ "matrix": numberOrString[][], "rhs": numberOrString[] }` | Solution map; exact residual verifier checks `A·x=b`. | Implemented and enabled by the default MCP Core, but no automatic admission. Residual does not prove uniqueness. Rows and columns are schema-limited to 32. |
| `intersect_lines` | `{ "l1": line, "l2": line }` | Exact result status `POINT`, `PARALLEL`, or `COINCIDENT`; point coordinates for a point result. | Manifest: `AVAILABLE`; 2D only. |
| `verify_point_on_line` | `{ "point": { "x": value, "y": value }, "line": line }` | Exact point-line incidence predicate and verification status. | Manifest: `AVAILABLE`. |
| `verify_point_on_circle` | `{ "point": point, "circle": circle }` | Exact point-circle incidence predicate and verification status. | Manifest: `AVAILABLE`. |
| `verify_tangency` | `{ "line": line, "circle": circle }` | Exact line-circle tangency predicate; checks a discriminant/residual relation. | Manifest: `AVAILABLE`. |
| `intersect_line_circle` | `{ "line": line, "circle": circle }` | Exact intersections when coordinates are rational; otherwise `UNSUPPORTED_IRRATIONAL_DOMAIN`. | Manifest: `AVAILABLE` over Q; irrational coordinates are unsupported, not approximated. |

`line` is `{ "a": value, "b": value, "c"?: value }`. `circle` is `{ "center": point, "r": value }` or `{ "center": point, "rSquared": value }`. MCP schemas require the circle to provide either `r` or `rSquared`.

## Status interpretation

- Manifest or runtime registration indicates an implementation/candidate, not a production grant.
- `solve_system_multivar` is enabled in the MCP Core factory, but a fresh server has no automatically issued admission grant or qualification evidence; production execution can therefore be blocked.
- Unsupported shapes, mismatched dimensions, invalid values, and unsupported irrational-domain results must be reported as returned. Do not convert a failure or unsupported case into a fabricated approximate success.
- The operation-specific `verification` method and epistemic scope are defined in the manifest; they are not interchangeable with a general proof.

## Source links

- [Capability manifest](https://github.com/a50kv109/dpco-v3/blob/main/src/core/capabilityManifest.ts)
- [MCP operation schemas](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/contracts.ts)
- [MCP tool adapter](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/adapter.ts)
- [Exact 2D geometry implementation](https://github.com/a50kv109/dpco-v3/blob/main/src/core/geometry.ts)
- [Executor implementations](https://github.com/a50kv109/dpco-v3/blob/main/src/core/executors.ts)
- [Verifier](https://github.com/a50kv109/dpco-v3/blob/main/src/core/verifier.ts)
