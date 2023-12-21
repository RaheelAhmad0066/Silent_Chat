import 'package:silent/helper/helper_function.dart';
import 'package:silent/pages/profile_page.dart';
import 'package:silent/pages/search_page.dart';
import 'package:silent/service/database_service.dart';
import 'package:silent/widgets/group_tile.dart';
import 'package:silent/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../api/apis.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = APIs.user.displayName.toString();
  String email = APIs.user.email.toString();
  String userDp = APIs.user.photoURL.toString();
  Stream<QuerySnapshot>? groups;
  bool _isLoading = false;
  String groupName = "";
  DocumentSnapshot? groupData;
  List<String> groupIds = List.empty(growable: true);

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    // await HelperFunctions.getUserEmailFromSF().then((value) {
    //   setState(() {
    //     email = value!;
    //   });
    // });

    // await HelperFunctions.getUserNameFromSF().then((value) {
    //   setState(() {
    //     username = value!;
    //   });
    // });

    // await HelperFunctions.getUserProfilePicFromSF().then((value) {
    //   setState(() {
    //     if (value != null) {
    //       userDp = value!;
    //     }
    //     print(userDp);
    //   });
    // });

    // getting user snapshots

    await DatabaseService(uid: "${APIs.user.uid}_$username")
        .getUserGroupsv1()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  // getGroupRecentMessageData(String groupId) async {
  //   await DatabaseService(uid: APIs.user.uid)
  //       .getGroupRecentMessageData(groupId)
  //       .then((value) {
  //     setState(() {
  //       groupData = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: Icon(Icons.search))
        ],
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Groups",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children: [
              (userDp == "")
                  ? Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Colors.grey,
                    )
                  : CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(userDp),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(username,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(Icons.group),
                title: Text(
                  "Groups",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              ListTile(
                onTap: () {
                  nextScreen(
                      context,
                      ProfilePage(
                          // username: username,
                          // email: email,
                          ));
                },
                selectedColor: Theme.of(context).primaryColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(Icons.group),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text("Logout"),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                // await authService.signOut();
                                // // Navigator.of(context).pushAndRemoveUntil(
                                // //     MaterialPageRoute(
                                // //         builder: (context) =>
                                // //             const LoginPage()),
                                // //     (route) => false);
                              },
                            )
                          ],
                        );
                      }));
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            popUpDialog(context);
          }),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Create a group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(20))),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });

                    DatabaseService(uid: APIs.user.uid)
                        .createGroup(username, APIs.user.uid, groupName)
                        .whenComplete(() => _isLoading = false);
                    Navigator.of(context).pop();
                    showSnackbar(
                        context, Colors.green, "Group created successfully");
                  }
                },
                child: Text("Create"),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
              )
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          //make checks

          if (snapshot.hasData) {
            if (snapshot.data.docs.length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var reverseIndex = snapshot.data.docs.length - index - 1;

                    return GroupTile(
                      groupId: snapshot.data.docs[reverseIndex]["groupId"],
                      groupName: snapshot.data.docs[reverseIndex]["groupName"],
                      userName: username,
                      groupIcon: snapshot.data.docs[reverseIndex]["groupIcon"],
                      recentMessage: snapshot.data.docs[reverseIndex]
                          ["recentMessage"],
                      recentMessageSender: snapshot.data.docs[reverseIndex]
                          ["recentMessageSender"],
                      recentMessageTime: snapshot.data.docs[reverseIndex]
                          ["recentMessageTime"],
                      isRecentMessageSeen: (snapshot
                              .data.docs[reverseIndex]["recentMessageSeenBy"]
                              .contains(APIs.user.uid))
                          ? true
                          : false,
                    );
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
