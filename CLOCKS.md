# Clocks

Every platform this system has read the real time on, and which origin answered
there. One line each, added the first time a session on a platform not already
listed produced a timestamp.

Nobody is asked to add a line. It arrives because somebody ran the thing on a
machine nobody had run it on, which is the only kind of signal this system counts
(`SYSTEM.md` §7). Its sibling is [`LANGUAGES.md`](LANGUAGES.md): one records the
languages the system has explained itself in, this one the machines it has been
able to tell the time on.

| Platform (`uname -s`) | Origin that answered | First recorded |
|---|---|---|
| `MINGW64_NT` | `python-zoneinfo` | 2026-08-11 |

## Why a record of clocks at all

The header on every reply carries the real time, and a header that cannot be
built is the system's most visible promise going quiet. That failure is not
uniform: it belongs to a platform, not to a user. Git Bash on Windows ships no
IANA zone database at all, so every zone but UTC failed there and each Windows
copy rediscovered it alone.

A row here is the opposite of that. It says: **on this platform, this origin
produced a time.** The next agent that lands on it starts from a measurement
rather than from a first failure.

## What a line means, exactly

**One session, on one platform, got a real timestamp through that origin.** That
is the whole claim.

It does not mean the platform is supported, tested, or maintained. It does not
mean the other origin fails there. It does not mean anyone is still using it.
The file cannot see any of that, and a list of platforms read as a support matrix
is a vanity number wearing evidence's clothes.

## What a line never carries

**Not the timezone.** A zone is a location, and this record stays a record of
machines (§7). Not the machine, the user, the repository, or any date finer than
the day.

The platform name is `uname -s` cut at its first dash, which is what keeps a
Windows build number out of the file. A build number is closer to a fingerprint
than to a platform.

**One honest risk, stated before anyone adds a line rather than after:** an
unusual platform narrows who you might be, the same way an unusual language does
in `LANGUAGES.md`. The first line for a platform is the one that carries that
cost, and it is the Principal's call whether the signal is worth it. Adding one
is never required, and the clock works identically whether or not this file ever
names your machine.

## Adding one

`tools/clocks.sh` runs at session start and says nothing unless this platform and
origin are absent here. When it speaks, `bash tools/clocks.sh --line` prints the
row, and it goes to the canon as a one-line pull request, reviewed like anything
else (§6). It carries no version bump, the same as a `knowledge/` entry: a
version is a template release and this is not one.

It happens once per platform and origin, ever. The file grows by use and stops
growing on its own when the reach stops widening, which is itself worth knowing.
