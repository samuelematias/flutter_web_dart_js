import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html'
    as html; // importing the HTML proxying library and named it as html
// ignore: avoid_web_libraries_in_flutter
import 'dart:js'
    as js; // importing the Javascript proxying library and named it as js

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter for Web Demo - Part 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Give it a route that load when app is running
      home: MyHomePage(
        title: MyHomePage.homeTitle,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static String homeTitle = 'Home Page';
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var elem = html.document.activeElement;

  // @override
  // void initState() {
  //   if (elem != null && elem.tagName == 'IFRAME') {
  //     Timer.periodic(Duration(milliseconds: 100), (timer) {
  //       // print(timer.tick.toString());
  //       html.window.alert("You're being redirected to lol");
  //     });
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.greenAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // InkWell is widget used to add taps & gestures events to child
            InkWell(
              onTap: () {
                final String _url = html.window.location.href;
                final String _queryParameters =
                    '${Uri.base.toString()} || ${Uri.base.query} || ${Uri.base.queryParameters['randomNumber']}';
                //Dart to HTML Proxying
                html.window.localStorage.addEntries([
                  MapEntry(
                      "data", "this data is stored on browser local storage")
                ]);

                //Dart to Javascript Proxying
                //Creates json object from javascript library
                js.JsObject jsonObject = js.JsObject(js.context['Object']);

                //Create object {"message":"Flutter Web"}
                jsonObject["message"] = 'Flutter Web';

                //Executes javascripts console.log();
                js.context["console"].callMethod("log",
                    ['still in the same page', '\n', jsonObject["message"]]);

                html.window.alert("KAPPA $_url || $_queryParameters");

                // if (elem != null && elem.tagName == 'IFRAME') {
                //   html.window.alert("LOL lol");
                // }

                print(Uri.base
                    .toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
                print(Uri.base.query); // id=15&randomNumber=3.14
                print(Uri.base.queryParameters['randomNumber']); // 3.14

                jsonObject["message"] = '$_queryParameters';
              },
              child: FlutterLogo(
                size: 100.0,
              ),
            ),
            InkWell(
              onTap: () {
                String externalUrl =
                    'https://github.com/samuelematias/flutter_web_dart_js';
                html.window.alert("You're being redirected to \n $externalUrl");

                //Dart to Javascript Proxying
                //Executes javascripts window.open(https://github.com/vaygeth89/flutter_for_web_part1, '');
                js.context.callMethod("open", [externalUrl]);
              },
              child: Image.network(
                "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
                width: 100,
                height: 100,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          html.window.location.reload();
        },
      ),
    );
  }
}
