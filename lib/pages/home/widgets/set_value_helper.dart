class SetValHelper {
  static String setPrefix(String text) {
    var txt = text.split("");
    txt.removeLast();
    return txt.join("");
  }

  static String setSuffix(String text) => text.split("").last;

  static String valuePrefix(String text) {
    var txt = text.split(".").first.toString().split("");
    txt.removeLast();
    return txt.join("");
  }

  static String valueMiddle(String text) {
    var txt = text.split(".").first.toString().split("").last;
    return txt;
  }

  static String valueSuffix(String text) => ".${text.split(".").last}";
}
