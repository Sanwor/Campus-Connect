import 'dart:developer';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

//Always retuns String "" if value is null
read(String storageName) {
  return box.read(storageName) ??
      ''; // let it return empty string if null or if not found
}

write(String storageName, dynamic value) {
  if (value != null) {
    box.write(storageName, value);
  }
}

remove(String storageName) {
  box.remove(storageName);
}

clearAllData() {
  var currentServer = read('serverMode');
  log('\x1B[31mAlert => Clearing all cached data\x1B[0m');

  // // Delete existing controllers
  // Get.delete<AuthController>();
  // Get.delete<AppController>();

  // Clear local storage
  box.erase();

  // Write the preserved value back
  write('serverMode', currentServer);

  // // Reinitialize the controllers
  // Get.put(AuthController());
  // Get.put(AppController());
}
