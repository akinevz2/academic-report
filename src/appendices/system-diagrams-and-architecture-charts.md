## A. System Diagrams and Architecture Charts

### A.1 Tool Execution Sequence

![Tool execution sequence diagram](images/tool-execution-sequence.png){width=100%}

Execution flow summary:

1. The LLM runtime emits a tool execution request (`name` + JSON `arguments`) as part of the assistant turn.
2. The assistant runtime validates the request (registered tool name and parseable JSON arguments).
3. The request is passed to a registry that resolves the executor by direct tool-name lookup in a dispatch map.
4. The resolved executor invokes the concrete tool operation and returns a string result (or error string).
5. The assistant runtime wraps the result as a tool-result message and sends it back to the model for follow-up generation.
