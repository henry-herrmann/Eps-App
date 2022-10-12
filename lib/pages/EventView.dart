import 'package:event_planner/components/ErrorCard.dart';
import 'package:event_planner/components/TeacherCard.dart';
import 'package:event_planner/components/UserCard.dart';
import 'package:event_planner/main.dart';
import 'package:event_planner/network/Cache.dart';
import 'package:event_planner/network/Requests.dart';
import 'package:event_planner/pages/AddUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EventView extends StatefulWidget {
  final int id;
  final String eventname;
  final String description;
  final int datemilliseconds;
  final bool joined;
  final String type;
  final PageController controller;
  const EventView(this.id, this.eventname, this.description, this.datemilliseconds, this.joined, this.type, this.controller, {Key? key}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  bool changed = false;
  bool editFieldsEnabled = false;
  bool joinButtonPressed = false;
  bool noInternet = false;

  late String dropDownMenuValue;

  late String buttontext;

  @override
  void initState(){
    buttontext = widget.joined ? "Verlassen" : "Teilnehmen";
    dropDownMenuValue = widget.type;

    nameController.text = widget.eventname;
    descController.text = widget.description;
    selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.datemilliseconds);
    dateController.text = selectedDate.day.toString() + "." + selectedDate.month.toString() + "." + selectedDate.year.toString() + " " + selectedDate.hour.toString() + ":" + selectedDate.minute.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
          ),
          title: Text(widget.eventname),
          backgroundColor: Colors.indigo,
          elevation: 0,
          actions: <Widget>[
            Visibility(
              visible: changed,
              child: IconButton(
                padding: EdgeInsets.only(right: 25),
                icon: Icon(Icons.check, color: Colors.white,),
                onPressed: ()async {
                  await Requests().updateEvent(context, widget.id, nameController.text, descController.text, selectedDate, dropDownMenuValue).then((result){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage(1)));
                  }).onError((error, stackTrace){
                    print(error);
                  });
                },
              )
            )
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: Cache().getValue("user"),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Form(
                    onWillPop: () async {
                      if(changed){
                        showCupertinoDialog<void>(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text('Speichern?'),
                            content: const Text('Wollen Sie Ihre Änderungen speichern?'),
                            actions: <CupertinoDialogAction>[
                              CupertinoDialogAction(
                                child: const Text('Ja'),
                                onPressed: () async {
                                  await Requests().updateEvent(context, widget.id, nameController.text, descController.text, selectedDate,  dropDownMenuValue).then((result){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage(1)));
                                  }).onError((error, stackTrace){
                                    print(error);
                                  });
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text('Nein'),
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage(1)));
                                },
                              )
                            ],
                          ),
                        );
                        return Future.value(false);
                      }else if(joinButtonPressed){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage(1)));
                        return Future.value(false);
                      }
                      return Future.value(true);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                            visible: noInternet,
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 11),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black38
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.signal_cellular_connected_no_internet_4_bar_outlined, color: Colors.redAccent,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text("No internet connection!", style: TextStyle(color: Colors.white),),
                                  )
                                ],
                              )
                            )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width-30,
                            height: 50,
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              ),
                              child: Text(buttontext, style: TextStyle(color: Colors.white),),
                              onPressed: widget.type == "Pflicht" && snapshot.data!["role"] < 2 ? null : onJoinButtonPressed,
                            )
                        ),
                        const SizedBox(
                          height: 15,
                          width: 200,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width-30,
                            child: TextFormField(
                              onTap: () {

                              },
                              enabled: snapshot.data!["role"] > 1 ? true : false,
                              controller: nameController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                labelText: "Name",
                                labelStyle: const TextStyle(color: Colors.white),
                                contentPadding: const EdgeInsets.all(18),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  changed = true;
                                });
                              },
                            )
                        ),
                        const SizedBox(
                          height: 25,
                          width: 200,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width-30,
                            child: TextFormField(
                              onTap: () {

                              },
                              enabled: snapshot.data!["role"] > 1 ? true : false,
                              controller: descController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                labelText: "Beschreibung",
                                labelStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(18),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  changed = true;
                                });
                              },
                            )
                        ),
                        const SizedBox(
                          height: 25,
                          width: 200,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width-30,
                            child: TextFormField(
                              onTap: () {
                                _selectDate(context);
                              },
                              enabled: snapshot.data!["role"] > 1 ? true : false,
                              readOnly: true,
                              controller: dateController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                labelText: "Datum",
                                labelStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(18),
                              ),
                            )
                        ),
                        const SizedBox(
                          height: 25,
                          width: 200,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width-30,
                            child: IgnorePointer(
                                ignoring: snapshot.data!["role"] > 1 ? false : true,
                                child: DropdownButtonFormField<String>(
                                  hint: Text(dropDownMenuValue, style: TextStyle(color: Colors.white),),
                                  elevation: 15,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    labelText: "Anwesenheit",
                                    labelStyle: const TextStyle(color: Colors.white),
                                    contentPadding: const EdgeInsets.all(18),
                                  ),
                                  items: <String>['Freiwillig', 'Pflicht']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.black),),
                                    );
                                  }).toList(),
                                  onChanged: (String? value){
                                    setState(() {
                                      dropDownMenuValue = value!;
                                      changed = true;
                                    });
                                  },
                                )
                            )
                        ),
                        const SizedBox(
                          height: 25,
                          width: 200,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: 180,
                                margin: EdgeInsets.fromLTRB(16, 6, 16.6, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Container(
                                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                                    child: FutureBuilder<List<Widget>>(
                                      future: buildTeacherCards(),
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(top: 1, bottom: 10),
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context1, index){
                                              return snapshot.data![index];
                                            },
                                            separatorBuilder: (BuildContext context, int index) {
                                              return const Divider(color: Colors.indigo,);
                                            },
                                          );
                                        }else if(snapshot.hasError){

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
                                    )
                                )
                            ),
                            Positioned(
                                left: 35,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 1, left: 3, right: 7),
                                  color: Colors.indigo,
                                  child: Text(
                                    'Lehrer',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: 180,
                                margin: EdgeInsets.fromLTRB(16, 6, 16.6, 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Container(
                                    margin: EdgeInsets.only(top: 12, left: 16, right: 16),
                                    child: FutureBuilder<List<Widget>>(
                                      future: buildStudentCards(),
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          if(snapshot.data!.length == 0){
                                            return ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(top: 1, bottom: 10),
                                              itemCount: 1,
                                              itemBuilder: (context1, index){
                                                return ErrorCard("Keine Schüler.");
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return const Divider(color: Colors.indigo,);
                                              },
                                            );
                                          }else{
                                            return ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(top: 1),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context1, index){
                                                return snapshot.data![index];
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return const Divider(color: Colors.indigo,);
                                              },
                                            );
                                          }

                                        }else if(snapshot.hasError){

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
                                    )
                                )
                            ),
                            Positioned(
                                left: 35,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 1, left: 3, right: 7),
                                  color: Colors.indigo,
                                  child: Text(
                                    'Schüler',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: snapshot.data!["role"] > 1,
                          child: Container(
                              width: MediaQuery.of(context).size.width-30,
                              height: 50,
                              padding: EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                ),
                                child: Text("Schüler/Lehrer hinzufügen", style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => new AddUser(widget.id)));
                                },
                              )
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                )
              );
            }else if(snapshot.hasError){

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
        )
      )
    );
  }

  void onJoinButtonPressed() async {
    if(buttontext == "Verlassen"){
      showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Verlassen?'),
          content: const Text('Wollen Sie das Event verlassen?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('Ja'),
              onPressed: () async {
                await Requests().leaveEvent(context, widget.id).then((data) {
                  setState(() {
                    joinButtonPressed = true;
                    buttontext = "Teilnehmen";
                  });
                  Navigator.of(context).pop();
                }).onError((error, stackTrace){
                  print(error);
                });
              },
            ),
            CupertinoDialogAction(
              child: const Text('Nein'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }else{
      await Requests().joinEvent(context, widget.id).then((data) {
        setState(() {
          joinButtonPressed = true;
          buttontext = "Verlassen";
        });
      }).onError((error, stackTrace){
        print(error);
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 500,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                use24hFormat: true,
                onDateTimeChanged: (val) {
                  setState(() {
                    changed = true;
                    selectedDate = val;
                    dateController.text = selectedDate.day.toString() + "." + selectedDate.month.toString() + "." + selectedDate.year.toString() + " " + selectedDate.hour.toString() + ":" + selectedDate.minute.toString();
                  });
                },
              )
            ),
            CupertinoButton(
              child: const Text("Fertig"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        )
      )
    );
  }
  Future<List<Widget>> buildTeacherCards() async{
    List<Widget> list = List.generate(1, (index) => ErrorCard("Unable to connect to the server."));

    await Requests().getTeachersForEvent(context, widget.id).then((data) {
      list = List.generate(data.length, (i) {
        return TeacherCard(data[i]["id"], data[i]["name"]);
      });
      if(noInternet){
        setState(() {
          noInternet = false;
        });
      }
    }).onError((error, stackTrace){
      print(error);

      if(!noInternet){
        setState(() {
          noInternet = true;
        });
      }
    });

    return list;
  }

  Future<List<Widget>> buildStudentCards() async{
    List<Widget> list = List.generate(1, (index) => ErrorCard("Unable to connect to the server."));

    if(widget.type == "Pflicht"){
      list = List.generate(1, (i) {
        return UserCard(0, "Alle Schüler.");
      });
    }else{
      await Requests().getStudentsForEvent(context, widget.id).then((data) {
        list = List.generate(data.length, (i) {
          return UserCard(data[i]["id"], data[i]["name"]);
        });

        if(noInternet){
          setState(() {
            noInternet = false;
          });
        }
      }).onError((error, stackTrace){
        print(error);
        if(!noInternet){
          setState(() {
            noInternet = true;
          });
        }
      });
    }

    return list;
  }
}
