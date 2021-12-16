import 'package:catatan_keuangan/database/crud_database.dart';
import 'package:catatan_keuangan/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class NoteEditScreen extends StatefulWidget {
  final int value;
  final String category;
  final String date;
  final String description;
  final String uid;
  final bool incomeClicked;

  NoteEditScreen({
    required this.value,
    required this.category,
    required this.date,
    required this.description,
    required this.uid,
    required this.incomeClicked,
  });

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
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
  void initState() {
    super.initState();
    _valueController.text = widget.value.toString();
    _descriptionController.text = widget.description;
    _date = widget.date;
    _selectedCategory = widget.category;
    _incomeClicked = widget.incomeClicked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff383838),
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
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.orange,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      'Edit Catatan',
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
                            (_incomeClicked) ? Colors.orange :  Color(0xff383838),
                        child: Text(
                          'Pemasukan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: (_incomeClicked)
                                ?  Color(0xff383838)
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
                            (_incomeClicked) ?  Color(0xff383838) : Colors.orange,
                        child: Text(
                          'Pengeluaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: (_incomeClicked)
                                ? Colors.orange
                                :  Color(0xff383838),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
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
                        height: 45,
                        child: RaisedButton(
                          color: Colors.orange,
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 18,
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

                              await CRUD.editNotes(
                                _valueController.text,
                                _selectedCategory,
                                _date,
                                _descriptionController.text,
                                widget.uid,
                                _incomeClicked,
                              );

                              setState(() {
                                _visibility = false;
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
