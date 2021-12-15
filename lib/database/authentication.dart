import 'package:catatan_keuangan/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {

  static signInHandler(String email, String password) async {
    try {
      (await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password))
          .user;

      return true;
    } catch (error) {
      toast(
          'Terdapat kendala ketika ingin login. Silahkan periksa kembali email & password, serta koneksi internet anda');
      return false;
    }
  }

  static registerHandler(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (error) {
      toast(
          'Gagal melakukan pendaftaran, silahkan periksa kembali data diri anda dan koneksi internet anda');
      return false;
    }
  }

  static registeringUserToDatabase(String name, String email, String password) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      print(uid);
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "password": password,
      });
    } catch (error) {
      toast("Gagal melakukan pendaftaran, silahkan cek koneksi internet anda");
    }
  }
}