# common_tools

Private Flutter design-system package for Flutter 3.44+ and Dart 3.12+. It
contains the supported `My*` component families, the existing animated theme,
layout primitives, application-scoped overlays, localization contracts,
networking, and services.

## Install from a pinned Git tag

```yaml
dependencies:
  common_tools:
    git:
      url: git@github.com:Lucifer1091/common_tools.git
      ref: v0.1.0
```

Do not depend on a branch or commit from a production app. Tags are the release
contract, and this package is intentionally excluded from pub.dev with
`publish_to: none`.

## Choose a public entrypoint

```dart
import 'package:common_tools/common_tools.dart'; // theme, layout, components
import 'package:common_tools/components/forms.dart';
import 'package:common_tools/components/feedback.dart';
import 'package:common_tools/extensions/context.dart';
import 'package:common_tools/network.dart';
```

`common_tools.dart` is the convenient UI facade. Prefer a narrow entrypoint in
shared features and large apps so completions stay focused and ownership is
obvious. Never import `package:common_tools/src/...`.

## Install the UI layer

Use `MyUILayer` from `MaterialApp.builder`. This preserves the package's
existing inherited theme and animated interpolation while adding isolated
toast/loading controllers and package localization.

```dart
MaterialApp(
  builder: (context, child) => MyUILayer(
    theme: MyColorScheme.light(),
    darkTheme: MyColorScheme.dark(),
    child: child,
    translationsResolver: (locale) {
      // Return null to use the built-in English fallback.
      return null;
    },
  ),
);
```

Overlay calls require a context below `MyUILayer`:

```dart
MyToast.success(context: context, title: 'Saved');
await MyLoadingOverlay.async(
  context,
  future: repository.refresh,
);
```

## Files and dependency boundaries

Picker and download APIs return `MyPickedFile`; consumers do not need to import
or depend on `XFile`. Component APIs similarly avoid re-exporting dependency
packages. Supply caller-owned widgets through the documented widget slots when
customizing icons or content.

## Platforms

The supported matrix is Android, iOS, web, Windows, macOS, and Linux. A feature
can still be platform-limited when its underlying OS capability is unavailable
(for example biometrics).

## Version policy

The redesigned API starts at `0.1.0`. Before `1.0.0`, minor versions may contain
breaking changes and patch versions contain compatible fixes. Every consuming
app should pin an exact Git tag and review `CHANGELOG.md` plus
`MIGRATION.md` before updating.

The example application is the component catalog and uses only supported public
entrypoints.
