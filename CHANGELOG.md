## Unreleased

- Add shadcn-style base/accent color composition through `MyBaseColor`,
  `MyAccentColor`, and `MyColorScheme.fromParts`.
- Add `mauve`, `olive`, `mist`, and `taupe` Tailwind palette constants and
  base-only color scheme presets.
- Export `MyMauveColorScheme`, `MyOliveColorScheme`, `MyMistColorScheme`, and
  `MyTaupeColorScheme` as first-class built-in scheme classes.
- Replace the separate `MyThemeSwitcher` and `MyColorSwitcher` widgets with a
  single base/accent-aware `MyThemePicker` and dialog API.
- Align overlapping built-in semantic tokens with current official shadcn
  OKLCH values converted to Flutter sRGB colors, excluding sidebar/radius.
- Update built-in chart palettes to the official shadcn chart token values.
- Expand `MyColorScheme` from 25 to 29 colors with semantic warning/success
  foreground pairs.
- Add matching light and dark defaults to all built-in color schemes.
- Require the 4 new status colors in direct construction and serialized color
  maps.
- Keep official sidebar tokens out of the serialized color-scheme contract.
- Keep `slate` and `gray` out of the base/accent picker path.

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
