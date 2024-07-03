import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_app/Model/organizationMessageDB.dart';

class ChatPage extends StatefulWidget {
  final int organizationId;
  final String organizationName;

  ChatPage({required this.organizationId, required this.organizationName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _dbHelper.getMessages(widget.organizationId);
    setState(() {
      _messages = messages;
    });
    /*await _dbHelper.insertMessage({
      'organizationId': 1,
      'sender': 'Hasan', // Replace with actual sender name
      'message': "Thesis Project is so much time consuming",
      'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    });*/
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final message = {
        'organizationId': widget.organizationId,
        'sender': 'Anonymous', // Replace with actual sender name
        'message': _controller.text,
        'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      };
      await _dbHelper.insertMessage(message);
      _controller.clear();
      _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat - ${widget.organizationName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final isSentByMe = message['sender'] ==
        'Anonymous'; // Replace with actual sender name check
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue[400] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message['sender'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSentByMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              message['message'],
              style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
            ),
            SizedBox(height: 4.0),
            Text(
              message['timestamp'],
              style: TextStyle(
                fontSize: 12.0,
                color: isSentByMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
