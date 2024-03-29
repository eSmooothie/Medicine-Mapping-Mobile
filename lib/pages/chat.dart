import 'dart:async';
import 'dart:io';

// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportModel.dart';
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
  ScrollController _scrollController = new ScrollController();
  bool scrollToLatest = true;

  final storage = new FlutterSecureStorage();
  final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // get the pharamcy info
    setState(() {
      pharmacyInfo = widget.arguments;
      pharmacy = pharmacyInfo;
    });
    WidgetsBinding.instance!.addObserver(this); // Adding an observer
    setTimer(true); // Setting a timer on init
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancelling a timer on dispose
    WidgetsBinding.instance!.removeObserver(this); // Removing an observer
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    _streamController.close();
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
    int numberOfLines = 0;
    print("Set timer.");
    var data = await post();
    _streamController.sink.add(data);
    numberOfLines = data.length;
    // Cancelling previous timer, if there was one, and creating a new one
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: delaySeconds), (t) async {
      // Not sending a request, if waiting for response
      if (!waitingForResponse) {
        waitingForResponse = true;
        var newData = await post();
        // check if their is a new message
        if (numberOfLines != newData.length) {
          numberOfLines = newData.length; // update
          if (_scrollController.hasClients) {
            var offset = _scrollController.position.maxScrollExtent;
            _scrollController.animateTo(
              offset,
              duration: Duration(milliseconds: 900),
              curve: Curves.easeInOut,
            );
          }
        }

        await Future.delayed(Duration(milliseconds: 500), () {
          _streamController.sink.add(newData);
        });

        waitingForResponse = false;
      }
    });

    // scroll to the latest message
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Async method returns Future<> object
  Future<List<ChatLine>> post() async {
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
    // go to latest message execute only once

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
        title: Text(pharmacy.name),
        centerTitle: true,
        // actions: [
        //   CustomWidget.outlinedButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, userProfilePage);
        //     },
        //     backgroundColor: Colors.transparent,
        //     minHeight: 50.0,
        //     minWidth: 50.0,
        //     side: BorderSide(color: Colors.transparent),
        //     child: Icon(
        //       Icons.settings,
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
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

                  return Center(child: Text("Send a message."));
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
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

                          if (image != null) {
                            File _file = File(image.path);
                            String? phoneNumber =
                                await storage.read(key: "phoneNumber");
                            await RequestChat().sendImage(
                              tmpFile: _file,
                              chatId: chatId!,
                              phoneNumber: phoneNumber!,
                            );
                            print(image);
                          }
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
                        labelText: "Message",
                        hintText: "",
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
    final DateFormat dateFormat = DateFormat("M/d/y, hh:mm a");
    DateTime dt = DateTime.parse(chatLine.time);
    String time = dateFormat.format(dt);
    // print(time);
    return Container(
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
                time: time,
              )
            : myMessage(
                from: chatLine.from,
                message: chatLine.message,
                time: time,
              ),
      ),
    );
  }

  List<Widget> otherMessage({
    required String from,
    required String message,
    required String time,
  }) {
    // evaluate if a message is link.
    List<String> splitImage = message.split(":");
    bool isImage = false;
    if (splitImage[0] == "http" || splitImage[0] == "https") {
      bool _validUrl = Uri.parse(message).isAbsolute;
      if (_validUrl) {
        Uri uri = Uri.parse(message);
        // print(uri.path.length);
        // print("${uri.path.length}: $message ");
        if (uri.path.length > 0) {
          String typeString =
              uri.path.substring(uri.path.length - 3).toLowerCase();
          if (typeString == "jpg" ||
              typeString == "png" ||
              typeString == "jpeg") {
            isImage = true;
          }
        }
      }
    }
    return [
      // Icon
      Flexible(
          flex: 1,
          child: Container(
            child: Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.blue,
            ),
          )),
      // message
      Flexible(
        flex: 5,
        fit: FlexFit.tight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.fromLTRB(5.0, 0, 10.0, 10.0),
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$from",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${time.toUpperCase()}",
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              (isImage)
                  ? Image.network(
                      message,
                      scale: 0.5,
                      errorBuilder: (BuildContext context, Object obj,
                          StackTrace? stackTrace) {
                        return Column(
                          children: [
                            Icon(Icons.broken_image),
                            Text("Broken Image ($message)")
                          ],
                        );
                      },
                    )
                  : Text("$message"),
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
    // evaluate if a message is link.
    List<String> splitImage = message.split(":");
    bool isImage = false;
    if (splitImage[0] == "http" || splitImage[0] == "https") {
      bool _validUrl = Uri.parse(message).isAbsolute;
      if (_validUrl) {
        Uri uri = Uri.parse(message);
        // print(uri.path.length);
        // print("${uri.path.length}: $message ");
        if (uri.path.length > 0) {
          String typeString =
              uri.path.substring(uri.path.length - 3).toLowerCase();
          if (typeString == "jpg" ||
              typeString == "png" ||
              typeString == "jpeg") {
            isImage = true;
          }
        }
      }
    }
    return [
      // message
      Flexible(
        flex: 5,
        fit: FlexFit.tight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.fromLTRB(10.0, 0, 5.0, 10.0),
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
                  color: Colors.white,
                ),
              ),
              Text(
                "${time.toUpperCase()}",
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              (isImage)
                  ? Image.network(
                      message,
                      scale: 0.5,
                      errorBuilder: (BuildContext context, Object obj,
                          StackTrace? stackTrace) {
                        return Column(
                          children: [
                            Icon(Icons.broken_image),
                            Text(
                              "Broken Image ($message)",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        );
                      },
                    )
                  : Text(
                      "$message",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
      // Icon
      Flexible(
          flex: 1,
          child: Container(
            child: Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.blue,
            ),
          )),
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
