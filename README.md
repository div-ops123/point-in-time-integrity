# Point-in-Time Data Integrity for Multi-Source Forecasting

## Why this exists

Forecasting systems that combine many real-world data sources (news,
registries, sensor feeds, official notices) face a quiet risk: many of
these sources get corrected, revised, or backdated after they are first
published. If a model is trained using the "current" version of a source
instead of the version that existed at the time, the model learns from
a cleaner past than it will ever see in production. This is a form of
train/serve skew, caused specifically by a lack of point-in-time
correctness in the data layer.

This project demonstrates the problem concretely, and shows a minimal
design that prevents it.

## What this shows

<!-- Fill in after building: one or two sentences stating the concrete
result — e.g. "the naive approach reports the signal as available
X days earlier than it actually was; the corrected approach reports Y." -->

<!-- Insert the before/after chart or table here once the worked
example is done. -->

## How it's organized

- [`docs/PROBLEM.md`](docs/PROBLEM.md) — the problem, defined precisely,
  and what is in and out of scope.
- [`docs/DESIGN.md`](docs/DESIGN.md) — the minimal design that solves it,
  and the reasoning behind not reaching for a larger framework.
- [`src/`](src) — the code for the worked example.
- [`notebooks/`](notebooks) — <!-- fill in: how the worked example is
  run, or delete this line if you end up using scripts instead -->

## The worked example

<!-- Fill in after building: which public data source was used (GDELT),
what the naive join did, what the correct as-of join did, and what
changed between the two. Keep this to a few sentences — the docs/
files hold the full reasoning. -->

## How to run it

<!-- Fill in after building: setup steps, e.g. "pip install -r
requirements.txt" and "python src/run_comparison.py" -->

## Scope

This project does not attempt to replicate Ekho Labs' full data
pipeline. It uses one public, freely available data source to
demonstrate a general failure mode that applies to any system built
the way theirs is — real-time forecasting from many external sources.
It is an independent exercise, not a claim about how Ekho Labs' actual
system works.