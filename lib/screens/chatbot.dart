import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).canvasColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Map<String, String> predefinedAnswers = {
    'How does the car rental process work?':
        'To rent a car, you can visit our website or app, select the car you want, choose the rental dates, and proceed with the booking.',
    'What types of cars do you offer?':
        'We offer a variety of cars, including sedans, SUVs, and luxury cars. You can check our website or app for the available options.',
    'How much does it cost to rent a car?':
        'The cost of renting a car depends on the type of car, rental duration, and any additional services you choose. Please check our website or app for detailed pricing.',
    'Do you provide insurance for rented cars?':
        'Yes, we offer insurance options for rented cars. You can choose the insurance coverage that suits your needs during the booking process.',
    'What are your operating hours?':
        'Our customer support is available 24/7. You can contact us at any time for assistance.',
    'Can I modify or cancel my reservation?':
        'Yes, you can modify or cancel your reservation. Please log in to your account on our website or app to make changes.',
  };
  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );

    setState(() {
      _messages.insert(0, message);
    });
    String response = getResponse(text);
    // Simulate chatbot response (you can replace this with your chatbot logic)
    _simulateChatbotResponse(response);
  }

  String getResponse(String userMessage) {
    for (String question in predefinedAnswers.keys) {
      if (userMessage.toLowerCase().contains(question.toLowerCase())) {
        return predefinedAnswers[question]!;
      }
    }
    return "I'm sorry, I don't understand that question. Please ask something else.";
  }

  void _simulateChatbotResponse(String userMessage) {
    // Simulate chatbot response after a short delay
    Future.delayed(Duration(seconds: 1), () {
      ChatMessage message = ChatMessage(
        text: 'Chatbot response to: $userMessage',
        isUser: false,
      );
      setState(() {
        _messages.insert(0, message);
      });
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isUser
              ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    child: Text('User'),
                  ),
                )
              : Container(), // Empty container for non-user messages
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isUser ? 'User' : 'Chatbot',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
