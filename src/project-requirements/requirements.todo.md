# Requirements — Notes

## 1. Model Selection (Hard Requirement)

- Required meeting VRAM limits while supporting tool-calling, which only became available with later model generations
- Iterated through approaches: usage monitor → accuracy verifier (run two models side by side, check agreement) → settled on evaluation harness measuring prompt accuracy and test pass %
- The requirement was not satisfiable until Qwen 3.6 arrived — earlier Qwen 2.5 Coder lacked tool-calling, forcing manual parsing
- Resolution: harness approach with a model within VRAM budget that natively supports tool-calling

## 2. Hardware Specs (Simple Requirement)

- 24GB workstation scoped to run common model sizes: 6GB–12GB single GPU, up to 24GB for dual PCIe-slot setups
- Easy to define because 24GB workstation is a well-known hardware boundary for users building workstations in this class
- The 24GB figure was valid from the start, but the model capability wasn't until later in the project

## 3. Most Sacrificed: Testing & Multi-Provider

- Testing harness and verification pipeline were partially delegated to the LLM agent — time-consuming to implement
- Multi-provider interface explicitly deferred (too much work to add on top of Quarkus constraints)
- Testing harness deferred because *defining what to test* requires more time than *implementing the tests*

## 4. Framework Trade-Off: Quarkus

- Pragmatic choice to avoid building a REST client from scratch — saving time
- Enabled rapid skeleton construction so the agent could work autonomously
- Late-stage Quarkus CDI packaging regressions prevented full feature parity

## 5. Core Constraint: Spec Boundary

- Hardest boundary: defining what the LLM could implement vs. not touch
- Qwen 2.5 Coder: assumed in-house autonomous dev, but lacked capability
- GPT-5.1 (Copilot): unlocked capability but required explicit style/architecture steering to prevent drift
- Key insight: when using an autonomous generator, scope is a continuous steering process, not a static requirement
- The generator produces coherent output (to itself), not necessarily coherent *to your spec*
