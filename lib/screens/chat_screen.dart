import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const screenName = 'chat_screen';

  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  void sendMessage() async {
    messageTextController.clear();

    try {
      _firestore.collection('messages').add(
        {
          'text': messageText,
          'sender': loggedInUser?.email,
          'created': Timestamp.now(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: sendMessage,
                    child: const Text(
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

class MessageStream extends StatelessWidget {
  MessageStream({super.key});

  final Stream<QuerySnapshot> _messagesStream =
      _firestore.collection('messages').orderBy('created').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No data found"));
        }

        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];

        String? currentUserMail = loggedInUser?.email;

        for (var message in messages) {
          var messageObj = message.data() as Map<String, dynamic>;
          String text = messageObj['text'];
          String sender = messageObj['sender'];

          messageBubbles.add(
            MessageBubble(
              text: text,
              sender: sender,
              isSameUser: currentUserMail == sender,
            ),
          );
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.text,
      required this.sender,
      required this.isSameUser});

  final String text;
  final String sender;
  final bool isSameUser;

  @override
  Widget build(BuildContext context) {
    BorderRadius messageRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    );

    if (isSameUser) {
      messageRadius = messageRadius.copyWith(
        topLeft: const Radius.circular(30),
      );
    } else {
      messageRadius = messageRadius.copyWith(
        topRight: const Radius.circular(30),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isSameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Material(
            borderRadius: messageRadius,
            color: isSameUser ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15,
                    color: isSameUser ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
