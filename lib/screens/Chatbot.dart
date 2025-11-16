import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'Messages.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<Chatbot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Retinal Assistant',
            style: TextStyle(
              // fontFamily: Salsa,
              fontSize: 24, // Adjust font size as needed
              fontWeight: FontWeight.bold, // Make text bold
              color: Colors.black87, // Set text color
            ),
          ),
          centerTitle: true, // Center the title horizontally
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: MessagesScreen(messages: messages)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                //color: Colors.grey.shade900,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter message', // Placeholder text
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder( // Rounded edges
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none, // Remove the border line
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Padding on all sides
                          filled: true,
                          fillColor: Colors.grey.shade800, // Background color
                          suffixIcon: IconButton(
                            onPressed: () {
                              sendMessage(_controller.text);
                              _controller.clear();
                            },
                            icon: Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
