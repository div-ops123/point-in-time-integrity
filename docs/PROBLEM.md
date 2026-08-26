# Problem Definition

## The claim being examined

Ekho Labs' product depends on knowing about disruptions before they
are publicly confirmed. Their value to a customer comes from lead
time — days or weeks of warning that other companies do not have yet.

## Why that claim is harder to guarantee than it looks

A system like this has to pull from many outside sources — things
like sanctions lists, shipping registries, port notices, and news
feeds. If a model is trained by looking back at these sources as they
appear *today*, it may end up training on more information than it
would have actually had at that point in the past. When the same
model runs live, it only ever sees the messy, incomplete state of the
world as it existed in that moment, because the future has not
happened yet. The model can end up learning from an easier version of
history than the one it is actually asked to handle in production.

This gap can come from two different places, and it is worth being
precise about which one this project demonstrates:

- **A source rewrites its own history.** Some outside sources correct
  or update a record in place — for example, a registry entry whose
  status changes with no trace kept of what it said before. If a
  pipeline queries a source like this directly, the honest historical
  answer may already be gone.
- **A source never rewrites anything, but the query does not respect
  time.** A source can be perfectly well-behaved — every new piece of
  information added as a new record, nothing ever edited — and the
  leak can still happen, if whoever queries it forgets to ask "what
  had been recorded by this date" and instead counts everything that
  exists today as if it had always been known.

## What this problem is called, precisely

This is a form of **train/serve skew** — a mismatch between what a
model sees during training and what it sees while running live. It is
worth naming the exact cause here, because "train/serve skew" is
often used to describe something else, like two pieces of code
computing the same feature in two different ways.

Here, the cause is more specific: a lack of **point-in-time
correctness** in the data layer. The pipeline is not reproducing "what
did we know as of this date" — it is reproducing "what do we know
now, applied to an old date." Those are not the same question, and
the gap between them is where the skew comes from.

## What this project does and does not do

This project does not attempt to rebuild or replicate Ekho Labs'
actual data pipeline. It does not assume Ekho Labs has this problem
today — this is a general failure mode that can appear in any system
that fuses many outside sources into live forecasts, not a claim
about their specific engineering.

To make the problem concrete, this project uses one public, freely
available data source: GDELT, a database of world news events, chosen
because it is structured the same general way as the kinds of sources
a company like this would use — high-volume, continuously updated,
extracted from text.

Initial investigation of GDELT's actual format showed that its
records are append-only rather than revised in place — new
information becomes new records, not corrections to old ones. This
means the specific failure mode demonstrated here is the second one
above: a well-behaved, honest data source, queried without a time
boundary. Using real events tied to the Strait of Hormuz crisis in
early 2026, this project shows that counting all related events known
"today" and treating that as the historical picture for an earlier
date overstates what was actually known at the time by roughly
**10.7x** (75 events known today, versus 7 that had actually been
recorded as of the earlier date). The full numbers and query are in
`results/` and `queries/`.

Both failure modes are addressed in `docs/DESIGN.md`, including why
the same underlying fix — capture data on arrival, always query with
a time cutoff — resolves either one.