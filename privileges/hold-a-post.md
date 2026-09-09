---
privilege: Exercise a post at all
enforced_by: tools/models.sh, on a three-way exit where no reading is a refusal
held_by: every post, and each names which models the Principal approved for it
---

# Hold a post

A post may require an approved model. This is the grant that a session must obtain before it
exercises any function the post authorizes.

## What is mechanical

`tools/models.sh <model> <post>` compares the served model against the list the Principal
approved, and exits three ways: approved, refused by name, or **no reading at all**. The third is
a refusal and never a pass, because silence is exactly what let an unlisted model hold a post
through seven releases while nothing noticed.

## What is not

**Nothing in the environment names the served model.** No variable carries it, so a shell script
cannot ask. The reading arrives as an argument a session obtained from the runtime and passed in,
which makes obtaining it the agent's duty and judging it the tool's.

The list is identity and lives with the holder in `memory/posts/<post>.md`. The rule ships and
the list never does.
