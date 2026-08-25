# Journal

A running log of what was actually tried, what the data showed, and
where the plan changed. Kept separate from DESIGN.md, which holds the
cleaned-up reasoning — this file holds the real order events happened
in, including the parts that didn't work.

## Choosing BigQuery over CSV downloads

GDELT's raw files are published in 15-minute batches, one file per
window. The task needed here — checking how many mentions a single
event had accumulated as of a specific cutoff versus today, across a
span of weeks — means searching across a large number of those files
for one ID. Downloading and merging thousands of 15-minute files to
cover that span is the wrong shape for the problem. BigQuery's public
GDELT dataset lets the same question be asked directly as a query
across the full history at once, so that was used instead of local
CSV downloads.

## First candidate search

Queried the `events` table for records geocoded near Hormuz within the
known crisis window (late Feb–March 2026), ordered by `NumMentions`.
This returned a shortlist of `GlobalEventID`s to investigate further.

## First single-event comparison

Picked the top candidate and ran two queries against the `eventmentions`
table: total mentions with a 24-hour time cutoff from the event's first
record, and total mentions with no cutoff at all. Both returned the
same result: 1. The event had only ever been mentioned once, in total
— there was no growth to measure, so no leak to demonstrate on this
particular ID.

## Optimizing for quota

Running one query per candidate was going to burn through BigQuery
sandbox quota quickly. Combined multiple candidate IDs and multiple
time cutoffs into a single query using `IN (...)` and `COUNTIF(...)`,
and added an explicit date-range filter to keep BigQuery from scanning
the full historical table for each check. This cut the problem down to
one query call per round of testing instead of one call per candidate.

## Widening the candidate list, and the actual pivot

Pulled a larger set of Hormuz-related candidates (20 event IDs) to
screen at once. Looking at that list directly showed something the
single-candidate test had missed: several different `GlobalEventID`s
shared the exact same `SOURCEURL`, and every candidate topped out at a
`NumMentions` of 8 or fewer.

This pointed to a structural fact about GDELT rather than a bad
candidate pick: a single article discussing an ongoing crisis is
typically split into several distinct event records (one per extracted
claim), and a new article covering the same ongoing story tends to
create new event records rather than adding mentions to an existing
one. For a fast-moving story like an active war, individual events
mostly don't accumulate mentions over time the way a single, static
news story would.

This changed the shape of the demonstration. Instead of watching one
event's mention count grow, the project now measures the total count
of Hormuz-related event records known by a given cutoff versus known
today — the same underlying question ("what did we actually know as
of this date") applied at the level the data actually supports.