import 'package:catatan_keuangan/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUD {
  static int jan = 0;
  static int feb = 0;
  static int mar = 0;
  static int apr = 0;
  static int may = 0;
  static int jun = 0;
  static int jul = 0;
  static int aug = 0;
  static int sep = 0;
  static int oct = 0;
  static int nov = 0;
  static int dec = 0;

  static int income = 0;
  static int outcome = 0;

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

  static addNotes(
      String value,
      String category,
      String date,
      String description,
      String uid,
      String timeInMillis,
      bool incomeClicked) async {
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

  static editNotes(String value, String category, String date,
      String description, String uid, bool incomeClicked) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(uid).update({
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

  static getAllIncomeOrOutcome(bool option) async {
    try {

      jan = 0;
      feb = 0;
      mar = 0;
      apr = 0;
      may = 0;
      jun = 0;
      jul = 0;
      aug = 0;
      sep = 0;
      oct = 0;
      nov = 0;
      dec = 0;

      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('notes')
          .where('owner', isEqualTo: uid)
          .where('income', isEqualTo: option)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          String date = ds.get('date').toString();
          String getMonth = date.substring(3, date.length - 5);
          int value = ds.get('value');


          if (getMonth == "January") {
            jan += value;
          } else if (getMonth == 'February') {
            feb += value;
          } else if (getMonth == 'March') {
            mar += value;
          } else if (getMonth == 'April') {
            apr += value;
          } else if (getMonth == 'May') {
            may += value;
          } else if (getMonth == 'June') {
            jun += value;
          } else if (getMonth == 'July') {
            jul += value;
          } else if (getMonth == 'August') {
            aug += value;
          } else if (getMonth == 'September') {
            sep += value;
          } else if (getMonth == 'November') {
            nov += value;
          } else if (getMonth == 'December') {
            dec += value;
          }
        }
      });
    } catch (error) {
      toast('Gagal mendapatkan data');
    }
  }

  static Future<void> getTotalIncome() async {
    try {
      income = 0;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('notes')
          .where('owner', isEqualTo: uid)
          .where('income', isEqualTo: true)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          int value = ds.get('value');
          income += value;
        }
      });
    } catch (error) {
      toast('Gagal mendapatkan data');
    }
  }

  static Future<void> getTotalOutcome() async {
    try {
      outcome = 0;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('notes')
          .where('owner', isEqualTo: uid)
          .where('income', isEqualTo: false)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          int value = ds.get('value');
          outcome += value;
        }
      });
    } catch (error) {
      toast('Gagal mendapatkan data');
    }
  }
}
