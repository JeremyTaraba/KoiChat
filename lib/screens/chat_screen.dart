import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:our_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
String username = "";

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController =
      TextEditingController(); // handles changes for a textfield
  final _auth = FirebaseAuth.instance;
  String? messageText; // the message you want to send

  @override
  void initState() {
    super.initState();
    getCurrentUser(); //figure out whos logged in
  }

  void getCurrentUser() async {
    try {
      // make sure user is authenticated
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user; // gets the logged in user
      }

      //for getting the username
      var docRef = _firestore.collection('usernames').doc(loggedInUser.email);
      DocumentSnapshot doc = await docRef.get();
      final data = await doc.data() as Map<String, dynamic>;

      if (data["username"] != "") {
        setState(() {
          username = data[
              "username"]; //sets the username and uses setState to update all uses of it
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _auth.signOut();
              username = "";
              Navigator.pop(context);
            }),
        title: Text('Koi Chat'),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              right: 8,
            ),
            child: Text(username),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(), // display the actual messages from firebase
            Container(
              // for the textfield at the bottom
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //send text information to firebase
                      textController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': username,
                        "timestamp": Timestamp.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

//used to get all the messages from firebase
class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true) //order by most recent
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //show loader until we have data
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final messageText = message.data()['text']; //display the text message
          final messageSender = message.data()['sender']; //display the sender

          final singleMessageWidget = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: username ==
                  messageSender); //check if this user sent the message
          messageWidgets.add(singleMessageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.isMe});
  String text;
  String sender;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: isMe ? Colors.orange : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
