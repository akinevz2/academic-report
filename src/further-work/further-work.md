# Further Work

Three directions stand out. First, the state machine for Task 2 could
be replaced with a linear-chain CRF, which gives the same
interpretability story but learns its own transition weights rather
than relying on hand-designed states. Second, the bag-of-words model
for Task 1 could be augmented with sentence-level context encoded as
a small transformer, keeping the linear head but adding the contextual
features that propaganda detection appears to need. Third, the Bloom
filter idea generalises to a compact exposure log: every training
example could be hashed into a per-class filter, supporting cheap
near-duplicate detection and curriculum learning.
