import 'package:flutter/material.dart';

class TeacherCard extends StatefulWidget {
  final int userId;
  final String userName;

  const TeacherCard(this.userId, this.userName, {Key? key}) : super(key: key);

  @override
  _TeacherCardState createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width-50,
                margin: const EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.school_outlined,),
                          Padding(
                              padding: const EdgeInsets.only(left: 13, top: 4, bottom: 5),
                              child: Text(widget.userName, style: const TextStyle( fontSize: 15,fontWeight: FontWeight.bold))
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}
