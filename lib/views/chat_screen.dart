import 'package:flutter/material.dart';

import '../widgets/messageTileWidget.dart';
import '../services/database.dart';
import '../helper/constants.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  ChatScreen({this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Database db = new Database();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data["message"]);
                })
            : Center(
                child: Text(
                  "Send a message to start a conversation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      db.addChatMessage(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    db.getChatMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatScreen'),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
