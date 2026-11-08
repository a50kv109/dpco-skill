# DPCO V3 Verification Model

## Separate stages and statuses

DPCO separates validation/admission, execution, claim assessment, result verification, and recording. The MCP response has distinct execution status, claim verdict, and verification status. Never infer one from another.

Conceptually:

`Admission → Executor → IndependentVerifier → Ledger`

Validation and the contradiction gate occur before this sequence; classification follows verification before the final ledger record.

Source: [DPCO Core pipeline](https://github.com/a50kv109/dpco-v3/blob/main/src/core/dpcoCore.ts), [status types](https://github.com/a50kv109/dpco-v3/blob/main/src/core/models.ts), [MCP response contract](https://github.com/a50kv109/dpco-v3/blob/main/src/integrations/mcp/contracts.ts).

## Admission

The registry checks operation compatibility, active production role/grant, and evidence appropriate to requested rigor and domain. Core initialization does not automatically grant production admission or seed passing-test evidence. Enabling or registering an executor alone does not qualify it. The MCP adapter provides no grant-issuing or evidence-ingestion tool.

`BLOCKED` means the task was stopped by validation, contradiction, capability, qualification, or admission policy. It is not a computed answer and does not mean the math was disproved.

## Execution and verification

Executors produce candidate results for their registered operations. The verifier applies operation-specific checks:

- Linear equations/systems: substitution or residual.
- Multivariable systems: exact residual check that the returned vector satisfies `A·x=b`; not uniqueness.
- Supported geometry: exact incidence, intersection, or tangency predicates.

The verifier's name should not be read as a claim of formal proof or fully independent implementation. Exact executor and verifier code share rational `Fraction`/BigInt arithmetic, which creates common-mode risk. The geometry verifier's guarantees are bounded to the predicates and rational domain implemented.

## Status meanings

| Status | Meaning | What an agent may conclude |
|---|---|---|
| `VERIFIED` | The applicable DPCO verifier check passed for the returned result. | State that DPCO verified the operation-specific property, and explain its scope. Do not claim a universal proof, completeness, uniqueness unless specifically established, or freedom from common-mode defects. |
| `UNVERIFIED` | A result did not pass verification, or execution was blocked before verification. | Do not present the result as verified. Report the returned reason and status. A blocked task is not evidence that the proposed math is false. |
| `NOT_APPLICABLE` | No verification check applies, often because execution failed or produced no candidate. | Do not describe the result as checked. Explain that no applicable verification occurred. |
| `BLOCKED` (execution) | Admission, validation, contradiction, or capability policy prevented execution. | Report that no successful computation was performed; do not retry by bypassing policy. |
| `SUCCESS` (execution) | Core execution completed. | Do not equate this with `VERIFIED`; inspect `verificationStatus` separately. |

`claimVerdict` is a separate field (`TRUE`, `FALSE`, `UNKNOWN`, or `NOT_APPLICABLE`) and should be reported independently from the verification status.

## Evidence and provenance

The response may include grant IDs, evidence IDs, pipeline steps, and a ledger record hash. These identify the in-memory records used or produced; they are not externally signed attestations. The ledger hash chain is not an external anchor, and the current record hash does not commit every returned mathematical payload. Do not describe evidence IDs or `recordHash` as proof beyond what their contract establishes.

`dpco_get_result` looks up the most recent matching task ID in the current server process/Core. It does not imply durable storage across process restarts.

Sources: [EvidenceRegistry](https://github.com/a50kv109/dpco-v3/blob/main/src/core/evidence.ts), [ExecutionLedger](https://github.com/a50kv109/dpco-v3/blob/main/src/core/ledger.ts), [MCP security](https://github.com/a50kv109/dpco-v3/blob/main/docs/MCP_SECURITY.md), [known limitations](https://github.com/a50kv109/dpco-v3/blob/main/docs/KNOWN_LIMITATIONS.md).
