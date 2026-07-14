# Kinhold ZK ML Inference

Tiny Kinhold Noir package for thresholded linear inference.

This is an **experimental circuit package**, not a full ML proving system or a
production inference proof. The canonical circuit is `src/main.nr`.

## Constraint

For four elements, the circuit computes:

```text
score = sum(private_inputs[i] * model_weights[i]) + bias
activation = (score as u32) > 100
```

It then constrains `activation` to equal the claimed public
`expected_activation`.

This is unsigned field arithmetic followed by a `u32` cast. It does not model
signed values, quantization, overflow policy, tensors, layers, or a committed
private model.

## Input layout

Arguments appear in this order:

| Name | Visibility | Type | Meaning |
| --- | --- | --- | --- |
| `private_inputs` | private | `[Field; 4]` | inference features |
| `model_weights` | public | `[Field; 4]` | linear model weights |
| `bias` | public | `Field` | additive model bias |
| `expected_activation` | public | `Field` | must be `0` or `1` through the equality constraint |

`Prover.toml` is a checked-in sample whose names exactly match these circuit
arguments. Generated files under `target/` are intentionally ignored.

## Toolchain and checks

CI installs the exact `nargo 1.0.0-beta.21` release and runs:

```bash
nargo check
nargo test
nargo execute
```

Nargo rejects prerelease values in the manifest's `compiler_version`
requirement, so CI and this document are the authoritative pin. Tests cover
active and inactive scores, the exact threshold, one above the threshold, and
rejection of a false public activation claim.

## Package and release status

- Current status: unreleased proof-of-concept.
- First intended tag: `v0.1.0` after the numeric domain and public-input
  encoding are specified.
- `0.x` releases may change the circuit interface and invalidate proofs.
- Production use requires range constraints, test vectors, benchmarks, and
  security review.
