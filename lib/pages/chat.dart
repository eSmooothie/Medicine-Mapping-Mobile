import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:research_mobile_app/exports.dart';
import 'package:research_mobile_app/request/requestChat.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key, required this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> with WidgetsBindingObserver {
  TextEditingController _chatMessageController = TextEditingController();
  var pharmacyInfo;
  String? chatId;
  bool hasConvo = false;
  late Pharmacy pharmacy;
  Timer? timer;
  bool waitingForResponse = false;
  StreamController _streamController = new StreamController<dynamic>();
  Stream? _stream;
  ScrollController _scrollController = new ScrollController();
  bool scrollToLatest = true;

  final storage = new FlutterSecureStorage();
  final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);

  final ImagePicker _imagePicker = ImagePicker();

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

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  // Async method returns Future<> object
  Future<dynamic> post() async {
    // get chat
    String? phoneNumber = await storage.read(key: "phoneNumber");
    Map<String, dynamic> convoInformation = {
      'phoneNumber': phoneNumber,
      'pharmacyId': pharmacy.id,
    };
    var response = await RequestChat().getConversation(
      data: convoInformation,
    );
    if (chatId == null) {
      setState(() {
        chatId = response["chatId"];
      });
    }
    // print(response);
    List<ChatLine> convo = [];
    List<dynamic> chatLines = [];
    if (response.isNotEmpty) {
      chatLines = response["convo"];
      // print(chatLines.isEmpty);
      if (chatLines.isNotEmpty) {
        setState(() {
          hasConvo = true;
        });
      }

      // print(chatLines);
      chatLines.forEach((messages) {
        // print(messages);
        String to = (messages["from"] == "me") ? messages["from"] : "me";
        ChatLine message = new ChatLine(
          id: int.parse(messages["chatLineId"]),
          message: messages["message"],
          from: messages["from"],
          to: to,
          time: messages["createdAt"],
        );

        convo.add(message);
      });
    }

    return convo;
  }

  @override
  Widget build(BuildContext context) {
    // get the pharamcy info
    setState(() {
      pharmacyInfo = widget.arguments;
      pharmacy = pharmacyInfo;
    });
    // go to latest message execute only once

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
                  // print(hasConvo);
                  if (hasConvo) {
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
                      onPressed: () async {
                        print("upload image..");
                        // Pick an image from the gallery.
                        final XFile? image = await _imagePicker.pickImage(
                            source: ImageSource.gallery);

                        File _file = File(image!.path);
                        String? phoneNumber =
                            await storage.read(key: "phoneNumber");
                        var response = await RequestChat().sendImage(
                          tmpFile: _file,
                          chatId: chatId!,
                          phoneNumber: phoneNumber!,
                        );
                        print(image);
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
                      onPressed: () async {
                        // print(chatId);
                        String? phoneNumber =
                            await storage.read(key: "phoneNumber");
                        Map<String, dynamic> data = {
                          'phoneNumber': phoneNumber,
                          'message': _chatMessageController.text,
                          'chatId': chatId,
                        };
                        var response = await RequestChat().sendMessage(
                          data: data,
                        );

                        if (response.statusCode != 200) {
                          Utility().errorDialog(
                            context: context,
                            errtitle: "Sent failed.",
                            errContent: "${response.reasonPhrase}",
                          );
                          setState(() {
                            _chatMessageController.clear();
                          });
                        } else {
                          print("${response.body}");
                          setState(() {
                            _chatMessageController.clear();
                          });
                        }
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
    Pattern pattern = ":";
    // evaluate if a message is link.
    List<String> splitImage = message.split(":");
    bool isImage = false;
    if (splitImage[0] == "http") {
      isImage = true;
    }
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
              (isImage)
                  ? Image.network(
                      "$message",
                    )
                  : Text("$message"),
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
