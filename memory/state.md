---
agent:                     # the agent's name
principal:                 # how it addresses the person it works for
language:                  # replies are ALWAYS in this language, never mirroring input
timezone:                  # IANA zone; drives every timestamp. Outranks $COV_TZ,
                           # which answers only where this file cannot be read
goal:                      # the standing objective all priorities serve
branch:                    # the agent's home branch
posts: []                  # the posts this agent holds, by name from posts/ (§9)
created:
---

# No agent on this branch

This is the empty form. **A branch where `agent:` carries no value holds no agent**, and the
system only listens there. `.claude/skills/onboard/` fills it, on a branch of the agent's own,
and a filled form never comes back to `main` (SYSTEM.md §5).
