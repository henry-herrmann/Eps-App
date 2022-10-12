import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final int userId;
  final String userName;

  const UserCard(this.userId, this.userName, {Key? key}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
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
                          Icon(Icons.account_circle_outlined,),
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
