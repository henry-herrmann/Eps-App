import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String errorMessage;

  const ErrorCard(this.errorMessage, {Key? key}) : super(key: key);

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
                          Icon(Icons.error_outline,),
                          Padding(
                              padding: const EdgeInsets.only(left: 13, top: 5, bottom: 5),
                              child: Text(errorMessage, style: const TextStyle( fontSize: 15,fontWeight: FontWeight.bold))
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
