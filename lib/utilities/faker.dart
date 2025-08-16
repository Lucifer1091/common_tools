import 'dart:math';

import 'package:flutter/material.dart';

import '../index.dart';

enum ImageSet { any, set1, set2, set3, set4, set5 }

enum ImageType { png, gif, jpg, bmp, jpeg, ppm }

enum ImageBg { bg1, bgt2, any }

enum ImageColor {
  red,
  green,
  blue,
  yellow,
  orange,
  purple,
  pink,
  brown,
  grey,
  black,
  white,
}

class RandomImage {
  RandomImage._();

  /// Get a random image from Picsum with the specified dimensions.
  ///
  /// Returns a URL string pointing to a random image on Picsum with the given [width] and [height].
  ///
  /// Example:
  /// ```dart
  /// // Get a random image URL with default dimensions (200x200).
  /// String imageUrl = RandomImage.picsumImage();
  ///
  /// // Get a random image URL with custom dimensions (300x400).
  /// String customImageUrl = RandomImage.picsumImage(300, 400);
  /// ```
  static String picsumImage([int width = 200, int height = 200]) {
    return 'https://picsum.photos/$width/$height';
  }

  /// Generates a random image URL from robohash with the specified dimensions and category filter.
  /// https://robohash.org/
  ///
  /// The [size] parameter specify the dimensions of the image.
  /// The [category] parameter specifies the category of the image.
  ///
  /// Returns a string representing the URL of the random image.
  static String randomImage({
    String slug = 'my',
    Size size = const Size(300, 300),
    ImageSet set = ImageSet.any,
    ImageBg bg = ImageBg.any,
    ImageType imageType = ImageType.png,
    String category = 'photo',
    ImageColor? color,
  }) {
    final imageColor = color != null ? '&color=${color.name}' : '';
    final data =
        "https://robohash.org/$slug.${imageType.name}?size=${size.width.toInt()}x${size.height.toInt()}&set=${set.name}&bgset=${bg.name}$imageColor";
    return data;
  }

  /// Generates a random image URL from dummy image with the specified dimensions .
  /// The [size] parameter specify the dimensions of the image.
  /// Returns a string representing the URL of the random image.
  static String dummyImage({
    String? text,
    Size size = const Size(300, 300),
    ImageType imageType = ImageType.png,
    Color bgColor = Colors.grey,
    Color fgColor = Colors.black,
  }) {
    final imageSize = '${size.width.toInt()}x${size.height.toInt()}';
    final imageText = text ?? imageSize;
    final data =
        'https://dummyimage.com/$imageSize.${imageType.name}/${bgColor.toHex(leadingHashSign: false)}/${fgColor.toHex(leadingHashSign: false)}&text=$imageText';
    return data;
  }
}

class Faker {
  Faker._();

  /// Generates Lorem Ipsum text with the specified number of words [length].
  ///
  /// If [length] is not provided, defaults to 50 words.
  ///
  /// Returns a [String] containing Lorem Ipsum text.
  static String generateLoremIpsumWords([num length = 50]) {
    final words =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
            .split(' ');

    final StringBuffer buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write('${words[i % words.length]} ');
    }

    return buffer.toString().trim();
  }

  /// Generates a random full name.
  ///
  /// Returns a [String] containing a randomly generated full name.
  static String generateName() {
    final firstNames = ['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah'];
    final lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones'];

    final random = Random();
    final firstName = firstNames[random.nextInt(firstNames.length)];
    final lastName = lastNames[random.nextInt(lastNames.length)];

    return '$firstName $lastName';
  }

  /// Generates a random email address.
  ///
  /// Returns a [String] containing a randomly generated email address.
  static String generateEmail([String? name]) {
    final domains = [
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'example.com',
      'test.com',
    ];

    final random = Random();
    final username = (name ?? generateName()).replaceAll(' ', '').toLowerCase();
    final domain = domains[random.nextInt(domains.length)];

    return '$username@$domain';
  }

  /// Generates a random phone number.
  ///
  /// Returns a [String] containing a randomly generated phone number.
  static String generatePhoneNumber() {
    final random = Random();
    // Ensures the first digit is between 2 and 9
    final firstDigit = 2 + random.nextInt(8);

    final StringBuffer buffer = StringBuffer()..write('$firstDigit');

    for (var i = 0; i < 9; i++) {
      buffer.write(random.nextInt(10).toString());
      if (i == 2 || i == 5) {
        buffer.write('-');
      }
    }
    return buffer.toString();
  }

  /// Generates a random address.
  ///
  /// Returns a [String] containing a randomly generated address.
  static String generateAddress() {
    final streets = ['Main St', 'Oak Ave', 'Cedar Dr', 'Pine Rd', 'Elm St'];
    final cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'];
    final states = ['CA', 'TX', 'NY', 'FL', 'IL'];
    final zipCodes = ['10001', '90001', '60601', '77001', '85001'];

    final random = Random();
    final street = streets[random.nextInt(streets.length)];
    final city = cities[random.nextInt(cities.length)];
    final state = states[random.nextInt(states.length)];
    final zipCode = zipCodes[random.nextInt(zipCodes.length)];

    return '$street, $city, $state $zipCode';
  }

  /// Generates a single random user.
  ///
  /// Returns a [Json] user object with randomly generated attributes.
  static Json generateUser([int minAge = 18, int maxAge = 65]) {
    final String name = generateName();
    final random = Random();

    return {
      'id': Guid.ulid(),
      'name': name,
      'image': RandomImage.picsumImage(300, 300),
      // Generates random age between 18 and 60
      'age': minAge + random.nextInt(maxAge - minAge + 1),
      'email': generateEmail(name),
      'phone': generatePhoneNumber(),
      'address': generateAddress(),
    };
  }

  /// Generates a list of random users with the specified [count].
  ///
  /// If [count] is not provided, defaults to generating 5 users.
  ///
  /// Returns a list of [Json] user objects.
  static List<Json> generateUsers([
    int count = 5,
    int minAge = 18,
    int maxAge = 65,
  ]) {
    final List<Json> users = [];
    for (var i = 0; i < count; i++) {
      users.add(generateUser(minAge, maxAge));
    }
    return users;
  }
}
