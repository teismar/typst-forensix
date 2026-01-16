# Forensix

A professional Typst package for digital forensics, incident response, and malware analysis reports.

## Features

| Module | Description |
|--------|-------------|
| [Hex Dump](hexdump.md) | Canonical hex dumps with highlighting, annotations, themes |
| [MACB Timeline](macb-timeline.md) | File tree with MACB timestamps for forensic analysis |
| [IOC Table](ioc-table.md) | Auto-defanging indicators of compromise |
| [TTP References](ttp.md) | Inline MITRE ATT&CK technique cards |

## Installation

```typst
#import "@preview/forensix:0.1.0": *
```

## Quick Start

```typst
// Hex dump with highlighting
#hexdump(
  file: "/evidence/malware.bin",
  highlight: (0x4d, 0x5a),
  theme: "dracula",
)

// MACB timeline
#macb-timeline(entries: (
  folder-entry("C:\\Users\\Admin\\", depth: 0, ...),
  file-entry("malware.exe", depth: 1, highlight: rgb("#fecaca"), ...),
))

// IOC table (auto-defangs!)
#ioc-table(indicators: (
  "http://evil.com/payload.exe",
  "192.168.1.55",
  "44d88612fea8a8f36de82e1278abb02f",
))

// Inline TTP references
The attacker used #ttp("T1059.001") for execution.
```

### Output Example
![Examples](img/readme-quickstart.png)

## License

MIT
