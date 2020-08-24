import 'package:d2shop_admin/src/models/chat_model.dart';
import 'package:d2shop_admin/src/models/doonstore_user.dart';
import 'package:d2shop_admin/src/services/firestore_services.dart';
import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _tec = TextEditingController();

  bool showingChat = false;
  List<SupportMessages> messages = [];
  DoonStoreUser user;

  void sendMessage(BuildContext context) {
    if (_tec.text.isNotEmpty) {
      SupportMessages supportMessages = SupportMessages(
        id: Uuid().v4(),
        dateTime: DateTime.now().toString(),
        from: 'support',
        to: user.userId,
        isUser: false,
        message: _tec.text,
        userId: user.userId,
      );

      FirestoreServices().sendMessageToSupport(supportMessages).then((value) {
        setState(() {
          messages.add(supportMessages);
          _tec.text = '';
          _tec.clear();
        });
      });
    } else
      Utils.showMessage("Please write something.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showingChat
          ? AppBar(
              title: Text(
                user.displayName,
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              elevation: 5.0,
              backgroundColor: Colors.teal[400],
              leading: IconButton(
                icon: FaIcon(FontAwesomeIcons.chevronCircleLeft),
                onPressed: () {
                  setState(() {
                    showingChat = false;
                  });
                },
              ),
            )
          : null,
      bottomSheet: showingChat
          ? Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tec,
                      decoration: InputDecoration(
                        labelText: "Type your message...",
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(FontAwesomeIcons.paperPlane),
                    onPressed: () => sendMessage(context),
                  )
                ],
              ),
            )
          : null,
      body: StreamProvider<List<SupportMessages>>.value(
        value: FirestoreServices().getMessages,
        builder: (context, child) {
          List<SupportMessages> _messages =
              Provider.of<List<SupportMessages>>(context);

          if (_messages != null) {
            Map<String, String> userList = {};

            _messages.forEach((element) {
              userList[element.userId] = element.message;
            });

            List<String> userIds = userList.keys.toList();

            return AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: !showingChat
                  ? ListView.builder(
                      itemCount: userIds.length,
                      itemBuilder: (context, index) =>
                          FutureBuilder<DoonStoreUser>(
                        future: FirestoreServices().getUser(userIds[index]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return ListTile(
                              title: Text('Loading...'),
                            );

                          DoonStoreUser _user = snapshot.data;

                          return Material(
                            color: Colors.teal[400],
                            borderRadius: BorderRadius.circular(12),
                            animationDuration: Duration(milliseconds: 300),
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  messages = _messages
                                      .where((element) =>
                                          element.userId == _user.userId)
                                      .toList();
                                  user = _user;
                                  showingChat = true;
                                });
                              },
                              title: Text(
                                _user.displayName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : showMessages(),
            );
          } else
            return Text('');
        },
      ),
    );
  }

  Widget showMessages() {
    messages.sort((a, b) => DateTime.parse(b.dateTime)
        .millisecondsSinceEpoch
        .compareTo(DateTime.parse(a.dateTime).millisecondsSinceEpoch));

    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: ListView.builder(
        itemBuilder: (context, index) {
          bool isUser = messages[index].isUser;

          return ListTile(
            dense: true,
            leading: isUser
                ? Material(
                    elevation: 5.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        getName(user.displayName),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : null,
            title: Text(
              messages[index].message,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: !isUser ? TextAlign.end : TextAlign.start,
            ),
            subtitle: Text(
              DateFormat.jms()
                  .add_MMMd()
                  .format(DateTime.parse(messages[index].dateTime)),
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: !isUser ? TextAlign.end : TextAlign.start,
            ),
            trailing: !isUser
                ? Material(
                    elevation: 5.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/support.png"),
                    ),
                  )
                : null,
          );
        },
        itemCount: messages.length,
        reverse: true,
      ),
    );
  }

  getName(String name) {
    var _data = name.split(" ");
    return _data.length > 1
        ? _data[0].substring(0, 1) + _data[1].substring(0, 1)
        : _data[0].substring(0, 1);
  }
}
