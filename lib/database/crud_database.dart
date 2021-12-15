import 'package:catatan_keuangan/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD {
  static Future<void> deleteAllData(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('notes')
          .where('owner', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      toast('Berhasil menghapus semua data Catatan Keuangan.');
    } catch (error) {
      toast(
          'Gagal menghapus semua data Catatan Keuangan, mohon periksa koneksi internet anda');
    }
  }

  static addNotes(String value, String category, String date,
      String description, String uid, String timeInMillis, bool incomeClicked) async {
    try {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(timeInMillis)
          .set({
        'value': int.parse(value),
        'category': category,
        'date': date,
        'description': description,
        'uid': timeInMillis,
        'owner': uid,
        'income': incomeClicked,
      }).then((value) {
        toast('Berhasil menambah catatan baru');
      });
    } catch (error) {
      toast('Gagal menambahkan catatan baru');
    }
  }

  static editNotes(String value, String category, String date, String description, String uid, bool incomeClicked) async {
    try {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .update({
        'value': int.parse(value),
        'category': category,
        'date': date,
        'description': description,
        'incomeClicked': incomeClicked,
      });
      toast('Berhasil memperbarui catatan');
    } catch (error) {
      toast('Gagal memperbarui catatan');
    }
  }
}
