## B. System Diagrams and Architecture Charts

### B.1 Tool Execution Sequence

```mermaid
sequenceDiagram
	participant LLM as LLM Runtime
	participant TS as ToolService
	participant TM as ToolModule (Toolset)
	participant TT as ToolMacroToolset
	participant TR as ToolMacroRegistry
	participant M as ToolMacro

	LLM->>TS: execute(request, memoryId)
	TS->>TM: canHandle(toolName)? (iterative)
	TM-->>TS: true/false
	TS->>TT: execute(request, memoryId)
	TT->>TT: parse JSON args
	TT->>TR: execute(name, args, memoryId)
	TR->>TR: canonicalName(alias -> canonical)
	TR->>M: execute(args, memoryId)
	M-->>TR: String result
	TR-->>TT: String result
	TT-->>TS: String result
	TS-->>LLM: String result
```

### B.2 Architecture Notes

- Dispatch layer: service selects module by tool name capability.
- Module layer: each toolset groups related operations.
- Macro layer: single-responsibility command objects execute tool behavior.
- Persistence layer: read-context observations are cached for later tool calls.

### B.3 Frontend Workspace Snapshot

- Main UI screenshot: `docs/screenshots/main-workspace.png`
