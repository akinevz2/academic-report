## A. System Diagrams and Architecture Charts

### A.1 Tool Execution Sequence

![Tool execution sequence diagram](images/tool-execution-sequence.png){width=100%}

Execution flow summary:

1. The LLM runtime sends a request to the tool service.
2. The service iterates across available modules and selects a handler that can process the tool name.
3. The selected module validates and parses arguments before dispatch.
4. The dispatched operation executes and returns a string result to the service.
5. The service returns the result to the LLM runtime.
