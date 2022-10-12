import 'package:event_planner/main.dart';
import 'package:event_planner/network/Authenticator.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _wrongPassword = false;
  bool _obscureText = true;
  bool _fieldsEmpty = false;
  bool _error = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.indigo
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 90,
                    width: 200,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                    child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 32,fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(
                    height: 60,
                    width: 10,
                  ),
                  if(_wrongPassword) ... [
                    Visibility(
                      visible: true,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
                        child: const Text(
                          "Wrong credentials entered",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ]
                  else if(_fieldsEmpty) ... [
                    Visibility(
                      visible: _fieldsEmpty,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
                        child: const Text(
                          "Please enter a username/password",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ]else if(_error) ... [
                    Visibility(
                      visible: _error,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20, right: 10, bottom: 20),
                        child: const Text(
                          "Error: Please check your connection.",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Container(
                      width: MediaQuery.of(context).size.width-30,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Column(children: <Widget>[
                        TextFormField(
                          onTap: () {
                            setState(() {
                              _wrongPassword = false;
                              _fieldsEmpty = false;
                              _error = false;
                            });
                          },
                          controller: usernameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                              contentPadding: EdgeInsets.all((18))
                          ),
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        ),
                        const Divider(
                          thickness: 3,
                        ),
                        TextFormField(
                          onTap: () {
                            setState(() {
                              _wrongPassword = false;
                              _fieldsEmpty = false;
                              _error = false;
                            });
                          },
                          onFieldSubmitted: (data) async {
                            if(usernameController.text == "" || passwordController.text == ""){
                              setState(() {
                                _fieldsEmpty = true;
                              });
                              return;
                            }

                            setState(() {
                              _loading = true;
                            });

                            bool wrong = false;
                            bool error = false;

                            int authenticated = await Authenticator().authenticate(usernameController.text, passwordController.text);

                            if(authenticated == 200){
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => MainPage(0)),
                                    (Route<dynamic> route) => false,
                              );
                            }
                            if(authenticated == 500) {
                              error = true;
                            }
                            if(authenticated == 204) {
                              wrong = true;
                            }
                            if(authenticated == 404) {
                              wrong = true;
                            }
                            setState(() {
                              _loading = false;
                              _error = error;
                              _wrongPassword = wrong;
                            });
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            contentPadding: const EdgeInsets.all(18),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureText,
                        )
                      ]
                      )
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width-30,
                      height: 60,
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                        child: const Text("Submit", style: TextStyle(color: Colors.white),),
                        onPressed: () async {
                          if(usernameController.text == "" || passwordController.text == ""){
                            setState(() {
                              _fieldsEmpty = true;
                            });
                            return;
                          }

                          setState(() {
                            _loading = true;
                          });

                          bool wrong = false;
                          bool error = false;

                          int authenticated = await Authenticator().authenticate(usernameController.text, passwordController.text);

                          if(authenticated == 200){
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MainPage(0)),
                                  (Route<dynamic> route) => false,
                            );
                          }
                          if(authenticated == 500) {
                            error = true;
                          }
                          if(authenticated == 204) {
                            wrong = true;
                          }
                          if(authenticated == 404) {
                            wrong = true;
                          }
                          setState(() {
                            _loading = false;
                            _error = error;
                            _wrongPassword = wrong;
                          });
                        },
                      )
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width-30,
                      height: 50,
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                    height: 200,
                                    color: Colors.indigo,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 10),
                                          child: Text("Bitte schreibe Henry Herrmann oder Jermie Bents eine Nachricht.", style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),),
                                        )
                                      ],
                                    )
                                );
                              }
                          );
                        },
                        child: const Text("Passwort vergessen", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                      )
                  ),
                  Visibility(
                    visible: _loading,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 20, right: 10, top: 30),
                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
      ),
    );
  }
}