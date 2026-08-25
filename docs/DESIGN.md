# Design

## The invariant

A training example built for a past point in time must only see data
as it existed at that time — not as it looks today. Anything a model
sees during training that would not have existed yet in production is
a leak, and it will make the model perform worse live than it appeared
to perform during evaluation.

## The minimal mechanism

Guaranteeing that invariant only requires two things:

1. Every piece of incoming data is stored with the timestamp it
   actually arrived, and it is never edited or overwritten in place.
   New information becomes a new record, not a correction to an old
   one.
2. Any time a training set (or a claim like "we knew this X days
   early") is built by looking back at history, the query must filter
   by that arrival timestamp — asking "what had we recorded by time T"
   rather than "what do we know now."

That is the entire mechanism. No specialized infrastructure is
required to satisfy it — it is a data modeling and query discipline.

## Two ways this invariant gets broken, and which one this project proves

There are two distinct ways a system can fail to guarantee the
invariant above:

**(a) The source itself overwrites its own history.** Some external
sources correct or update records in place — a sanctions list entry
whose status changes, for example — with no record kept of what the
entry said before the correction. If a pipeline queries such a source
directly, the honest historical answer may already be gone.

**(b) The source never overwrites anything, but the query does not
respect time.** A source can be a perfectly well-behaved, append-only
log, and the leak can still happen, because whoever queries it forgets
to bound the query by an arrival-time cutoff and instead counts
everything that exists today as if it had always been known.

This project demonstrates **(b)** concretely, using real public data,
because it can be proven without needing a source that behaves badly
— the failure can be shown to exist purely from a missing filter, on
data that is otherwise completely honest. (a) is not fabricated or
simulated here, because doing so would mean inventing a source with a
bug rather than proving one exists.

**Both failure modes are fixed by the same mechanism.** For (b), the
fix is simply to always query the existing append-only log with a
time boundary. For (a), the fix is to build your own append-only
record of the source's state at the moment it arrives, before it has
a chance to be overwritten — turning a badly-behaved source into a
well-behaved one from your system's point of view. The same
underlying discipline — capture on arrival, always query with a
cutoff — covers both.

## Why this project does not adopt a feature store

Tools like Feast and Tecton exist to solve this same invariant, along
with two other problems: serving features to a live model at low
latency, and letting many models or teams share the same feature
definitions without recomputing them differently. Those two additional
problems only matter once there is a real production serving system
and a team large enough to need shared definitions — neither of which
applies to this scoped, single-source demonstration.

Adopting a named framework without knowing the scale, latency
requirements, or team structure it would need to support would be
reaching for a tool before the constraints that justify it exist. The
invariant itself does not require a feature store to prove — it
requires an append-only store and a correctly time-bounded query, both
of which are implemented directly in this project. At a company's
actual scale, with a live serving system and multiple consumers of the
same features, a feature store is exactly the kind of tool that would
operationalize this pattern — but that is a separate decision, made
with real information about the system it needs to fit.