import 'package:event_planner/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:event_planner/network/RequestHandler.dart';

import 'Cache.dart';

class Requests {
  Cache cache = Cache();

  Future<List> getEvents(BuildContext context) async {
    List<dynamic> list = List.empty();
    Map<String, dynamic> cookie = await Cache().getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              const Login()), (Route<dynamic> route) => false);
        });
      });
      return List.empty();
    }

    Request request = Request("GET", "v1/events/all");

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late Response response = request.send();

    await response.processResponse();

    response.onSuccess((data){
      list = data;
    });

    response.onError((error) {
      throw("error");
    });

    response.onPageNotFound((callback) {
      throw("Not found.");
    });

    response.onUnauthorized((callback){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.registerListeners();

    return list;
  }

  Future<List<String>> getAllUsers(BuildContext context) async {
    List<dynamic> list = List.empty();
    Map<String, dynamic> cookie = await Cache().getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
      return List.empty();
    }

    Request request = Request("GET", "v1/users");

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late Response response = request.send();

    await response.processResponse();

    response.onSuccess((data){
      print(data);
      list = data;
    });

    response.onError((error) {
      throw("error");
    });

    response.onPageNotFound((callback) {
      throw("Not found.");
    });

    response.onUnauthorized((callback){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.registerListeners();

    return List.empty();
  }

  Future<List> getTeachersForEvent(BuildContext context, int eventId) async {
    List<dynamic> list = List.empty();
    Map<String, dynamic> cookie = await Cache().getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
      return List.empty();
    }

    Request request = Request("GET", "v1/event/" + eventId.toString() + "/teachers");

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late Response response = request.send();

    await response.processResponse();

    response.onSuccess((data){
      list = data;
    });

    response.onError((error) {
      throw("error");
    });

    response.onPageNotFound((callback) {
      throw("Not found.");
    });

    response.onUnauthorized((callback){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.registerListeners();

    return list;
  }

  Future<List> getStudentsForEvent(BuildContext context, int eventId) async {
    List<dynamic> list = List.empty();
    Map<String, dynamic> cookie = await Cache().getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
      return List.empty();
    }

    Request request = Request("GET", "v1/event/" + eventId.toString() + "/users");

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late Response response = request.send();

    await response.processResponse();

    response.onSuccess((data){
      list = data;
    });

    response.onError((error) {
      throw("error");
    });

    response.onPageNotFound((callback) {
      throw("Not found.");
    });

    response.onUnauthorized((callback){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.registerListeners();

    return list;
  }

  Future<bool> updateEvent(BuildContext context, int id, String newName, String newDescription, DateTime newDate, String newType) async {
    bool result = false;
    Map<String, dynamic> cookie = await Cache().getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              const Login()), (Route<dynamic> route) => false);
        });
      });
      return Future.value(false);
    }

    Request request = Request("PATCH", "v1/event/" + id.toString() + "/update");

    Map<String, dynamic> body = <String, dynamic>{};
    body["name"] = newName;
    body["desc"] = newDescription;
    body["date"] = DateTime(newDate.year, newDate.month, newDate.day, newDate.hour, newDate.minute).millisecondsSinceEpoch;
    body["type"] = newType;

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);
    request.setBody(body);

    late Response response = request.send();

    await response.processResponse();


    response.onSuccess((data) {
      result = true;
    });

    response.onError((data) {
      throw("error");
    });

    response.onUnauthorized((data) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.onForbidden((data) {
      throw("forbidden");
    });

    response.registerListeners();

    return result;
  }

  Future<void> joinEvent(BuildContext context, int eventId) async {
    Map<String, dynamic> cookie = await cache.getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
      return Future.value(0);
    }
    Request request = Request("POST", "v1/event/join/" + eventId.toString());

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late Response response = request.send();

    await response.processResponse();


    response.onSuccess((data) {

    });

    response.onError((data) {
      print("err");
      throw("error");
    });

    response.onUnauthorized((data) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.onForbidden((data) {
      throw("forbidden");
    });
  }

  Future<void> leaveEvent(BuildContext context, int eventId) async {
    Map<String, dynamic> cookie = await cache.getValue("session");

    if(cookie.isEmpty){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
      return Future.value(0);
    }
    Request request = Request("DELETE", "v1/event/leave/" + eventId.toString());

    Map<String, String> header= <String, String>{};
    header["content-type"] = "application/json";
    header["cookie"] = cookie["session"];

    request.setHeader(header);

    late Response response = request.send();

    await response.processResponse();


    response.onSuccess((data) {

    });

    response.onError((data) {
      throw("error");
    });

    response.onUnauthorized((data) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const Login()), (Route<dynamic> route) => false);
        });
      });
    });

    response.onForbidden((data) {
      throw("forbidden");
    });

    response.registerListeners();
  }

  Future<bool> addUser(BuildContext context, int eventId, List<int> users) async {
    Map<String, dynamic> cookie = await cache.getValue("session");

    if(cookie.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>
              const Login()), (Route<dynamic> route) => false);
        });
      });
      return Future.value(false);
    }

      Request request = new Request("POST", "v1/event/join/${eventId}/massAdd/");

      Map<String, String> headers = new Map<String, String>();
      headers["content-type"] = "application/json";
      headers["cookie"] = cookie["session"];

      Map<String, dynamic> body = new Map<String, dynamic>();
      body["users"] = users;

      request.setHeader(headers);
      request.setBody(body);

      Response response = request.send();

      await response.processResponse();

      response.onSuccess((data) {
        return true;
      });

      response.onError((error) {
        throw(error);
      });

      response.onUnauthorized((data) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) =>
                const Login()), (Route<dynamic> route) => false);
          });
        });
      });

      response.onForbidden((data){
        throw(data);
      });

      response.registerListeners();

      return false;
  }
}