import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html_demo/loading_container.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  late WebViewController _controller;
  late String _jsStr;
  late String _cssStr;
  String _htmlStr = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  _loadFile() async {
    _cssStr = await DefaultAssetBundle.of(context).loadString("bundles/fontMode.css");
    _jsStr = await DefaultAssetBundle.of(context).loadString("bundles/fontMode.js");
    _htmlStr = await DefaultAssetBundle.of(context).loadString("bundles/fontHtml.html");
    Future.delayed(Duration(seconds: 2), (){
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WebView加载HTML"),
        ),
        body: LoadingContainer(
          isLoading: _isLoading,
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl: Uri.dataFromString(_htmlStr, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                      .toString(),
                  //JS执行模式 是否允许JS执行
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _controller = controller;
                  },
                  onPageFinished: (url) {
                    _controller.evaluateJavascript("document.documentElement.clientHeight;").then((result){
                      setState(() {
                        print("高度${double.parse(result)}");
                      });
                    }
                    );
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if(request.url.startsWith("myapp://")) {
                      print("即将打开 ${request.url}");
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  } ,
                  javascriptChannels: <JavascriptChannel>[
                    JavascriptChannel(
                        name: "share",
                        onMessageReceived: (JavascriptMessage message) {
                          print("参数： ${message.message}");
                        }
                    ),
                  ].toSet(),

                ),
              ),
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: (){}, child: Text("小号")),
                    ElevatedButton(onPressed: (){}, child: Text("中号")),
                    ElevatedButton(onPressed: (){}, child: Text("大号")),
                    ElevatedButton(onPressed: (){}, child: Text("特大号")),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
