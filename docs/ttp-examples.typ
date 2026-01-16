#import "../lib.typ": ttp, ttp-full

#set page(paper: "a4", margin: 2cm)

= TTP Reference Examples

== Inline Usage

The attacker used #ttp("T1059.001") (PowerShell) to execute malicious commands.
They then established persistence via #ttp("T1053.005") and attempted credential
dumping with #ttp("T1003.001").

== With Technique Names

Detection of #ttp("T1059.001", name: "PowerShell", show-name: true) activity
followed by #ttp("T1055", name: "Process Injection", show-name: true).

== With Tactic Context

*Attack Chain:*

- #ttp-full("T1566.001", tactic: "Initial Access", name: "Spearphishing Attachment")
- #ttp-full("T1059.001", tactic: "Execution", name: "PowerShell")
- #ttp-full("T1547.001", tactic: "Persistence", name: "Registry Run Keys")
- #ttp-full("T1055", tactic: "Defense Evasion", name: "Process Injection")
- #ttp-full("T1003.001", tactic: "Credential Access", name: "LSASS Memory")
- #ttp-full("T1041", tactic: "Exfiltration", name: "Exfiltration Over C2")

== All Links Are Clickable

Click any TTP to open MITRE ATT&CK:
#ttp("T1059") | #ttp("T1055") | #ttp("T1003") | #ttp("T1547")
