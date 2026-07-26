## 0.1.0

- Redesign the repository as a private Git-tagged Flutter package.
- Add deliberate UI, component, extension, network, service, and utility
  entrypoints and move implementation code beneath `lib/src`.
- Preserve the existing inherited theme animation and Lucide integration.
- Add app-root-scoped toast/loading controllers and localization fallback.
- Add the package-owned `MyPickedFile` model.
- Fix image base64 conversion, upload file keys, and phone/SMS normalization.
- Require Flutter 3.44+ and Dart 3.12+.

This is an intentional pre-1.0 API break. See `MIGRATION.md`.
