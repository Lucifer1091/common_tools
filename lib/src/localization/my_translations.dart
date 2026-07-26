import 'dart:async';

import 'package:flutter/widgets.dart';

/// Visible strings used by the design system.
///
/// Applications can subclass this type or return a customized instance from
/// [MyLocalizationsDelegate.resolver].
@immutable
class MyTranslations {
  const MyTranslations({
    this.loading = 'Loading…',
    this.retry = 'Retry',
    this.error = 'Something went wrong.',
    this.filePickFailed = 'Could not pick the file.',
    this.invalidFileFormat = 'Unsupported file format.',
    this.linkLaunchFailed = 'Could not open link. Please try again later.',
    this.dismiss = 'Dismiss',
    this.uploadImage = 'Upload image',
    this.uploadImagePrompt = 'How would you like to add the image?',
    this.captureFromCamera = 'Capture from camera',
    this.uploadFromGallery = 'Choose from gallery',
    this.cancel = 'Cancel',
  });

  final String loading;
  final String retry;
  final String error;
  final String filePickFailed;
  final String invalidFileFormat;
  final String linkLaunchFailed;
  final String dismiss;
  final String uploadImage;
  final String uploadImagePrompt;
  final String captureFromCamera;
  final String uploadFromGallery;
  final String cancel;

  static MyTranslations of(BuildContext context) {
    return Localizations.of<MyTranslations>(context, MyTranslations) ??
        const MyEnglishTranslations();
  }
}

/// Built-in English fallback.
class MyEnglishTranslations extends MyTranslations {
  const MyEnglishTranslations();
}

typedef MyTranslationsResolver =
    FutureOr<MyTranslations?> Function(Locale locale);

/// Loads host-provided translations and falls back to English.
class MyLocalizationsDelegate extends LocalizationsDelegate<MyTranslations> {
  const MyLocalizationsDelegate({this.resolver});

  final MyTranslationsResolver? resolver;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MyTranslations> load(Locale locale) async {
    return await resolver?.call(locale) ?? const MyEnglishTranslations();
  }

  @override
  bool shouldReload(covariant MyLocalizationsDelegate old) {
    return old.resolver != resolver;
  }
}
