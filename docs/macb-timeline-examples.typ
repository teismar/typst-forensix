#import "../lib.typ": file-entry, folder-entry, macb-timeline

#set page(paper: "a4", margin: 2cm)

= MACB Timeline Examples

== Basic File Tree
#macb-timeline(
  title: "C:\\Users\\Admin\\Documents\\",
  entries: (
    folder-entry(
      "C:\\Users\\Admin\\Documents\\",
      depth: 0,
      modified: "2023-10-27 02:00:00",
      accessed: "2023-10-27 02:01:15",
      changed: "2023-10-27 02:00:00",
      birth: "2023-10-27 02:00:00",
    ),
    file-entry(
      "report.docx",
      depth: 1,
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

== Timestomping Detection
#macb-timeline(
  title: "Evidence of Timestomping",
  entries: (
    folder-entry(
      "C:\\Windows\\System32\\",
      depth: 0,
      modified: "2023-01-15 10:30:00",
      accessed: "2023-10-27 03:45:22",
      changed: "2023-01-15 10:30:00",
      birth: "2022-06-01 12:00:00",
    ),
    file-entry(
      "svchost_fake.exe",
      depth: 1,
      modified: "2022-06-01 12:00:00",
      accessed: "2023-10-27 03:45:22",
      changed: "2023-10-27 03:44:58",
      birth: "2023-10-27 03:44:55",
      highlight: rgb("#fecaca"),
    ),
  ),
)
