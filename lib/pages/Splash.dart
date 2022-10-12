import 'package:event_planner/main.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key : key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext ctx){
    return Scaffold(
      body: Container(
        height: MediaQuery.of(ctx).size.height,
        width: MediaQuery.of(ctx).size.width,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text("Studienfahrt 2022 Event Planner", style: TextStyle(color: Color.fromRGBO(74, 86, 238, 1), fontSize: 16), )
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Made by Henry Herrmann and Jeremie Bents", style: TextStyle(color: Color.fromRGBO(74, 86, 238, 1), fontSize: 16),)
                ]
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: OutlinedButton(
                  onPressed: (){
                    Navigator.push(ctx, MaterialPageRoute(builder: (context) => const MainPage(0)));
                  }, child: const Text("Proceed to Home")
              )
            )
          ]
        )
      )
    );
  }
}