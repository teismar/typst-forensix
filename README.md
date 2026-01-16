# Forensix

Forensix is a Typst toolkit for reverse engineering reports. Each module focuses on a typical DFIR task while keeping presentation quality high.

## Modules

### Hex Dump Module

Render professional hex dumps with highlighting, annotations, and selective range printing.

#### Usage

```typ
#import "@preview/forensix": hexdump

#let data = read("malware.bin", encoding: none)

#hexdump(
  data,
  columns: 16,
  highlight: (0x90, 0xCC), // Highlight NOPs and INT3
  annotations: (
    "0": "Start of Header",
    "128": "Entry Point"
  )
)
```

#### Features

- Offset | Hex | ASCII layout tuned for print and PDF.
- Highlight individual byte values or full ranges to emphasize patterns.
- Annotate offsets with short labels or styled callouts for contextual notes.
- Render data from in-memory bytes, strings, or files; optionally print select ranges.

#### Configuration Options

- `columns`: Controls bytes per row (default 16).
- `highlight`: Accepts integers or mapping to colors for per-byte styling.
- `highlight-ranges`: Provide `(start, end, color)` tuples for contiguous spans.
- `annotations`: Map offsets to labels or `(text, color)` records; labels render above bytes.
- `style`: Override fonts, colors, and spacing to match report branding.
- `print-ranges`: Limit output to selected `(start, end)` spans without truncating context.

#### Extended Example

```typ
#import "@preview/forensix": hexdump

#let shellcode = (
  0x6a, 0x01, 0x5b, 0x31, 0xc0, 0x88, 0x43, 0x07,
  0x89, 0x5b, 0x08, 0x8d, 0x4b, 0x08, 0x31, 0xd2,
  0x31, 0xc9, 0x8d, 0x73, 0x08, 0xcd, 0x80, 0xcc,
  0xcc, 0x90, 0x90, 0x90, 0x90, 0xe8, 0x00, 0x00,
  0x00, 0x00, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73,
  0x68, 0x00,
)

#hexdump(
  data: shellcode,
  columns: 8,
  highlight: (
    0x90,
    "0x6a": teal,
    "0xcc": crimson.lighten(30%),
  ),
  highlight-ranges: (
    (start: 16, end: 24, color: orange.lighten(40%)),
  ),
  annotations: (
    "0": "PUSH(1)",
    "7": (text: "state byte", color: gray),
    "24": (text: "NOP sled", color: green.darken(20%)),
    "32": "exec path",
  ),
  print-ranges: (
    (start: 0, end: 24),
    (start: 24, end: 40),
  ),
  style: (
    font: (size: 8pt, family: "Fira Code"),
    offset: (color: purple, weight: 600),
    annotation: (color: navy, baseline: 1em),
    highlight: (
      default: yellow.lighten(50%),
      text: black,
    ),
  ),
)
```

#### Screenshots

- ![Hex dump overview](docs/screenshots/hexdump-overview.png)
- ![Annotated ranges](docs/screenshots/hexdump-annotations.png)

## Roadmap

-> Look at the issues on [GitHub](https://github.com/teismar/typst-forensix/issues) for planned features and enhancements.
