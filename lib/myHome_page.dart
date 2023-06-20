import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sdb_quiz_4/models/user_model.dart';

import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isPrepareComplete = false;

  UsersModel usersModel = UsersModel();

  @override
  void initState() {
    super.initState();

    prepareData();
  }

  Future prepareData() async {
    var jsonData = await getMethod('jsonplaceholder.typicode.com', 'users/1');

    usersModel = UsersModel.fromJson(jsonData);

    isPrepareComplete = true;
  }

  Future getMethod(
    String hostStr,
    pathStr,
  ) async {
    try {
      Uri uri = Uri.https(hostStr, pathStr);

      var request = http.Request(
        'GET',
        uri,
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var res = await http.Response.fromStream(response);
        final result = jsonDecode(res.body) as Map<String, dynamic>;

        //print("|?|?|?||\n $result\n |?|?|?||");

        return result;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, trace) {
      print('ErrorFromAPIservice:: $e');
      print('ErrorFromAPIservice:: $trace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isPrepareComplete
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  singleField("name", usersModel.name.toString()),
                  singleField("username", usersModel.username.toString()),
                  singleField("email", usersModel.email.toString()),
                  singleField("phone", usersModel.phone.toString()),
                  singleField("address",
                      "${usersModel.address!.suite}\n${usersModel.address!.street}\n${usersModel.address!.city}\n${usersModel.address!.zipcode}"),
                  singleField("website", usersModel.website.toString()),
                  const Divider(
                    height: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("company"),
                  ),
                  singleField("name", usersModel.company!.name.toString()),
                  singleField("catchPhrase",
                      usersModel.company!.catchPhrase.toString()),
                  singleField("bs", usersModel.company!.bs.toString()),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  singleField(String? title, String? desc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title.toString()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              desc.toString(),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
