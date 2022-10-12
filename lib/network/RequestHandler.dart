import 'dart:convert';

import 'package:http/http.dart' as http;
String _apiHost = "http://202.61.201.124:900";

void init (String host) {
  _apiHost = host;
}

class Request {

  String router, method;
  late http.Request httpRequest;

  Request(this.method, this.router) {
    // this.httpRequest = http.Request(method, Uri.parse("http://localhost:8080" + '/' + router));
    httpRequest = http.Request(method, Uri.parse("http://202.61.201.124:900" + '/' + router));
  }

  setHost(String host) async {
    httpRequest = http.Request(this.method, Uri.parse("http://202.61.201.124:900" + '/' + router));
    // httpRequest = http.Request(this.method, Uri.parse("http://localhost:8080" + '/' + this.router));
  }

  setHeader(Map<String, String> headers) {
    httpRequest.headers.addAll(headers);
  }

  setBody(Map<String, dynamic> body) {
    httpRequest.body = jsonEncode(body);
  }

  Response send() {
    return Response(httpRequest);
  }
}

class Response {

  late http.Request httpRequest;
  late http.StreamedResponse httpResponse;

  Map<String, dynamic> body = new Map();
  bool invalidRequest = false;

  late Function(dynamic) success, error, notFound, noDataReceived, forbidden, unauthorized;


  Response(this.httpRequest);

  Future<void> processResponse() async {
    try {

      print('[API] http-request: ${httpRequest.method}: ${httpRequest.url}');
      // print(httpRequest.headers);
      // print(httpRequest.body);

      var response =  await httpRequest.send();

      httpResponse = response;

      body = jsonDecode(await httpResponse.stream.bytesToString());
    } catch (_) {
      print(_);
      invalidRequest = true;
    }
  }

  void onSuccess(var callback){
    success = callback;
  }

  void onError(var callback) {
    error = callback;
  }

  void onUnauthorized(var callback) {
    unauthorized = callback;
  }

  void onForbidden(var callback) {
    forbidden = callback;
  }

  void onPageNotFound(var callback) {
    notFound = callback;
  }

  onNoResult(var callback) {
    noDataReceived = callback;
  }

  registerListeners(){
    if(invalidRequest) {
      return error('Error while sending request');
    }

    if(body.isEmpty || body['data'] == null) return notFound(this.body);

    if(body['data'] is Map<String, dynamic>) {
      Map<String, dynamic> data = body['data'];

      switch(getStatusCode()) {
        case 200: success(data); break;
        case 201: success(data); break;
        case 401: unauthorized(data); break;
        case 204: forbidden(data); break;
        case 404: notFound(data); break;
        case 500: error(data); break;
        default: error(httpResponse); break;
      }
    } else {
      List<dynamic> data = body['data'];

      switch(getStatusCode()) {
        case 200: success(data); break;
        case 201: success(data); break;
        case 401: unauthorized(data); break;
        case 204: forbidden(data); break;
        case 404: notFound(data); break;
        case 500: error(data); break;
        default: error(httpResponse); break;
      }
    }
    return;
  }

  int getStatusCode() {
    return (invalidRequest) ? 500 : httpResponse.statusCode;
  }

  String getIdentifier() {
    return '-${httpRequest.method}-${httpRequest.url}-${httpRequest.headers.toString()}';
  }

  String getCookies() {
    return httpResponse.headers["set-cookie"].toString();
  }
}

Future<bool> deviceIsConnectedToInternet() async {
  try {
    var request = http.Request('GET', Uri.parse('http://localhost:900'));
    var response = await request.send();

    print('http-request: $request');

    print(response.statusCode);

    return true;
  } catch(_) {
    print(_);
    return false;
  }
}