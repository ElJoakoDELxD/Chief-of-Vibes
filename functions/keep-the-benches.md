---
function: Keep the benches green
verified: a dated bench failure was found by running it, and fixed
---

# Keep the benches green

Run the benches, and fix or report every red one.

## What it does

1. Run `bash tools/ready.sh`, which reports every bench and the version parity.
2. Fix a red bench, or say what could not be done and why. Silence is not an option.
3. Read the failure before the code. A bench can be wrong, and a bench edited to go green
   without an argument is worse than a red one.

## The failure this exists for

A bench once asserted a literal offset for a zone that observes daylight saving. It passed for
months and went red the day the clocks moved, with the tool under test behaving correctly
throughout. **A test that pins a wall-clock value has an expiry date**, and nothing but
running it finds that.
