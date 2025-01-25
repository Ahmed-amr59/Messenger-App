import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetask/Login_Screen.dart';
import 'package:flutter/material.dart';

late User signedUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? massagetext;
  var messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }
  void getCurrentuser() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        signedUser = user;
        print(signedUser.email);
      } else {
        print('No user signed in');
        Navigator.pop(context); // Redirect to login screen
      }
    } catch (e) {
      print(e);
    }
  }
  // Sign out method
  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login_screen()),
      );
    } catch (e) {
      print("Error signing out: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // void getmasseges() async {
  //   final massages =
  //       await FirebaseFirestore.instance.collection('massages').get();
  //   for (var massage in massages.docs) {
  //     print(massage.data());
  //   }
  // }

  // void massagesStream() async {
  //   await for (var snapshot
  //       in FirebaseFirestore.instance.collection("messages").snapshots()) {
  //     for (var messages in snapshot.docs) {
  //       print(messages.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          "Messenger Screen",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 10),
          //   child: CircleAvatar(
          //     radius: 20,
          //     backgroundImage: NetworkImage(
          //         "https://cdn4.iconfinder.com/data/icons/social-media-2285/1024/logo-512.png"),
          //   ),
          // ),

          IconButton(
            onPressed: () {
                return _signOut(context);

            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MessageStreamBuilder(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          label: Text(
                            "Type your message",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          border: InputBorder.none, // Optional: Add a border
                        ),
                        onChanged: (value) {
                          setState(() {
                            massagetext = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 8), // Add spacing between TextField and button
                IconButton(
                    onPressed: () async {
                      if (massagetext != null && massagetext!.isNotEmpty) {
                        try {
                          messageController.clear();
                          await FirebaseFirestore.instance
                              .collection('messages')
                              .add({
                            'massage': massagetext,
                            'id': signedUser.uid,
                            'Email': signedUser.email,
                            'time':FieldValue.serverTimestamp(),
                          });
                        } catch (e) {
                          print('Firestore error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              content: Text('Failed to send message: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a message'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.deepOrange),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Messageline extends StatelessWidget {
  Messageline({super.key, this.Email, this.message, required this.isMe});
  String? Email;
  String? message;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            '$Email',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color:isMe? Colors.deepOrangeAccent.withOpacity(.5):Colors.greenAccent.withOpacity(.5),
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal,
                    offset:isMe? Offset(-6, 5):Offset(6, 5))
              ],
              borderRadius: BorderRadius.circular(20),
              color: isMe?Colors.red:Colors.green,
            ),
            child: Text(
              "$message",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("messages").orderBy("time").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<Messageline> messageWidgets = [];
        for (var message in messages) {
          final messageText = message.get('massage');
          final messageEmail = message.get('Email');
          final currentUser = signedUser.email;
          final messageWidget = Messageline(
            message: messageText,
            Email: messageEmail,
            isMe: currentUser == messageEmail,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20,left: 20),
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          ),
        );
      },
    );
  }
}
