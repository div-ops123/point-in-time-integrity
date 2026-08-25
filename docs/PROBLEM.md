# Problem Definition

## The claim being examined

Ekho Labs' product depends on knowing about disruptions before they
are publicly confirmed. Their value to a customer comes from lead
time — days or weeks of warning that other companies do not have yet.

## Why that claim is harder to guarantee than it looks

A system like this has to pull from many outside sources — things
like sanctions lists, shipping registries, port notices, and news
feeds. These sources are not fixed once published. Many of them get
corrected, updated, or backdated after the fact. A sanctions entry
can appear today but carry an effective date from two weeks ago. A
news article can be quietly corrected after its first publication. A
port notice can be reclassified once more information comes in.

This creates a gap. If a model is trained by looking back at these
sources as they appear *today*, it is training on a version of the
past that has already been cleaned up and corrected. But when the
same model runs live, it only ever sees the messy, incomplete,
not-yet-corrected version of the world, because the future has not
happened yet and cannot be cleaned up in advance. The model ends up
learning from an easier version of history than the one it is
actually asked to handle in production.

## What this problem is called, precisely

This is a form of **train/serve skew** — a mismatch between what a
model sees during training and what it sees while running live. But
it is worth naming the exact cause, because "train/serve skew" is
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
that fuses many outside, revisable sources into live forecasts, not a
claim about their specific engineering.

To make the problem concrete, this project uses one public,
freely available data source that is known to get revised after
initial publication: GDELT, a global database of news events. The
goal is to show the mechanism clearly on a small, real example — not
to build a large-scale system.

<!-- Fill in after building the worked example: one short paragraph
naming the specific event/date window used from GDELT, and a one-line
preview of the result (e.g. "the naive approach shows the signal
X days earlier than it was actually available"). -->