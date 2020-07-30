import 'package:flutter/material.dart';
import 'package:flutter_chat/helper/shared_preferences_helper.dart';
import 'package:flutter_chat/widgets/chatRoomTile.dart';

import '../services/database.dart';
import 'package:flutter_chat/views/search.dart';
import '../helper/authenticate.dart';
import '../helper/constants.dart';
import '../services/auth.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Auth auth = new Auth();
  Database db = new Database();
  Stream chatRoomsStream;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    snapshot.data.documents[index].data["chatRoomId"],
                    snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Center(
                child: Text(
                  "Here will appear your conversations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await SharedPreferencesHelper.getUsername();
    db.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
        actions: [
          GestureDetector(
            onTap: () {
              auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Authenticate(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Search(),
            ),
          );
        },
      ),
    );
  }
}
