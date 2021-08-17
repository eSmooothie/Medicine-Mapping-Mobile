import 'dart:async';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key, required this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> with WidgetsBindingObserver {
  TextEditingController _chatMessageController = TextEditingController();

  Timer? timer;
  bool waitingForResponse = false;
  StreamController _streamController = new StreamController<dynamic>();
  Stream? _stream;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this); // Adding an observer
    setTimer(true); // Setting a timer on init
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancelling a timer on dispose
    WidgetsBinding.instance!.removeObserver(this); // Removing an observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool isBackground = state != AppLifecycleState.resumed;
    setTimer(isBackground);
    print("isAppInBackground: $isBackground");
  }

  void setTimer(bool isBackground) {
    int delaySeconds = isBackground ? 5 : 3;
    print("Set timer.");
    // Cancelling previous timer, if there was one, and creating a new one
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: delaySeconds), (t) async {
      // Not sending a request, if waiting for response
      if (!waitingForResponse) {
        waitingForResponse = true;
        var x = await post();
        _streamController.sink.add(x);
        waitingForResponse = false;
      }
    });
  }

  // Async method returns Future<> object
  Future<dynamic> post() async {
    var rand = new Random();
    int x = rand.nextInt(10);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          minHeight: 50.0,
          minWidth: 50.0,
          side: BorderSide(color: Colors.transparent),
        ),
        title: Text("Pharmacy Name"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: _streamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print("${snapshot.data} from builder.");
              return Text("hi");
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomWidget.outlinedButton(
                    onPressed: () {
                      print("upload image..");
                    },
                    child: Icon(Icons.image),
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: CustomWidget.textField(
                    controller: _chatMessageController,
                    labelText: "write a message",
                  ),
                ),
                Expanded(
                  child: CustomWidget.outlinedButton(
                    onPressed: () {
                      print("send...");
                    },
                    child: Icon(Icons.send),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
