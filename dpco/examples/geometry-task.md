# Example: 2D Line Intersection

The user asks for the exact intersection of `x + y = 5` and `x - y = 1`.

1. Call `dpco_list_capabilities`; confirm the live response includes `intersect_lines`.
2. Call `dpco_validate_task`:

```json
{
  "task": {
    "id": "geometry-intersection-001",
    "operation": "intersect_lines",
    "params": {
      "l1": { "a": "1", "b": "1", "c": "-5" },
      "l2": { "a": "1", "b": "-1", "c": "-1" }
    },
    "constraints": { "exact": true }
  }
}
```

3. Inspect the actual validation response. Call `dpco_execute_task` only if the task is valid and current admission makes it eligible.
4. If execution is blocked, report its returned status and reason; do not claim a computed intersection.
5. If execution succeeds, report only the returned geometry and verification status. Explain that DPCO checked this supported 2D line-intersection operation.

The request is an example of a supported input shape, not a fabricated MCP result. Runtime admission and execution outcome must come from the connected server.
