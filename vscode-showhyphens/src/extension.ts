import * as vscode from 'vscode';
import * as cp from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import { promisify } from 'util';

const exec = promisify(cp.exec);

export function activate(context: vscode.ExtensionContext) {
  const output = vscode.window.createOutputChannel('ShowHyphens');
  const diagnostics = vscode.languages.createDiagnosticCollection('showhyphens');

  const disposable = vscode.commands.registerCommand('showhyphens.checkHyphenation', async () => {
    const editor = vscode.window.activeTextEditor;
    if (!editor) {
      vscode.window.showInformationMessage('Open a .tex file to check hyphenation.');
      return;
    }

    const doc = editor.document;
    if (!doc.fileName.endsWith('.tex')) {
      vscode.window.showInformationMessage('ShowHyphens works on .tex files.');
      return;
    }

    await doc.save();
    diagnostics.clear();
    output.clear();
    output.show(true);

    const filePath = doc.fileName;
    const cwd = path.dirname(filePath);
    const base = path.basename(filePath, '.tex');
    const logPath = path.join(cwd, base + '.log');

    output.appendLine(`Running pdflatex on ${filePath} ...`);

    try {
      // run pdflatex; don't fail if pdflatex returns nonzero — we still want the .log
      await exec(`pdflatex -interaction=nonstopmode -halt-on-error "${filePath}"`, {cwd});
      output.appendLine('pdflatex finished.');
    } catch (err: any) {
      output.appendLine('pdflatex finished with error (see log).');
      output.appendLine(String(err.stdout || err));
    }

    if (!fs.existsSync(logPath)) {
      vscode.window.showErrorMessage('No .log found after running pdflatex.');
      return;
    }

    const log = fs.readFileSync(logPath, 'utf8');

    // Prefer explicit markers inserted by the user; fall back to any hyphenated tokens in the log.
    const startMarker = '--- Hyphenation checks start ---';
    const endMarker = '--- Hyphenation checks end ---';

    let hyphenLines: string[] = [];
    if (log.includes(startMarker)) {
      const start = log.indexOf(startMarker) + startMarker.length;
      const end = log.indexOf(endMarker, start);
      const snippet = end > start ? log.substring(start, end) : log.substring(start);
      hyphenLines = snippet.split(/\r?\n/).map(s => s.trim()).filter(Boolean);
    } else {
      // extract tokens like "su-per-cali" (words containing at least one hyphen)
      const tokens = new Set<string>();
      const regex = /[A-Za-zÀ-ÖØ-öø-ÿ]+(?:-[A-Za-zÀ-ÖØ-öø-ÿ]+)+/g;
      let m: RegExpExecArray | null;
      while ((m = regex.exec(log)) !== null) tokens.add(m[0]);
      hyphenLines = Array.from(tokens);
    }

    if (hyphenLines.length === 0) {
      vscode.window.showInformationMessage('No hyphenation output found in the log. Add \"\\showhyphens{word}\" and markers to your .tex file.');
      output.appendLine('No hyphenation lines found.');
      return;
    }

    output.appendLine('Hyphenation results:');
    hyphenLines.forEach(l => output.appendLine('  ' + l));

    // Build diagnostics: for each hyphenated token, map back to occurrences of the unhyphenated word.
    const docText = doc.getText();
    const diagMap = new Map<string, vscode.Diagnostic[]>();

    hyphenLines.forEach(line => {
      // line might contain multiple tokens; split by whitespace or commas
      const parts = line.split(/[\s,;:+()\[\]]+/).filter(Boolean);
      parts.forEach(token => {
        if (!token.includes('-')) return;
        const original = token.replace(/-/g, '');
        const re = new RegExp(`\\b${escapeRegExp(original)}\\b`, 'gi');
        let m: RegExpExecArray | null;
        while ((m = re.exec(docText)) !== null) {
          const startPos = doc.positionAt(m.index);
          const endPos = doc.positionAt(m.index + m[0].length);
          const range = new vscode.Range(startPos, endPos);
          const message = `Hyphenation suggestion: ${token}`;
          const diag = new vscode.Diagnostic(range, message, vscode.DiagnosticSeverity.Information);
          diag.source = 'showhyphens';
          const key = doc.uri.toString();
          if (!diagMap.has(key)) diagMap.set(key, []);
          diagMap.get(key)!.push(diag);
        }
      });
    });

    diagMap.forEach((diags, uriStr) => {
      diagnostics.set(vscode.Uri.parse(uriStr), diags);
    });

    vscode.window.showInformationMessage(`ShowHyphens: parsed ${hyphenLines.length} hyphenation lines.`);
  });

  context.subscriptions.push(disposable, diagnostics, output);
}

export function deactivate() {}

function escapeRegExp(s: string) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
