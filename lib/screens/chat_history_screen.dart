import 'package:animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key, required NotchBottomBarController controller});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chat History Screen',
            style: TextStyle(fontSize: 24,color: Colors.white),
          ),
        ],
      ),
    );
  }
}