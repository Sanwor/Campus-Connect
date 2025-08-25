import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoginLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoginLoading.value = true;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoginLoading.value = false;
    }
  }
}
