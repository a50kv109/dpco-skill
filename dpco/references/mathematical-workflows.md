# Mathematical Workflows

Always discover capabilities and validate the task before requesting execution. Capability listings do not imply admission. Use rational values as strings when exact input is intended.

## Linear equation

For `a*x + b = c`, use `solve_linear` with `{a,b,c}`. DPCO supports rational exact arithmetic and floating-point execution according to the executor admitted by Core. Inspect both execution and verification statuses.

## Single-variable system

Use `solve_system` with `params.eqs`, where each equation is `{a,b,c}` and means `a*x + b = c`. Contradictory systems can be blocked by the ContradictionGate.

## Multivariable linear system

Use `solve_system_multivar` with a coefficient `matrix` and `rhs` vector. Exact rational strings preserve intended fractions. The Core operation is internally named `solve_system`; the MCP adapter performs this mapping.

The implementation supports rational linear systems, but underdetermined systems and zero-column matrices are unsupported. A residual check can show the returned particular vector satisfies the equations; it does not establish uniqueness or full column rank. Executor and residual verifier share Fraction arithmetic, creating a common-mode risk.

## 2D line and circle geometry

- `intersect_lines`: exact intersection classification `POINT`, `PARALLEL`, or `COINCIDENT`.
- `verify_point_on_line`: exact incidence check.
- `verify_point_on_circle`: exact incidence check.
- `verify_tangency`: exact line-circle tangency predicate.
- `intersect_line_circle`: exact rational intersection where supported; irrational coordinates are reported as unsupported rather than approximated.

Line parameters represent `a*x + b*y + c = 0`. A circle supplies a center and radius `r` or squared radius `rSquared`.

## Geometry constructions and unsupported work

The listed geometry operations evaluate predicates or intersections; they are not a general geometric-construction engine. Do not claim 3D geometry, nonlinear systems, generic symbolic manipulation, or an arbitrary theorem prover. For requests outside the live manifest/schema, tell the user that DPCO does not currently expose that capability.

## Handling a blocked task

If validation is invalid, report the actual issues and correct only the mathematical request with user intent preserved. If `executionEligible` is false or execution returns `BLOCKED`, report the actual blocker. Do not retry with diagnostic mode, forced executors, or invented evidence.
