#import "../lib.typ": hexdump

#set page(paper: "a4", margin: 2cm)

= Hex Dump Examples

== Basic Hex Dump
#hexdump(data: bytes("Hello World from Forensix!"))

== Theme: Dracula
#let sample = (0x4d, 0x5a, 0x90, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00)
#hexdump(data: sample, theme: "dracula", highlight: (0x4d, 0x5a))

== Theme: Matrix
#hexdump(data: sample, theme: "matrix")

== Theme: Cyberpunk
#hexdump(data: sample, theme: "cyberpunk")

== Highlighting & Annotations
#hexdump(
  data: sample,
  highlight: (0x4d, 0x5a),
  annotations: (
    "0": "MZ Header",
    "8": "Reserved",
  ),
)

== Byte Grouping (DWORD)
#hexdump(data: sample, group-bytes: 4)

== Virtual Address
#hexdump(data: sample, base-address: 0x00401000)

== Regions
#hexdump(
  data: sample,
  regions: (
    (start: 0, end: 8, label: "DOS Signature", color: blue.lighten(80%)),
    (start: 8, end: 16, label: "Header Data", color: green.lighten(80%)),
  ),
)
