import 'dart:io';

import 'package:flutter/material.dart';

import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final cookieManager = WebviewCookieManager();

  final String _url = 'https://m.youtube.com';
  final String cookieValue = 'some-cookie-value';
  final String domain = 'm.youtube.com';
  final String cookieName = 'some_cookie_name';

  @override
  void initState() {
    super.initState();
    cookieManager.clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(_url))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) async {
          final gotCookies = await cookieManager.getCookies(_url);
          for (var item in gotCookies) {
            print(item);
          }
        },
      ));
    cookieManager.setCookies([
      Cookie(cookieName, cookieValue)
        ..domain = domain
        ..expires = DateTime.now().add(Duration(days: 10))
        ..httpOnly = false
    ]);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
              icon: Icon(Icons.ac_unit),
              onPressed: () async {
                // TEST CODE
                await cookieManager.getCookies(null);
              },
            )
          ],
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
