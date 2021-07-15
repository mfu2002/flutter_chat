import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data!.documents;

                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) => MessageBubble(
                    message: chatDocs[index]['text'],
                    userImage: chatDocs[index]['userImage'],
                    isMe: chatDocs[index]['userId'] == snapshot.data!.uid,
                    key: ValueKey(chatDocs[index].documentID),
                    username: chatDocs[index]['username'],
                  ),
                  itemCount: chatDocs.length,
                );
              });
        });
  }
}
