// Helper to check if a byte is printable ASCII
#let is-printable(b) = {
  b >= 32 and b <= 126
}

// Helper to parse flexible keys
#let parse-key(k) = {
  if type(k) == int { k } else if type(k) == str {
    if k.starts-with("0x") {
      let val = 0
      let hex-digits = "0123456789abcdef"
      let clean-k = lower(k.slice(2))
      for i in range(clean-k.len()) {
        let char = clean-k.at(i)
        let digit = hex-digits.position(char)
        if digit != none {
          val = val * 16 + digit
        } else {
          return none
        }
      }
      val
    } else {
      int(k)
    }
  } else { none }
}

// Monospaced fonts stack
#let mono-fonts = ("DejaVu Sans Mono", "Liberation Mono")

/// Renders a hex dump of the given data.
#let hexdump(
  data: none,
  file: none,
  columns: 16,
  highlight: (),
  highlight-ranges: (),
  print-ranges: (),
  annotations: (:),
  style: (:),
) = {
  // Input Resolution
  let raw-data = if file != none {
    read(file, encoding: none)
  } else {
    data
  }

  let bytes-data = if type(raw-data) == bytes {
    array(raw-data)
  } else if type(raw-data) == str {
    array(bytes(raw-data))
  } else if type(raw-data) == array {
    raw-data
  } else {
    ()
  }

  // Define default style
  let default-style = (
    font: (size: 9pt, family: mono-fonts),
    annotation: (size: 9pt, color: red.darken(20%), weight: "bold", y-offset: -1.0em),
    offset: (color: blue, weight: "regular"),
    highlight: (default: yellow),
  )

  // Merge user style
  let s = default-style
  if "font" in style { s.font = s.font + style.font }
  if "annotation" in style { s.annotation = s.annotation + style.annotation }
  if "offset" in style { s.offset = s.offset + style.offset }
  if "highlight" in style { s.highlight = s.highlight + style.highlight }

  // Pre-process highlights
  let byte-highlights = (:)
  if type(highlight) == array {
    for b in highlight {
      byte-highlights.insert(str(b), s.highlight.default)
    }
  } else if type(highlight) == dictionary {
    for (k, v) in highlight {
      let val = parse-key(k)
      if val != none {
        byte-highlights.insert(str(val), v)
      }
    }
  }

  // Pre-process annotations
  let clean-annotations = (:)
  for (k, v) in annotations {
    let offset = parse-key(k)
    if offset != none {
      clean-annotations.insert(str(offset), v)
    }
  }

  // Helper: Check if a range of bytes has any annotations
  let range-has-annotation(start, end) = {
    let found = false
    for i in range(start, end) {
      if str(i) in clean-annotations {
        found = true
        break
      }
    }
    found
  }

  // Cell styling
  let cell-style(body, fill: none) = {
    block(
      fill: fill,
      inset: (x: 2pt, y: 2pt),
      radius: 2pt,
      body,
    )
  }

  // Helper to generate rows
  let generate-chunk-rows(start-offset, end-offset) = {
    let chunk-rows = ()
    let len = end-offset - start-offset

    let aligned-start = int(start-offset / columns) * columns
    let aligned-end = calc.ceil(end-offset / columns) * columns
    let num-rows = int((aligned-end - aligned-start) / columns)

    for r in range(num-rows) {
      let row-start-addr = aligned-start + (r * columns)

      let val-start = calc.max(row-start-addr, start-offset)
      let val-end = calc.min(row-start-addr + columns, end-offset)

      if val-end <= val-start { continue }

      // Offset Column
      let offset-str = str(row-start-addr, base: 16)
      let pad-len = 8 - offset-str.len()
      let offset-padded = "0" * pad-len + offset-str
      let offset-fmt = text(fill: s.offset.color, size: s.font.size, font: s.font.family, weight: s.offset.at(
        "weight",
        default: "regular",
      ))[#raw(offset-padded)]
      chunk-rows.push(offset-fmt)

      // Hex Columns
      let hex-cells = ()
      for i in range(columns) {
        let abs-idx = row-start-addr + i

        if abs-idx >= start-offset and abs-idx < end-offset and abs-idx < bytes-data.len() {
          let b = bytes-data.at(abs-idx)
          let b-hex = str(b, base: 16)
          if b-hex.len() < 2 { b-hex = "0" + b-hex }

          // Highlight logic
          let bg = none
          let txt-col = none // Initialize to none instead of auto

          // Range Highlight
          for r in highlight-ranges {
            if abs-idx >= r.at("start") and abs-idx < r.at("end") {
              bg = r.at("color", default: s.highlight.default)
              break
            }
          }
          // Specific Byte Highlight
          if bg == none and str(b) in byte-highlights {
            bg = byte-highlights.at(str(b))
          }

          // Text color contrast check
          if bg != none and "text" in s.highlight {
            txt-col = s.highlight.text
          }

          // Render content with conditional text color
          let content = if txt-col != none {
            text(size: s.font.size, font: s.font.family, fill: txt-col)[#upper(raw(b-hex))]
          } else {
            text(size: s.font.size, font: s.font.family)[#upper(raw(b-hex))]
          }

          // Annotations Logic
          if str(abs-idx) in clean-annotations {
            let note-entry = clean-annotations.at(str(abs-idx))
            let note-text = ""
            let note-color = s.annotation.color

            if type(note-entry) == dictionary {
              note-text = note-entry.at("text", default: "")
              if "color" in note-entry { note-color = note-entry.color }
            } else {
              note-text = note-entry
            }

            // Replace spaces with non-breaking spaces to prevent line breaks
            let note-text-nowrap = note-text.replace(" ", sym.space.nobreak)

            content = box(
              content
                + place(
                  left + top,
                  dy: s.annotation.y-offset,
                  text(size: s.annotation.size, fill: note-color, weight: s.annotation.weight)[#note-text-nowrap],
                ),
            )
          }

          hex-cells.push(cell-style(content, fill: bg))
        } else {
          hex-cells.push(text(size: s.font.size, font: s.font.family)[#h(1.2em)])
        }

        if columns == 16 and i == 7 { hex-cells.push([]) }
      }
      for c in hex-cells { chunk-rows.push(c) }

      // ASCII Column
      let ascii-chars = ""
      for i in range(columns) {
        let abs-idx = row-start-addr + i
        if abs-idx >= start-offset and abs-idx < end-offset and abs-idx < bytes-data.len() {
          let b = bytes-data.at(abs-idx)
          if is-printable(b) { ascii-chars += str.from-unicode(b) } else { ascii-chars += "." }
        } else {
          ascii-chars += " "
        }
      }
      chunk-rows.push(text(size: s.font.size, font: s.font.family)[|#raw(ascii-chars)|])
    }
    chunk-rows
  }

  // --- Determine Ranges ---
  let final-ranges = ()
  if print-ranges == none or print-ranges.len() == 0 {
    final-ranges.push((start: 0, end: bytes-data.len()))
  } else {
    for r in print-ranges {
      final-ranges.push(r)
    }
  }

  // --- Top Spacer (only for first row to avoid colliding with content above) ---
  let top-spacer = none
  if final-ranges.len() > 0 {
    let r0 = final-ranges.at(0)
    let aligned-start = int(r0.start / columns) * columns
    if range-has-annotation(aligned-start, aligned-start + columns) {
      top-spacer = v(calc.abs(s.annotation.y-offset))
    }
  }

  // --- Table Generation & Gutter Logic ---
  let all-rows = ()
  let row-gutters = ()

  let hex-cols-def = (auto,) * columns
  if columns == 16 { hex-cols-def = (auto,) * 8 + (0.5em,) + (auto,) * 8 }
  let table-cols = (auto,) + hex-cols-def + (auto,)

  let separator-row = (
    table.cell(colspan: table-cols.len(), align: center, inset: (y: 0pt), text(
      size: s.font.size,
      fill: black,
      weight: "bold",
    )[\[...\]]),
  )

  // Removed annot-space - using uniform row gutters

  for (i, r) in final-ranges.enumerate() {
    let chunk = generate-chunk-rows(r.start, r.end)
    let nr = int(chunk.len() / table-cols.len())

    for row-idx in range(nr) {
      let slice-start = row-idx * table-cols.len()
      let slice-end = slice-start + table-cols.len()
      for c in chunk.slice(slice-start, slice-end) {
        all-rows.push(c)
      }

      let is-last-chunk = (i == final-ranges.len() - 1)
      let is-last-row-of-chunk = (row-idx == nr - 1)

      if not is-last-row-of-chunk {
        row-gutters.push(0.8em)
      } else {
        let needs-mid-separator = not is-last-chunk
        let needs-end-separator = is-last-chunk and r.end < bytes-data.len()

        if needs-mid-separator or needs-end-separator {
          row-gutters.push(0.2em)
          for c in separator-row { all-rows.push(c) }

          row-gutters.push(0.2em)
        }
      }
    }
  }

  {
    if top-spacer != none { top-spacer }
    table(
      columns: table-cols,
      stroke: none,
      align: (col, row) => {
        if col == 0 { right + horizon } else if col == table-cols.len() - 1 { left + horizon } else { center + horizon }
      },
      inset: (x: 1pt, y: 4pt),
      row-gutter: row-gutters,
      column-gutter: 0.2em,
      ..all-rows
    )
  }
}
