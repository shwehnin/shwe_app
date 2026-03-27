class SecretCode {
  static String generate(String code) => _codeGenerator(plainTxt: code);
  static String _codeGenerator({required String plainTxt}) {
    var codeBase2 =
        "uSi#okbxPF)frL=8aw.(Kp-MQRV9z,j6I7Bycn!%Y&*he>C:3s2TdmOgZ_'l`Wqv4|DUG^~;N+/\"JEX5<01HtA\$?";
    String codeBase1 = "cn0hj.p4wstqxo7bvlzf1ky6ri935u@gem2a8d";
    List<String> cods1 = codeBase1.split("").reversed.toList();
    List<String> cods2 = codeBase2.split("").reversed.toList();
    String key = "";
    for (String txt in plainTxt.split("")) {
      int idx = cods1.indexWhere((e) => e.toLowerCase() == txt.toLowerCase());
      if (idx != -1) {
        if (idx <= cods2.length) {
          key += cods2[idx];
        } else {
          key += "#";
        }
      } else {
        key += "@";
      }
    }
    return key;
  }
}
