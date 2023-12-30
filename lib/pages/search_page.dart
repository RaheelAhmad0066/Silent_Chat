import 'package:silent/pages/chat_page.dart';
import 'package:silent/screens/home_screen.dart';
import 'package:silent/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../api/apis.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String username = APIs.user.displayName.toString();

  bool _isJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCurrentUserIdAndName();
  }

  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Search",
          ),
        ),
        body: Column(children: [
          Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Search Groups...",
                      hintStyle: TextStyle(color: Colors.black)),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.search,
                        color: color,
                      )),
                )
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))
              : groupList()
        ]));
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await DatabaseService(uid: APIs.user.uid)
          .searchByName(searchController.text)
          .then((value) {
        setState(() {
          searchSnapshot = value;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                username,
                searchSnapshot!.docs[index]["groupId"],
                searchSnapshot!.docs[index]["groupName"],
                searchSnapshot!.docs[index]['admin'],
                searchSnapshot!.docs[index]['groupIcon'],
              );
            })
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: APIs.user.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(String username, String groupId, String groupName,
      String admin, String groupIcon) {
    joinedOrNot(username, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          if (_isLoading) {
            // Prevent multiple taps while loading
            return;
          }

          setState(() {
            _isLoading = true;
          });

          await DatabaseService(uid: APIs.user.uid)
              .toggleJoin(groupId, groupName, username);
          setState(() {
            _isLoading = false;
          });
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });

            showSnackbar(context, Colors.red, "Left group ${groupName}");

            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                    groupId: groupId,
                    groupName: groupName,
                    userName: username,
                    groupIcon: groupIcon,
                  ));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
              showSnackbar(context, Colors.green,
                  "Successfully joined group $groupName");
            });
          }
        },
        child: _isLoading
            ? CircularProgressIndicator()
            : _isJoined
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Joined",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text("Join Now",
                        style: TextStyle(color: Colors.white)),
                  ),
      ),
    );
  }
}
