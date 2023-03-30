class GlobalData {
  static final GlobalData _instance = GlobalData._internal();
  String userRole = "";

  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();
}