# Expedient Trickle Sync (ETS)

> An adaptive synchronization algorithm for mobile devices that attempts to balance the cost of data transmission against the cost of making decisions using stale information.

## Background

Expedient Trickle Sync (ETS) was developed as part of my Master's research in Computer Science at the University of Victoria (2007–2009).

This work grew out of earlier research into mobile synchronization systems, including the author’s Honours B.Sc. thesis project, jSyncManager. Practical experience applying synchronization technology to mobile electronic medical records systems motivated the exploration of adaptive synchronization policies presented here.

The project explored a simple adaptive synchronization strategy for occasionally connected mobile devices. Rather than synchronizing data at fixed intervals, ETS periodically evaluates the expected cost of continuing to operate with stale data and synchronizes only when that expected cost exceeds the cost of transmitting the updated information.

At the time this work was conducted, mobile devices were significantly more resource constrained than they are today. CPU performance, battery life, memory, and wireless data costs all influenced the design of the algorithm.

The accompanying thesis is available through the University of Victoria's institutional repository:

> Barclay, Brad J. *Expedient Trickle Sync: A Cost-Based Synchronization Algorithm for Mobile Devices*. University of Victoria, 2009.  
> <http://hdl.handle.net/1828/1335>

## Repository Status

This repository is provided primarily for historical and archival purposes.

The code represents the implementation used during my Master's research and has been migrated from its original SourceForge repository to GitHub to ensure its long-term preservation.

The project is **not actively maintained**.

## Project Overview

The repository contains:

- **SyncSimulationFramework** — simulation framework used to evaluate synchronization strategies
- **SyncSimulator** — simulator implementing ETS and comparison algorithms
- Supporting Objective-C code used to model synchronization costs, mobile device behavior, and experimental scenarios

The implementation was written for approximately 2005–2007 era Apple hardware and software using Objective-C.

## Research Summary

ETS attempts to minimize the total expected synchronization cost by balancing two competing factors:

- **Transmission Cost**
  - CPU usage
  - Battery consumption
  - Wireless network costs
  - Synchronization overhead

- **Staleness Cost**
  - Decisions made using outdated information
  - Reduced application accuracy
  - Operational cost resulting from stale data

Rather than synchronizing immediately whenever data changes, ETS estimates the expected cost of remaining out of sync and performs synchronization only when that cost exceeds a dynamically maintained threshold.

## Looking Back

Nearly two decades later, there are a number of aspects of the project I would approach differently.

Examples include:

- Initializing the adaptive threshold from simulation rather than learning entirely online.
- Using integer arithmetic throughout instead of floating-point values to better suit the hardware available at the time.
- Exploring multiple adaptive thresholds (for example, varying by time of day) rather than relying on a single global threshold.
- Investigating prediction-based decision policies instead of a single threshold-based model.

These observations reflect the benefit of hindsight and subsequent engineering experience rather than deficiencies in the original research goals.

## Historical Note

This code predates the widespread adoption of smartphones, inexpensive mobile data, cloud synchronization, and modern machine learning techniques.

Many of the engineering trade-offs explored here—balancing communication cost against information freshness—remain relevant today, although modern systems often approach these problems using significantly more computational power and richer predictive models.

## Trivia

The original working title for this project was **Fast And Reliable Trickle Sync (FARTS)**.

After careful consideration—and several minutes of entirely mature discussion—it was decided that a Master's thesis would be better served by a different acronym.

Thus, **Expedient Trickle Sync (ETS)** was born.

## License

This project is preserved in its original form. See the accompanying license file for licensing information.

## Citation

If you reference this work in academic publications, please cite:

> Barclay, Brad J. *Expedient Trickle Sync: A Cost-Based Synchronization Algorithm for Mobile Devices*. Master of Science Thesis, Department of Computer Science, University of Victoria, 2009.

Persistent identifier: http://hdl.handle.net/1828/1335

## Author

**Brad J. Barclay**

Originally developed as part of the requirements for the Master of Science degree,
Department of Computer Science,
University of Victoria.
