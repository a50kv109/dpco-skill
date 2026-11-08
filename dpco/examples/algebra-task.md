# Example: Solve a Linear Equation

The user asks to solve `2x + 1 = 4`.

1. Discover `solve_linear` with `dpco_list_capabilities`.
2. Validate this task:

```json
{
  "task": {
    "id": "linear-equation-001",
    "operation": "solve_linear",
    "params": { "a": "2", "b": "1", "c": "4" },
    "constraints": { "exact": true }
  }
}
```

3. If validation says it is valid and execution is eligible, call `dpco_execute_task` with the same task.
4. Interpret the actual `status`, `executionStatus`, and `verificationStatus` fields. If blocked by admission, tell the user no execution was performed. If successful but unverified, do not call the result verified.
5. If a result is returned, explain the equation and the verification scope in plain language.

This example shows a supported task request; it does not assert an execution result or guarantee admission.
