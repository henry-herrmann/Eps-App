import 'dart:async';

import 'package:event_planner/components/EventCard.dart';
import 'package:event_planner/network/Requests.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  final PageController controller;
  const Events(this.controller, {Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<Widget>> buildEventCards() async{
    List<Widget> list = List.generate(1, (index) => Text("Error"));

    await Requests().getEvents(context).then((data) {
      list = List.generate(data.length, (i) {
        return EventCard(data[i]["result"]["id"], data[i]["result"]["name"], data[i]["result"]["desc"], data[i]["result"]["date"], data[i]["member"], data[i]["result"]["type"], widget.controller);
      });
    }).onError((error, stackTrace){
      print(error);
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.indigo
            ),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
                  child: Text("Events", style: TextStyle(color: Colors.white, fontSize: 32,fontWeight: FontWeight.bold),),
                ),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: FutureBuilder<List<Widget>>(
                          future: buildEventCards(),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              return ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 5),
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
                )
              ],
            ),
          )
      )
    );
  }
}
