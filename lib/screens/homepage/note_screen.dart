import 'package:catatan_keuangan/screens/homepage/note_add_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'note_list.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color:  Color(0xff383838),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 16,
                ),
                child: Text(
                  'Catatan',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 35,
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
            ],
          ),
          /// tampilkan semua catatan keuangan yang tersedia
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 105),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('notes').where('owner', isEqualTo: uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data!.size > 0)
                      ? ListOfNotes(
                    document: snapshot.data!.docs,
                  )
                      : _emptyData();
                } else {
                  return _emptyData();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              bottom: 16,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => NoteAddScreen());
                  Navigator.push(context, route);
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.orange,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Catatan\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
