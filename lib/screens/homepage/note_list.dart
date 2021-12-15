import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'note_edit_screen.dart';

class ListOfNotes extends StatelessWidget {
  final List<DocumentSnapshot> document;

  ListOfNotes({required this.document});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String category = document[i]['category'].toString();
        String date = document[i]['date'].toString();
        int value = document[i]['value'];
        String description = document[i]['description'].toString();
        String uid = document[i]['uid'].toString();
        bool incomeClicked = document[i]['income'];

        final moneyCurrency = new NumberFormat("#,##0", "en_US");
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          margin: EdgeInsets.only(
            bottom: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                      ),
                      child: Text(
                        category,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 16),
                       child: Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                     ),

                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        right: 10,
                      ),
                      child: Text(
                        date,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        'Rp.${moneyCurrency.format(value)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 40,
                          ),
                          onTap: () {
                            Route route = MaterialPageRoute(
                              builder: (context) => NoteEditScreen(
                                value: value,
                                category: category,
                                date: date,
                                description: description,
                                uid: uid,
                                incomeClicked: incomeClicked,
                              ),
                            );
                            Navigator.push(context, route);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
