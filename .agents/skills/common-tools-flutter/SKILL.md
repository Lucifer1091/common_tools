---
name: common-tools-flutter
description: Use the private common_tools Flutter package accurately. Trigger when building, changing, reviewing, or explaining Dart code that uses common_tools, My-prefixed widgets and themes, package extensions, layouts, overlays, networking, files, services, localization, or utilities; also trigger when choosing a common_tools import or checking whether an API is public.
---

# Common Tools Flutter

Use the generated catalogue as the source of truth. It is derived only from
`lib/**/*.dart` in the package repository.

## Workflow

1. Search before coding:
   ```shell
   dart run .agents/skills/common-tools-flutter/scripts/query_catalog.dart <symbol-or-keywords>
   ```
2. Read the matching reference below. Read only the domains needed for the task.
3. Choose the narrowest `package:common_tools/...` import reported for the API.
4. Confirm constructors, parameters, defaults, enum values, and platform notes
   in `assets/catalogue.json` or the generated reference.
5. Implement with public APIs only, then run `flutter analyze` and relevant tests.

## Rules

- Never import `package:common_tools/src/...`.
- Never use a declaration marked `internal` or `directImportAllowed: false`.
- Never invent a constructor, member, callback, extension, or enum value.
- Treat an identifier as supported only when the catalogue lists a public import.
- Check platform and setup notes before using IO, web, biometric, picker, or overlay APIs.
- Prefer package doc examples when present; otherwise build from the exact signature.

## References

- [Catalogue and routing](references/catalogue-index.md)
- [Setup and imports](references/setup-and-imports.md)
- [Themes and styling](references/themes-and-styling.md)
- [Layout and responsive APIs](references/layout-and-responsive.md)
- [Actions](references/components-actions.md)
- [Forms](references/components-forms.md)
- [Feedback](references/components-feedback.md)
- [Data display](references/components-data-display.md)
- [Navigation](references/components-navigation.md)
- [Media](references/components-media.md)
- [Other components](references/components-other.md)
- [Animations, builders, and lists](references/animations-builders-lists.md)
- [Form foundations and validation](references/forms-and-validation.md)
- [Overlays and feedback foundations](references/overlays-and-feedback.md)
- [Context and widget extensions](references/extensions-context-widget.md)
- [Value extensions](references/extensions-values.md)
- [Networking](references/networking.md)
- [Files and services](references/files-and-services.md)
- [Utilities and data types](references/utilities-and-data-types.md)
- [Localization](references/localization.md)
- [Internal file index](references/internal-file-index.md)

For broad or exact lookup, run the query script instead of loading several
large reference files.
