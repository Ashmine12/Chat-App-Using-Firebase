import 'package:chat_application/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String senderUserId;
  final String receiverUserId;
  final String imgUrl;
  final String name;

  ChatScreen({
    required this.senderUserId,
    required this.receiverUserId,
    required this.imgUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 20,
          leadingWidth: 200,
          leading: Row(
            children: [
              Gap(),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(imgUrl),
              ),
              Gap(),
              Text(
                name,
                style: GoogleFonts.sourceCodePro(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        body: ChatScreenBody(
          senderUserId: senderUserId,
          receiverUserId: receiverUserId,
        ),
      ),
    );
  }
}

class ChatScreenBody extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String senderUserId;
  final String receiverUserId;

  ChatScreenBody({required this.senderUserId, required this.receiverUserId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Divider(color: Colors.white),
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('user')
                  .doc(senderUserId)
                  .collection('chat')
                  .doc(receiverUserId)
                  .collection('message')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  String text = message['text'];
                  bool isMe = message['senderUid'] == senderUserId;
                  Timestamp timestamp = message['timestamp'];
                  messageWidgets
                      .add(ChatMessage(text, isMe, senderUserId, timestamp));
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Divider(height: 1.0, color: Colors.white),
          ChatInput(senderUserId, receiverUserId),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final String currentUserUid;
  final Timestamp timestamp; // Add timestamp field

  ChatMessage(this.text, this.isMe, this.currentUserUid, this.timestamp);

  @override
  Widget build(BuildContext context) {
    Alignment alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    DateTime messageTime = timestamp.toDate();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      alignment: alignment,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text(
              DateFormat('hh:mm a')
                  .format(messageTime), // Format time as per your requirement
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 8.0 : 0),
                topRight: Radius.circular(isMe ? 0 : 8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  final String senderUserId;
  final String receiverUserId;

  ChatInput(this.senderUserId, this.receiverUserId);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _handleSend() {
    String messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      // Create a message document in the sender's sub-collection
      _firestore
          .collection('user')
          .doc(widget.senderUserId)
          .collection('chat')
          .doc(widget.receiverUserId)
          .collection('message')
          .add({
        'senderUid': widget.senderUserId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'receiverUid': widget.receiverUserId,
      });

      // Create a message document in the receiver's sub-collection
      _firestore
          .collection('user')
          .doc(widget.receiverUserId)
          .collection('chat')
          .doc(widget.senderUserId)
          .collection('message')
          .add({
        'senderUid': widget.senderUserId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'receiverUid': widget.receiverUserId,
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white), // Add white border
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white), // Set the border color to white
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent), // Disable focus border
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }
}
