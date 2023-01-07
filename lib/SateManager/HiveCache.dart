import 'package:hive_flutter/adapters.dart';
import '../Models/Admin/Admin.dart';

class HiveCache {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AdminAdapter());
   await  Hive.openBox<Admin>('admins');
    await Hive.openBox('isLoggedIn');
  }

  static void saveAdmin(Admin admin) {
    final box = Hive.box<Admin>('admins');
    box.put('admin', admin);
  }
  static Admin? getAdmin() {
    final box = Hive.box<Admin>('admins');
    return box.get('admin');
  }

  static void saveIsLoggedIn(bool isLoggedIn) {
    final box = Hive.box('isLoggedIn');
    box.put('loggedIn', isLoggedIn);
  }

  static bool? getIsLoggedIn() {
    final box = Hive.box('isLoggedIn');
    return box.get('loggedIn',defaultValue: false);
  }

}
