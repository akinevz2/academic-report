# Show Hyphens — VS Code extension

This small extension runs `pdflatex` on the active `.tex` file, extracts output produced by `\showhyphens{...}` (preferably wrapped in markers), and surfaces hyphenation suggestions as editor diagnostics.

Usage
- Add a small check block in your `.tex` (temporary):

```
\AtEndDocument{%
  \typeout{--- Hyphenation checks start ---}%
  \showhyphens{supercalifragilisticexpialidocious}%
  \showhyphens{extraordinary}%
  \typeout{--- Hyphenation checks end ---}%
}
```

- Open the `.tex` in VS Code and run the command **Show Hyphenation** (Command Palette).
- The extension runs `pdflatex`, parses the `.log`, and creates in-editor diagnostics showing hyphenation points.

Notes
- Requires `pdflatex` on PATH.
- You need to compile with `\showhyphens{...}` inserted (remove after use).

Development

From the `vscode-showhyphens` folder:

```bash
npm install
npm run compile
```

Then debug/run the extension from VS Code.
