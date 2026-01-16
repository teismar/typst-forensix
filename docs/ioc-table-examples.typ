#import "../lib.typ": ioc, ioc-table

#set page(paper: "a4", margin: 2cm)

= IOC Table Examples

== Auto-Detected & Defanged
#ioc-table(
  title: "Malicious Indicators",
  indicators: (
    "http://evil.com/malware.exe",
    "https://phishing-site.net/login.php",
    "192.168.1.55",
    "10.0.0.1",
    "44d88612fea8a8f36de82e1278abb02f",
    "da39a3ee5e6b4b0d3255bfef95601890afd80709",
    "attacker@malware-domain.com",
    "c2-server.evil.org",
  ),
)

== With Manual Type Override
#ioc-table(
  title: "Custom IOC Types",
  indicators: (
    "http://download.evil.com/payload.bin",
    ioc("HKLM\\Software\\Malware\\Config", type: "Registry"),
    ioc("evil_service", type: "Service"),
    "255.255.255.0",
  ),
  show-original: true,
)

== Custom Headers
#ioc-table(
  title: "Threat Intelligence",
  indicators: (
    "http://bad-actor.com",
    "192.168.100.50",
  ),
  type-header: "Category",
  indicator-header: "IOC (Sanitized)",
)
