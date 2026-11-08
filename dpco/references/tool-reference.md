# DPCO MCP Tool Reference

This reference reflects `src/integrations/mcp/contracts.ts` and `src/integrations/mcp/adapter.ts`. The MCP client returns tool content and, when supported, `structuredContent`; inspect the actual response rather than assuming a tool succeeded.

## 1. `dpco_list_capabilities`

**Input:** no arguments.

**Output fields:**

- `manifestVersion`: string.
- `transport`: `stdio` or `streamable-http`.
- `capabilities`: entries containing `operation`, `coreOperation`, `summary`, `paramsSummary`, `implementationStatus`, `registeredExecutors`, `executorRoles`, and `productionAdmissionRequired: true`.

Use this to discover manifest capabilities and current executor registrations. A listed operation, `AVAILABLE` status, or registration is not proof of production admission.

## 2. `dpco_validate_task`

**Input:**

```json
{
  "task": {
    "id": "caller-defined-id",
    "operation": "solve_linear",
    "params": { "a": "2", "b": "0", "c": "3" },
    "constraints": { "exact": true }
  }
}
```

The tool contract wraps one `task` object. Task fields are `id`, `operation`, `params`, optional `claim`, and optional `constraints`. `id` must be a non-empty string up to 128 characters; task JSON is limited to 64 KiB. Unsupported task fields are rejected.

`constraints` allows `exact`, `required_rigor` (`TESTED`, `INSTANCE_VERIFIED`, `DOMAIN_VERIFIED`), and `domain`. Parameter schemas are operation-specific; see [mathematical workflows](./mathematical-workflows.md).

**Output fields:** `valid`, `operation`, `coreOperation`, `issues`, `compatibleExecutors`, `executionEligible`, `blockedReason`.

Validation does not execute the task or change Admission state.

## 3. `dpco_execute_task`

**Input:** same `{ "task": ... }` shape and operation parameter schemas as `dpco_validate_task`.

**Output fields:** `status` (`REJECTED`, `BLOCKED`, `FAILED`, `SUCCESS`, `ERROR`), `taskId`, `operation`, `coreOperation`, `executionStatus`, `claimVerdict`, `verificationStatus`, `reason`, `executor`, `grantId`, `evidenceIds`, `recordHash`, `result`, `steps`, and `issues`.

`result` is either null or an object with `root`, `systemSolution`, and `geometry`. `steps` reports pipeline stages. The tool calls Core in production mode; it does not grant admission. Execute only after valid input and current eligibility permit it. The Core's returned status is authoritative.

## 4. `dpco_get_result`

**Input:** `{ "taskId": "caller-defined-id" }`.

**Output:** `{ "found": boolean, "taskId": string, "record": ledger-record-or-null }`.

It looks up the latest matching task ID in the current Core/Ledger. On HTTP, each MCP session has a separate Core/Ledger; STDIO uses its process's Core. Results do not survive restart.

## Operation parameter shapes

| Operation | `params` |
|---|---|
| `solve_linear` | `{ "a": number-or-string, "b": number-or-string, "c": number-or-string }` for `a*x + b = c` |
| `solve_system` (legacy) | `{ "eqs": [{ "a": value, "b": value, "c": value }, ...] }` |
| `solve_system_multivar` | `{ "matrix": number-or-string[][], "rhs": number-or-string[] }` |
| `intersect_lines` | `{ "l1": line, "l2": line }` |
| `verify_point_on_line` | `{ "point": point, "line": line }` |
| `verify_point_on_circle` | `{ "point": point, "circle": circle }` |
| `verify_tangency` | `{ "line": line, "circle": circle }` |
| `intersect_line_circle` | `{ "line": line, "circle": circle }` |

`point` is `{x,y}`. `line` is `{a,b,c?}`, representing `a*x + b*y + c = 0`; `c` defaults to zero in the geometry parser. `circle` is `{center:{x,y}, r}` or `{center:{x,y}, rSquared}`. Matrix rows and columns are schema-limited to 32; Core performs additional checks.

For multivariable systems, use the public alias `solve_system_multivar`; the adapter maps it to Core's `solve_system` runtime operation. A `solve_system` task with `matrix`/`rhs` is also normalized to the multivariable route.
