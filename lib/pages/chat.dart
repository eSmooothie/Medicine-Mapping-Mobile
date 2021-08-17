import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  ScrollController _scrollController = new ScrollController();
  bool scrollToLatest = true;
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

  void setTimer(bool isBackground) async {
    int delaySeconds = isBackground ? 3 : 1;
    print("Set timer.");
    var x = await post();
    _streamController.sink.add(x);

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
    return [
      new ChatLine(
          id: 1, message: "hi", from: "me", to: "You", time: "1:00 pm"),
      new ChatLine(
          id: 2, message: "hello", from: "You", to: "me", time: "2:00 pm"),
      new ChatLine(
          id: 3, message: "test", from: "me", to: "You", time: "3:00 pm"),
      new ChatLine(
          id: 4, message: "test", from: "You", to: "me", time: "3:00 pm"),
      new ChatLine(
          id: 4, message: "test", from: "You", to: "me", time: "3:00 pm"),
      new ChatLine(
          id: 4, message: "test", from: "You", to: "me", time: "3:00 pm"),
      new ChatLine(
          id: 4, message: "test", from: "You", to: "me", time: "3:00 pm"),
      new ChatLine(
          id: 4, message: "test", from: "me", to: "me", time: "3:00 pm"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // go to latest message execute only once
    Timer(Duration(milliseconds: 500), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });

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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _streamController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // print("${snapshot.data}");
                  List<ChatLineHolder> _lines = [];

                  snapshot.data.forEach((ChatLine line) {
                    ChatLineHolder holder = new ChatLineHolder(
                      chatLine: line,
                    );
                    _lines.add(holder);
                  });

                  return ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _lines.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _lines.length) {
                          return Container(
                            height: 70.0,
                          );
                        }
                        return _lines[index];
                      });
                }

                return Center(child: Text("No Message"));
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black)),
              ),
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
          ),
        ],
      ),
    );
  }
}

class ChatLineHolder extends StatelessWidget {
  final ChatLine chatLine;
  const ChatLineHolder({
    Key? key,
    required this.chatLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (chatLine.from == "me") ? Colors.blue.shade100 : Colors.white,
      ),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: (chatLine.from != "me")
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: (chatLine.from != "me")
            ? otherMessage(
                from: chatLine.from,
                message: chatLine.message,
                time: chatLine.time,
              )
            : myMessage(
                from: chatLine.from,
                message: chatLine.message,
                time: chatLine.time,
              ),
      ),
    );
  }

  List<Widget> otherMessage({
    required String from,
    required String message,
    required String time,
  }) {
    return [
      Flexible(flex: 1, child: SvgIcons.userProfileHolder),
      Flexible(
        flex: 5,
        fit: FlexFit.tight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${from}",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("${time.toUpperCase()}"),
              SizedBox(
                height: 10.0,
              ),
              Text("${message}"),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> myMessage({
    required String from,
    required String message,
    required String time,
  }) {
    return [
      Flexible(
        flex: 5,
        fit: FlexFit.tight,
        child: Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$from",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("${time.toUpperCase()}"),
              SizedBox(
                height: 10.0,
              ),
              Text("$message"),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
      Flexible(flex: 1, child: SvgIcons.userProfileHolder),
    ];
  }
}

class ChatLine {
  final int id;
  final String message;
  final String from;
  final String to;
  final String time;
  // add file

  ChatLine({
    required this.id,
    required this.message,
    required this.from,
    required this.to,
    required this.time,
  });
}
