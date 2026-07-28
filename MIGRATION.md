# Migration to 0.1.0

1. Pin the `v0.1.0` Git tag.
2. Replace `package:common_tools/index.dart` and deep imports with a documented
   entrypoint such as `common_tools.dart`, `components/forms.dart`, or
   `extensions/string.dart`.
3. Install `MyUILayer` in `MaterialApp.builder`.
4. Pass a context below `MyUILayer` to toast and loading operations.
5. Replace public `XFile` usage with `MyPickedFile`.
6. Replace `url_launcher` configuration types with `MyLaunchMode`,
   `MyWebViewConfiguration`, and `MyBrowserConfiguration`.

Theme construction and Lucide icon APIs are unchanged.

## Unreleased color-scheme migration

`MyColorScheme` now requires these additional colors:

- `warning` and `warningForeground`
- `success` and `successForeground`

The example-owned AAGSA color schemes are now package built-ins:

- Replace `aagsa-red` with `brown`.
- Replace `aagsa-gold` with `gold`.
- Replace `aagsa-neutral` with `black`.

The old `aagsa-*` identifiers are intentionally not kept as aliases.

Base and accent colors can now be composed without changing the serialized
color-scheme contract:

- Use `MyColorScheme.fromParts(base: MyBaseColor.taupe)` for a base-only
  shadcn-style scheme.
- Use `MyColorScheme.fromParts(base: MyBaseColor.mauve,
  accent: MyAccentColor.blue)` to keep mauve surfaces with blue brand tokens.
- `MyColorScheme.toColorMap()` still emits 29 colors and no `sidebar*` keys.

Overlapping built-in schemes now use current official shadcn token values
converted from OKLCH to Flutter sRGB:

- Existing serialized color maps remain structurally valid but may no longer
  match the package defaults exactly.
- Chart colors changed to official shadcn `chart-1` through `chart-5` values.
- `fromParts` keeps focus rings base-derived and applies the selected accent to
  primary and chart tokens.
