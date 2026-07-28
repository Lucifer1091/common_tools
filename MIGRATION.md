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
