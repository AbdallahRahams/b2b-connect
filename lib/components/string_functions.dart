import 'package:jiffy/jiffy.dart';

///
/// Capitalize first letter of a String
///
extension StringExtension on String {
  String capitalize() {
    try {
      if (this.length == 0) {
        return this;
      } else if (this.length == 1) {
        return this[0].toUpperCase();
      }
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } catch (e) {
      return this;
    }
  }

  String birthday() {
    try {
      final List<String> date = this.split("/");
      return Jiffy(
              [int.parse(date.last), int.parse(date[1]), int.parse(date.first)])
          .format("MMMM, do");
    } catch (e) {
      return this;
    }
  }

  String initialDateInput() {
    try {
      final List<String> date = this.split("/");
      return date.last + "-" + date[1] + "-" + date.first;
    } catch (e) {
      return this;
    }
  }

  String youtubeId() {
    try {
      /// https://www.youtube.com/embed/-10eLzFOwf4?autoplay=1&modestbranding=1
      var match = this.split("embed/");
      return match[1].substring(0, 11);
    } catch (e) {
      return e.toString();
    }
  }

  String messageCreatedAt() {
    try {
      if (int.parse(this) < 10) {
        return "0$this";
      }
      return this;
    } catch (e) {
      return e.toString();
    }
  }
}
