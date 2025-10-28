import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> messages = []; // {'role': 'user'/'bot', 'text': '...'}
  bool isLoading = false;

  Future<void> sendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'text': question});
      isLoading = true;
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.169:5000/query/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'question': question}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botReply = data['result'] ?? "No reply";

        setState(() {
          messages.add({'role': 'bot', 'text': botReply});
        });
      } else {
        setState(() {
          messages.add({'role': 'bot', 'text': 'Error: ${response.statusCode}'});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'role': 'bot', 'text': 'Error: $e'});
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 500.h, // adjust as needed
          padding: EdgeInsets.all(12.sp),
          child: Column(
            children: [
              Text(
                "Chat with Bot",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isUser = msg['role'] == 'user';

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.sp),
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Text(msg['text'] ?? ''),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading) ...[
                SizedBox(height: 10.h),
                CircularProgressIndicator(),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: "Type a message..."),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
