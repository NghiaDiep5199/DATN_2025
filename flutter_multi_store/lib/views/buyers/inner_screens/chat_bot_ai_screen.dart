import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_store/controllers/chatbot_controller.dart';
import 'package:flutter_multi_store/provider/chat_product_provider.dart';
import 'package:get/get.dart';

class ChatBoxScreen extends StatefulWidget {
  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  TextEditingController messageController = TextEditingController();
  ChatbotController chatBoxController = Get.put(ChatbotController());

  @override
  void initState() {
    super.initState();
    Get.put(ChatProductProvider()).fetchProductsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.blue.shade300),
        ),
        title: Text('ChatBot'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatBoxController.messageList.length,
                    itemBuilder:
                        (context, index) => BubbleSpecialThree(
                          isSender:
                              chatBoxController.messageList[index].isSender,

                          text: chatBoxController.messageList[index].message,
                          color:
                              chatBoxController.messageList[index].isSender
                                  ? Colors.blue.shade300
                                  : Colors.grey,
                          tail: true,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                  ),
                ),
                if (chatBoxController.isTyping.value)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Chat is typing...')],
                  ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter message...',
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          chatBoxController.sendMessage(
                            message: messageController.text,
                          );
                          messageController.clear();
                        },
                        icon: Icon(Icons.send, color: Colors.blue.shade300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
