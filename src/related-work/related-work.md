# Related Work

## Propaganda Techniques Corpus

The Propaganda Techniques Corpus [@da-san-martino-2019-fine] introduced
the eighteen-technique taxonomy and a sentence-level annotation scheme
that the present dataset follows. Subsequent shared tasks at
NLP4IF [@da-san-martino-2020-semeval] framed the problem as binary
detection and as eighteen-way classification; we adopt the simpler
nine-way variant used in the assignment.

## Text Classification for Propaganda

Classical approaches to propaganda and persuasion-style classification
have relied on lexical and stylistic features fed to linear models
[@rashkin-2017-truth; @yasser-2020-explainable]. These remain strong
baselines because propaganda techniques are, by their nature,
lexically anchored. Transformer-based models, especially domain-adapted
ones, push the numbers higher [@morales-2022-context; @hidey-2020-weet],
but at a cost in compute and reproducibility.

## Span Detection

Inside-outside and BIO tagging with linear-chain CRFs were the standard
approach before transformers [@tjong-kim-sang-2003-introduction]. They
remain attractive in low-resource and interpretable settings because
the state machine makes the decision rule auditable. Recent work has
moved to span-prediction heads on top of contextual encoders, but at
the cost of transparency.

## Probabilistic Set Membership in NLP

Bloom filters have been used for vocabulary membership in large-scale
NLP systems [@broder-2004-network] and for compact lookup of frequent
n-grams. We are not aware of prior use in propaganda detection
specifically; we adopt them here as a lightweight exposure-tracking
mechanism that supports both preprocessing and error analysis.
