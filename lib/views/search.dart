import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/helper/shared_preferences_helper.dart';

import '../helper/constants.dart';
import '../services/database.dart';
import '../widgets/searchtilewidget.dart';
import './chat_screen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

String _myName;

class _SearchState extends State<Search> {
  Database db = new Database();
  TextEditingController searchController = new TextEditingController();
  QuerySnapshot searchSnapShot;

  initiateSearch() {
    db.getUserByUsername(searchController.text).then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot.documents.length,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapShot.documents[index].data["username"],
                email: searchSnapShot.documents[index].data["email"],
              );
            })
        : Container(
            child: Center(
              child: Text(
                "No matching user",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
  }

  getUserInfo() async {
    _myName = await SharedPreferencesHelper.getUsername();
    setState(() {});
    print("name: $_myName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search username',
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
                      initiateSearch();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
