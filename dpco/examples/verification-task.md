# Example: Check a Proposed Root

The user claims that `x = 3/2` solves `2x = 3`.

1. Check that `solve_linear` is present in `dpco_list_capabilities`.
2. Validate a task with the equation and proposed claim:

```json
{
  "task": {
    "id": "verify-linear-claim-001",
    "operation": "solve_linear",
    "params": { "a": "2", "b": "0", "c": "3" },
    "claim": { "x": "3/2" },
    "constraints": { "exact": true }
  }
}
```

3. If valid and execution eligible, call `dpco_execute_task`. DPCO must perform its own execution and verifier path; do not replace that with the agent's mental arithmetic.
4. Read `verificationStatus` and `claimVerdict` independently. Only report DPCO verification if the actual response says `VERIFIED`; explain the claim verdict separately.
5. If execution is blocked, say DPCO could not evaluate the claim because of the reported gate. The agent may separately explain its own arithmetic, clearly labeled as its reasoning rather than a DPCO result.

No expected tool response is embedded here. The result depends on the connected server and its current Admission state.
