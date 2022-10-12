import 'package:event_planner/network/Requests.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AddUser extends StatefulWidget {
  final int eventId;
  const AddUser(this.eventId, {Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  
  bool changed = false;
  bool error = false;
  String search = "";
  bool loading = false;
  List<int> users = <int>[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Nutzer zum Event hinzufügen"),
          elevation: 0,
          actions: <Widget>[
            Visibility(
              visible: changed,
              child: IconButton(
                padding: EdgeInsets.only(right: 25),
                icon: Icon(Icons.check, color: Colors.white,),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                          future: Requests().addUser(context, widget.eventId, users),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              if(snapshot.data == true){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage(1)));
                              }else {
                                setState(() {
                                  error = true;
                                });
                              }
                            }else if(snapshot.hasError){
                              setState(() {
                                error = true;
                              });
                            }

                            return const SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.indigo,
                                ),
                              ),
                            );
                          },
                        );
                      }
                  );
                },
              ),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2))
                ),
                width: MediaQuery.of(context).size.width-10,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Schüler/Lehrer suchen",
                      contentPadding: EdgeInsets.all((18))
                  ),
                  onChanged: (String value){
                    setState(() {
                      search = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: FutureBuilder(
                  future: Requests().getAllUsers(context),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){

                    }

                    return SizedBox();
                  },
                )
              )
            ],
          )
        )
      ),
    );
  }
}
