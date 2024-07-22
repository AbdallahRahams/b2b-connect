import 'package:jiffy/jiffy.dart';

class CustomFormatPostDateTime {
  final String postDateTime;

  CustomFormatPostDateTime(this.postDateTime);

  String getDateDifference() {
    var b = postDateTime
        .replaceAll(",", "")
        .split(" "); // Remove , from dayName then convert to List<String>
    /// Remove st,nd,rd,th from Date number
    b[1] = b[1].replaceAll(RegExp(r'[^0-9]'), '');
    String a = Jiffy(b[1] + ", " + b[2] + " " + b[3] + " " + b[4],
            "dd, MMMM yyyy hh:mm:ssa")
        .from(DateTime.now());
    return a == "a day ago" ? "1 day ago" : a;
  }

  String getShortDate() {
    var b = postDateTime.replaceAll(",", "").split(" ");

    /// Remove st,nd,rd,th from Date number
    b[1] = b[1].replaceAll(RegExp(r'[^0-9]'), '');
    String a = Jiffy(b[1] + ", " + b[2] + " " + b[3] + " " + b[4],
            "dd, MMMM yyyy hh:mm:ssa")
        .yMMMdjm;
    return a;
  }
}
