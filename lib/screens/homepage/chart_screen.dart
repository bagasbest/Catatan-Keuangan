import 'package:catatan_keuangan/database/crud_database.dart';
import 'package:catatan_keuangan/utils/bar_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final moneyCurrency = new NumberFormat("#,##0", "en_US");
  List<int> valuePerMonth = [];
  var income = true;
  List<String> _category = [
    'Pemasukan',
    'Pengeluaran',
  ];
  var _selectedCategory;

  /// chart
  static List<charts.Series<BarModel, String>> _createSampleData(
    int jan,
    int feb,
    int mar,
    int apr,
    int may,
    int jun,
    int jul,
    int aug,
    int sep,
    int oct,
    int nov,
    int dec,
  ) {
    final data = [
      BarModel(month: "Jan", value: jan),
      BarModel(month: "Feb", value: feb),
      BarModel(month: "Mar", value: mar),
      BarModel(month: "Apr", value: apr),
      BarModel(month: "May", value: may),
      BarModel(month: "Jun", value: jun),
      BarModel(month: "Jul", value: jul),
      BarModel(month: "Aug", value: aug),
      BarModel(month: "Sep", value: sep),
      BarModel(month: "Oct", value: oct),
      BarModel(month: "Nov", value: nov),
      BarModel(month: "Dec", value: dec),
    ];

    return [
      charts.Series<BarModel, String>(
        data: data,
        id: 'value',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (BarModel barModel, _) => barModel.month,
        measureFn: (BarModel barModel, _) => barModel.value,
      )
    ];
  }

  var axis = charts.NumericAxisSpec(
    renderSpec: charts.GridlineRendererSpec(
      labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.MaterialPalette
              .white), //chnage white color as per your requirement.
    ),
  );

  var axisString = charts.OrdinalAxisSpec(
    renderSpec: charts.GridlineRendererSpec(
      labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.MaterialPalette
              .white), //chnage white color as per your requirement.
    ),
  );

  _getIncomeOrOutcomePerMonth() async {
    await CRUD.getAllIncomeOrOutcome(income);
    valuePerMonth.clear();
    setState(() {
      valuePerMonth.add(CRUD.jan);
      valuePerMonth.add(CRUD.feb);
      valuePerMonth.add(CRUD.mar);
      valuePerMonth.add(CRUD.apr);
      valuePerMonth.add(CRUD.may);
      valuePerMonth.add(CRUD.jun);
      valuePerMonth.add(CRUD.jul);
      valuePerMonth.add(CRUD.aug);
      valuePerMonth.add(CRUD.sep);
      valuePerMonth.add(CRUD.oct);
      valuePerMonth.add(CRUD.nov);
      valuePerMonth.add(CRUD.dec);

      valuePerMonth = (valuePerMonth..sort()).reversed.toList();

      _createSampleData(
        CRUD.jan,
        CRUD.feb,
        CRUD.mar,
        CRUD.apr,
        CRUD.may,
        CRUD.jun,
        CRUD.jul,
        CRUD.aug,
        CRUD.sep,
        CRUD.oct,
        CRUD.nov,
        CRUD.dec,
      );
    });
  }

  _getTotalIncome() {
    CRUD.getTotalIncome();
  }

  _getTotalOutcome() {
    CRUD.getTotalOutcome();
  }

  @override
  void initState() {
    super.initState();
    _getIncomeOrOutcomePerMonth();
    _getTotalIncome();
    _getTotalOutcome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xff383838),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 16,
                  ),
                  child: Text(
                    'Beranda',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 34,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Kategori',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                /// Kategori
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
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
                          if (_selectedCategory == "Pemasukan") {
                            income = true;
                            _getIncomeOrOutcomePerMonth();
                          } else {
                            income = false;
                            _getIncomeOrOutcomePerMonth();
                          }
                        });
                      },
                      items: _category.map((category) {
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

                Container(
                  height: 300,
                  child: charts.BarChart(
                    _createSampleData(
                      CRUD.jan,
                      CRUD.feb,
                      CRUD.mar,
                      CRUD.apr,
                      CRUD.may,
                      CRUD.jun,
                      CRUD.jul,
                      CRUD.aug,
                      CRUD.sep,
                      CRUD.oct,
                      CRUD.nov,
                      CRUD.dec,
                    ),
                    animate: true,
                    primaryMeasureAxis: axis,
                    domainAxis: axisString,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    'Total Pemasukan: Rp.' + moneyCurrency.format(CRUD.income),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Total Pengeluaran: Rp.' +
                        moneyCurrency.format(CRUD.outcome),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
