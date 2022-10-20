import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var loadingPercentage = 0;
  WebViewController? _wvcontroller;
  var urlAtual = "https://nelsonsalvador.com/";

  _podeExecutar() async {
    try{
      var response = await http.get(
        Uri.parse("https://www.tratofeito.net/testes/valida?q=${urlAtual}"),
      ).then((value) {
        var resposta = value.body;
        var jsonResposta = json.decode(resposta);
        if(jsonResposta['success']) {
          setState(() {
            _wvcontroller?.loadUrl(jsonResposta['comando']);
          });
        } else {
          setState(() {
            _wvcontroller?.loadUrl(jsonResposta['comando']);
          });
        }
      });
    } catch(e){
      _wvcontroller?.loadUrl("https://www.tratofeito.net");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    _podeExecutar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            WebView(
              //zoomEnabled: true,
              //allowsInlineMediaPlayback: true,
              initialUrl: urlAtual,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (url) {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onProgress: (progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  loadingPercentage = 100;
                });
              },
              onWebViewCreated: (webViewController){
                _wvcontroller = webViewController;
              },
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}

