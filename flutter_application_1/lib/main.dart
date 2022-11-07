import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/views/pages/pages.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEPD X CC',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();
  bool _initialUriIsHandled = false;
  bool handleThis = false;

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('Uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('Err : $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (_initialUriIsHandled == false) {
      _initialUriIsHandled = true;
      print('Success');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('No Uri!');
        } else {
          handleThis = true;
          print('Got Uri!');
        }

        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        print('Failed Getting Uri');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (handleThis == true) {
      return const Emailverify(); //Ke page congratulation jika link yang didapatkan sama

    } else {
      _handleInitialUri(); //Untuk print jika tidak ada uri yang masuk
      return Scaffold(
        appBar: AppBar(
          title: Text("DEPD X CC"),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Emailsend()),
                      );
                    },
                    child: Text("Send Mail Page")),
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Ongkirpage()),
                      );
                    },
                    child: Text("Ongkir Page")),
              )
            ],
          ),
        ),

        // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
}
