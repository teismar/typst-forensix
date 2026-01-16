#import "../lib.typ": *

#set page(paper: "a4", margin: 2cm)

// Examples from README.md Quick Start section

= Forensix Quick Start Examples

== Hex Dump with Highlighting
#hexdump(
  data: (0x4d, 0x5a, 0x90, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00),
  highlight: (0x4d, 0x5a),
  theme: "dracula",
)

#v(1em)

== MACB Timeline
#macb-timeline(
  title: "Suspicious Directory",
  entries: (
    folder-entry(
      "C:\\Users\\Admin\\",
      depth: 0,
      modified: "2023-10-27 02:00:00",
      accessed: "2023-10-27 02:01:15",
      changed: "2023-10-27 02:00:00",
      birth: "2023-10-27 02:00:00",
    ),
    file-entry(
      "malware.exe",
      depth: 1,
      modified: "2023-10-27 02:00:00",
      accessed: "2023-10-27 02:01:15",
      changed: "2023-10-27 02:00:00",
      birth: "2023-10-27 02:00:00",
      highlight: rgb("#fecaca"),
    ),
  ),
)

#v(1em)

== IOC Table (Auto-Defangs)
#ioc-table(
  indicators: (
    "http://evil.com/payload.exe",
    "192.168.1.55",
    "44d88612fea8a8f36de82e1278abb02f",
  ),
)

#v(1em)

== Inline TTP References
The attacker used #ttp("T1059.001") for execution.
