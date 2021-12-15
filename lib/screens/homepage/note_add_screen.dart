import 'package:catatan_keuangan/database/crud_database.dart';
import 'package:catatan_keuangan/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class NoteAddScreen extends StatefulWidget {
  const NoteAddScreen({Key? key}) : super(key: key);

  @override
  _NoteAddScreenState createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  var _incomeClicked = true;
  var _valueController = TextEditingController();
  var _descriptionController = TextEditingController();
  String _date = "Pilih Tanggal Catatan";
  var _visibility = false;

  final _formKey = GlobalKey<FormState>();

  List<String> _income = [
    'Gaji',
    'Usaha',
    'Bonus',
    'Bunga',
    'Hadiah',
    'Uang Masuk'
  ];
  List<String> _outcome = [
    'Makanan & Minuman',
    'Transportasi Online',
    'Transportasi',
    'Dompet Digital',
    'Kebutuhan Bulanan',
    'Belanja',
    'Sewa/Kontrak',
    'Cicilan',
    'Entertaiment',
    'Hobi',
    'Olahraga',
    'Kesehatan',
    'Pendidikan',
    'Asuransi',
    'Investasi',
    'Amal/Donasi',
    'Uang Keluar'
  ];
  var _selectedCategory;

  /// kalender
  DateTime _dueDate = DateTime.now();

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        _dueDate = picked;

        final DateFormat formatterDate = DateFormat('dd MMMM yyyy');
        _date = formatterDate.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 16,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Buat Catatan',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            Center(
              child: Container(
                width: 250,
                height: 40,
                color: Colors.orange,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _incomeClicked = true;
                          _selectedCategory = null;
                        });
                      },
                      child: Container(
                        width: 119,
                        height: 40,
                        margin: EdgeInsets.all(3),
                        color:
                            (_incomeClicked) ? Colors.orange : Colors.grey[600],
                        child: Text(
                          'Pemasukan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: (_incomeClicked)
                                ? Colors.grey[600]
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _incomeClicked = false;
                          _selectedCategory = null;
                        });
                      },
                      child: Container(
                        width: 119,
                        height: 40,
                        margin: EdgeInsets.all(3),
                        color:
                            (_incomeClicked) ? Colors.grey[600] : Colors.orange,
                        child: Text(
                          'Pengeluaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: (_incomeClicked)
                                ? Colors.orange
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Jumlah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    /// KOLOM JUMLAH UANG
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _valueController,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      'Kategori',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    /// Kategori
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,),
                        child: DropdownButton(
                          hint: Text(
                            'Pilih Kategori',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Not necessary for Option 1
                          value: _selectedCategory,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue.toString();
                              print(_selectedCategory);
                            });
                          },
                          items: (_incomeClicked)
                              ? _income.map((category) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: category,
                                  );
                                }).toList()
                              : _outcome.map((category) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: category,
                                  );
                                }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Tanggal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    /// KOLOM Tanggal
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _date,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _selectDueDate(context);
                            },
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Keterangan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    /// KOLOM Keterangan
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Keterangan tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    /// LOADING INDIKATOR
                    Visibility(
                      visible: _visibility,
                      child: SpinKitRipple(
                        color: Color(0xfffbbb5b),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.orange,
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onPressed: () async {
                            /// simpan catatan
                            if (_formKey.currentState!.validate() &&
                                _selectedCategory != null &&
                                _date != "Pilih Tanggal Catatan") {
                              setState(() {
                                _visibility = true;
                              });

                              String uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              String timeInMillis = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              await CRUD.addNotes(
                                _valueController.text,
                                _selectedCategory,
                                _date,
                                _descriptionController.text,
                                uid,
                                timeInMillis,
                                _incomeClicked,
                              );

                              setState(() {
                                _visibility = false;
                                _valueController.clear();
                                _descriptionController.clear();
                                _selectedCategory = null;
                                _date = "Pilih Tanggal Catatan";
                              });
                            } else {
                              toast('Seluruh kolom harus terisi');
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
