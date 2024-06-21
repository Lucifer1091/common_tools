part of 'utilities.dart';

class Uuid {
  Uuid._();

  // https://stackoverflow.com/a/62486490/827047
  static final _random = Random();

  static String create([int len = 48]) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[_random.nextInt(chars.length)])
        .join();
  }
}
