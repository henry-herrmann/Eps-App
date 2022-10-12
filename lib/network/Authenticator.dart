import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'Cache.dart';
import 'package:event_planner/network/RequestHandler.dart' as requesthandler;

class Authenticator {
  Cache cache = Cache();

  Future<int> authenticate(String username, String password) async{
    requesthandler.Request request = requesthandler.Request("POST", "v1/login");

    Map<String, dynamic> body = <String, dynamic>{};
    body["name"] = username;
    body["password"] = password;

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";

    request.setHeader(header);
    request.setBody(body);

    late requesthandler.Response response = request.send();

    await response.processResponse();

    int code = 500;

    response.onSuccess((data) async {
      code = 200;

      var session = response.getCookies();

      Map<String, String> cookie = <String, String>{};

      cookie["session"] = session;

      await cache.save("session", cookie);
      await cache.save("user", data[0]);
    });

    response.onError((error) {
      code = 500;
    });

    response.onPageNotFound((callback) {
      code = 404;
    });

    response.onUnauthorized((callback){
      code = 204;
    });

    response.registerListeners();

    return code;
  }

  void function() {

  }

  Future<bool> validateSession() async {
    Map<String, dynamic> cookie = await cache.getValue("session");

    if(cookie.isEmpty){
      return false;
    }

    bool temp = false;

    requesthandler.Request request = requesthandler.Request("GET", "v1/user/profile");

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";

    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late requesthandler.Response response = request.send();


    await response.processResponse();


    response.onSuccess((data) async{
      temp = true;
      await cache.save("user", data[0]);
    });

    response.onError((error) {
    });

    response.onPageNotFound((callback) {
    });

    response.onUnauthorized((callback){
      print("err");
    });

    response.registerListeners();

    return temp;
  }
}