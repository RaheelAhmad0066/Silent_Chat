import 'package:silent/helper/timestamp_converter.dart';
import 'package:silent/pages/chat_page.dart';
import 'package:silent/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String groupIcon;
  final String? recentMessage;
  final String? recentMessageSender;
  final String? recentMessageTime;
  final bool? isRecentMessageSeen;

  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.groupIcon,
      this.recentMessage,
      this.recentMessageSender,
      this.recentMessageTime,
      this.isRecentMessageSeen})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
                groupId: widget.groupId,
                groupName: widget.groupName,
                userName: widget.userName,
                groupIcon: widget.groupIcon));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
            leading: (widget.groupIcon == "")
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ))
                : CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.groupIcon),
                  ),
            title: Text(
              widget.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: (widget.recentMessage!.isEmpty ||
                    widget.recentMessageSender!.isEmpty)
                ? Text(
                    "Join the conversation as ${widget.userName}",
                    style: const TextStyle(fontSize: 13),
                  )
                : Text(
                    "${widget.recentMessageSender}: ${widget.recentMessage}",
                    style: (widget.isRecentMessageSeen!)
                        ? TextStyle(fontWeight: FontWeight.normal)
                        : TextStyle(fontWeight: FontWeight.bold),
                  ),
            // trailing: Icon(
            //   Icons.circle,
            //   color: (widget.isRecentMessageSeen!)
            //       ? Colors.white
            //       : Theme.of(context).primaryColor,
            // ),
            trailing: (widget.isRecentMessageSeen!)
                ? Text(DateTimeConverter.convertTimeStamp(
                    int.parse(widget.recentMessageTime!)))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      (widget.recentMessageTime != "")
                          ? Text(DateTimeConverter.convertTimeStamp(
                              int.parse(widget.recentMessageTime!)))
                          : SizedBox()
                    ],
                  )),
      ),
    );
  }
}
