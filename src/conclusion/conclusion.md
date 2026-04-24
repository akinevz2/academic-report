# Conclusion

This report evaluated a locally hosted, tool-calling LLM system as a constrained engineering artefact and assessed agentic coding as a practical development workflow. The central result is not that the system achieved broad autonomy, but that bounded agentic workflows can be useful when orchestration boundaries, tool contracts, and validation practices are explicit.

Against the first research question, the implementation demonstrated that local LLM-assisted project inspection can produce grounded outputs for bounded operations, particularly where retrieval and tool responses are tightly coupled to repository context. Against the second question, the most influential architectural choices were deterministic dispatch boundaries, frontend-backend orchestration decoupling, and persistent state support. These decisions improved maintainability and diagnosis, even when final-build reliability remained uneven.

Against the third question, agentic coding accelerated implementation and iteration in many cases, but introduced supervision and validation costs that remained significant. Productivity gains were strongest for structured, repeatable tasks and weaker for unstable integration paths where environment and runtime constraints dominated.

The project also exposed clear limitations. Packaging-stage regressions, incomplete feature parity, and incomplete early metric instrumentation constrained the strength of end-stage reliability claims. For that reason, conclusions are intentionally bounded to this implementation context and hardware profile.

The immediate next step is to complete and run a substantial scenario-based evaluation suite that quantifies success rate, tool-call validity, retry burden, latency distribution, and failure-category frequency. That evidence will allow the report to move from largely architecture-grounded conclusions to stronger, reproducible agentic model analysis tied directly to measured behavior.
