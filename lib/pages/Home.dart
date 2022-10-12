
import 'package:event_planner/network/Cache.dart';
import 'package:event_planner/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/network/RequestHandler.dart' as requesthandler;
import 'package:flutter/scheduler.dart';

import '../network/RequestHandler.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Map<String, dynamic> map = <String, dynamic>{};
Cache cache = Cache();

Future<Map<String, dynamic>> getStats() async{
  await cache.getValue("home").then((value) async {
    if(value.isEmpty){
      Map<String, dynamic> cookie = await cache.getValue("session");
      Request request = Request("GET", "v1/stats");

      Response response = request.send();

      await response.processResponse();

      response.onSuccess((data){
        var rmap = data[0] as Map<String, dynamic>;
        map = rmap;
        cache.save("home", map);
      });

      response.onUnauthorized((error) {
        throw("unauthorized");
      });

      response.onError((error) {
        throw("error");
      });

      response.registerListeners();
    }else{
      map = value;
    }
  });

  return map;
}



class _HomeState extends State<Home> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.indigo
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Text("Home", style: TextStyle(color: Colors.white, fontSize: 32,fontWeight: FontWeight.bold),),
                ),
                RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      Duration(seconds: 1),
                        () async {
                          Map<String, dynamic> temp = <String, dynamic>{};
                          Request request = Request("GET", "v1/stats");

                          late Response response = request.send();

                          await response.processResponse();

                          response.onUnauthorized((error) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Future.delayed(Duration.zero, () {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                const Login()), (Route<dynamic> route) => false);
                              });
                            });
                          });

                          response.onSuccess((data){
                            var rmap = data[0] as Map<String, dynamic>;
                            temp = rmap;
                            cache.save("home", rmap);
                          });

                          response.onError((error) {
                            temp = map;
                          });

                          response.registerListeners();

                        }
                    );
                  },
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: FutureBuilder<Map<String, dynamic>>(
                            future: getStats(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                var startDate = DateTime.fromMillisecondsSinceEpoch(snapshot.data!["startDate"]);
                                var endDate = DateTime.fromMillisecondsSinceEpoch(snapshot.data!["endDate"]);

                                var startDateString = startDate.day.toString() + "/" + startDate.month.toString() + "/" + startDate.year.toString() + " " + startDate.hour.toString() + ":" + (startDate.minute < 10 ? startDate.minute.toString() + "0" : startDate.minute.toString());
                                var endDateString = endDate.day.toString() + "/" + endDate.month.toString() + "/" + endDate.year.toString() + " " + endDate.hour.toString() + ":" + (endDate.minute < 10 ? endDate.minute.toString() + "0" : endDate.minute.toString());

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                                        child: Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const ListTile(
                                                leading: Icon(Icons.info_outline_rounded),
                                                title: Text("Studienfahrt 2022"),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 1, left: 15, right: 15, bottom: 15),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text('Dauer: ' + startDateString + " bis " + endDateString),
                                                        Text("Verbleibende Tage: " + (daysBetween(DateTime.now(), endDate) > 4 ? "Noch nicht losgefahren." : daysBetween(DateTime.now(), endDate).toString()))
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 16, right: 16, top: 25),
                                        child: Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const ListTile(
                                                leading: Icon(Icons.info_outline_rounded),
                                                title: Text("Stats"),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 1, left: 15, right: 15, bottom: 15),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text("Events heute: " + snapshot.data!["eventsToday"].length.toString()),
                                                        Text("Events insgesamt: " + snapshot.data!["eventsAll"].length.toString())
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                );
                              }else if(snapshot.hasError){
                                print(snapshot.error);
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
                                        child: Card (
                                            color: Colors.redAccent,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                ListTile(
                                                  leading: Icon(Icons.error),
                                                  textColor: Colors.white,
                                                  title: Text("Could not connect to the server. Please check your connection."),
                                                )
                                              ],
                                            )
                                        )
                                    )
                                  ],
                                );
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
                            }
                        )
                    )
                )
              ],
            )
        )
    );
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}