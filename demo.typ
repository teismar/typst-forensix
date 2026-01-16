
#import "lib.typ": hexdump

#set page(paper: "a4", margin: 2cm)

= Forensix Hex Dump Demo

#let data = (
  0x4d,
  0x5a,
  0x90,
  0x00,
  0x03,
  0x00,
  0x00,
  0x00,
  0x04,
  0x00,
  0x00,
  0x00,
  0xff,
  0xff,
  0x00,
  0x00,
  0xb8,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x40,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0xDe,
  0xAd,
  0xBe,
  0xEf,
  0x0A, // Extra bytes
)

== Basic Hex Dump
#hexdump(data: data)

== Highlighted & Annotated
#hexdump(
  data: data,
  highlight: (0x4d, 0x5a, 0xDe, 0xAd, 0xBe, 0xEf),
  annotations: (
    "0": "MZ",
    "15": "testwrap",
    "40": "EOPGS",
  ),
  columns: 8,
)
== Custom Styling
#hexdump(
  data: data,
  highlight: (
    "0x4d": blue.lighten(50%),
    "10": red.lighten(50%),
  ),
  highlight-ranges: (
    (start: 40, end: 44, color: orange.lighten(50%)),
  ),
  style: (
    font: (size: 8pt),
    offset: (color: purple),
    annotation: (color: olive),
    highlight: (default: orange),
  ),
  annotations: (
    "0x00": "BlueHeader",
    "40": "RangeStart",
  ),
)

=== Annotations with Custom Colors

#hexdump(
  data: bytes("Hello World"),
  annotations: (
    "0": "Start",
    "6": (text: "Space", color: green),
    "10": (text: "End", color: blue),
  ),
)

== File Input (reading `typst.toml`)
#hexdump(file: "/typst.toml", columns: 8)

== String Input
#hexdump(data: "Hello World from Forensix!")

== Partial Partial (Ranges)
#hexdump(
  file: "/typst.toml",
  columns: 16,
  print-ranges: (
    (start: 0, end: 16),
    (start: 64, end: 80),
  ),
)

== All

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
    "0x6a": teal,
    "0xcc": blue.lighten(30%),
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
    font: (size: 8pt),
    offset: (color: purple, weight: 600),
    highlight: (
      default: yellow.lighten(50%),
      text: black,
    ),
  ),
)