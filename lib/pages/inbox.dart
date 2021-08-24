import 'dart:async';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportModel.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  Future _future = Future(() async {
    await Future.delayed(Duration(seconds: 10));
    return [];
  });

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<InboxInfo> _inboxInfo = [];
              snapshot.data.forEach((Pharmacy pharmacy) {
                int newMessage = 0; // message that has not ben seen yet
                InboxInfo info = new InboxInfo(
                    id: int.parse(pharmacy.id),
                    pharmacyName: pharmacy.name,
                    newMessages: newMessage);
                _inboxInfo.add(info);
              });
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InboxItemContainer(
                    onPressed: () {
                      // go to chat box.
                      Navigator.pushNamed(
                        context,
                        chatBoxPage,
                        arguments: _inboxInfo[index].id,
                      );
                    },
                    pharmacyName: _inboxInfo[index].pharmacyName,
                    notif: (_inboxInfo[index].newMessages > 0)
                        ? InboxNotifaction(
                            newMessage: _inboxInfo[index].newMessages,
                          )
                        : null,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 1.0,
                ),
                itemCount: _inboxInfo.length,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var rand = new Random();
                double titleWidth =
                    rand.nextInt(200).clamp(50, 200).floorToDouble();
                double descHeight =
                    rand.nextInt(100).clamp(20, 100).floorToDouble();
                return InboxItemContainerSkeleton(
                  titleWidth: titleWidth,
                  descHeight: descHeight,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: 7,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose inbox page.");
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactive inbox page.");
    super.deactivate();
  }
}

class InboxInfo {
  final int id;
  final String pharmacyName;
  final int newMessages;

  InboxInfo({
    required this.id,
    required this.pharmacyName,
    required this.newMessages,
  });
}
