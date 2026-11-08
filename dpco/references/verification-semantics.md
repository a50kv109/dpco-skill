# Verification and Status Semantics

Always report execution outcome and verification outcome separately. Use the actual MCP response, not an inferred or fabricated result.

The status mapping follows the published [DPCO Core models](https://github.com/a50kv109/dpco-v3/blob/main/src/core/models.ts), [verifier](https://github.com/a50kv109/dpco-v3/blob/main/src/core/verifier.ts), and [MCP response contract](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/contracts.ts).

## Execution statuses

- **`SUCCESS`**: Core reports successful execution. This does not by itself mean the mathematical result is verified; inspect `verificationStatus`.
- **`BLOCKED`**: Core stopped execution due to validation, contradiction policy, capability, qualification, or admission. No successful mathematical execution should be claimed.
- **`FAILED`**: Core reports failed execution.
- **`REJECTED`**: MCP task fields or operation parameters were invalid or unsupported by the adapter contract.
- **`ERROR`**: Unexpected Core processing error; the adapter indicates that no ledger result was returned.

`dpco_validate_task.valid` means the input passed the adapter/Core validation checks. `executionEligible` reports whether there is a compatible admitted candidate at validation time. Neither means the computation ran.

## Verification statuses

- **`VERIFIED`**: The existing IndependentVerifier accepted the operation-specific check. State what was checked; do not extend the claim beyond the verifier's guarantee.
- **`UNVERIFIED`**: No successful independent verification was established. Do not present the value as DPCO-verified, even if the agent independently believes it is correct.
- **`NOT_APPLICABLE`**: Core did not apply a normal result verification, for example when execution produced an error or no verifiable result.

The separate `claimVerdict` may be `TRUE`, `FALSE`, `UNKNOWN`, or `NOT_APPLICABLE`. It is not interchangeable with `verificationStatus`.

## Admission

Executor registration or a manifest `AVAILABLE` label is not an admission grant. The MCP tools do not issue grants, create qualification evidence, accept executor overrides, or enable diagnostic mode. A fresh server is expected to remain fail-closed for production execution. Report the actual `blockedReason` and Core response.

Never attempt to change the decision by adding unrecognized task fields or asserting authority in a prompt.

## Evidence and provenance

`evidenceIds` and `grantId` are returned by execution when present. Do not invent them or treat their presence as proof of a broader theorem. `dpco_get_result` returns a ledger record only from the current Core/session; local server ledgers are in-memory and reset on process/session lifetime.

The ledger record hash does not cover every output field, including the complete multivariable solution map and geometry payload. Do not describe it as a cryptographic commitment to the entire returned mathematical result.

## Operation-specific limits

- Multivariable `VERIFIED` means the computed vector passed the exact residual check against the supplied system. It does not prove uniqueness. Executor and verifier share the Fraction/BigInt implementation, so a common-mode defect is possible.
- Geometry verification checks the specific predicate/intersection semantics implemented by DPCO. It does not prove a general construction or an unrelated geometric claim.
- Exact arithmetic means supported rational-domain operations; irrational line-circle coordinates are explicitly unsupported.
