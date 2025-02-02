import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class ImageMessageWrapper extends StatelessWidget {
  final bool isMessageBySender;
  final bool highlightMessage;
  final Color highlightColor;
  final UserMessage message;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final Widget messageDataWidget;
  const ImageMessageWrapper({
    super.key,
    required this.isMessageBySender,
    required this.highlightMessage,
    required this.highlightColor,
    required this.message,
    required this.inComingChatBubbleConfig,
    required this.outgoingChatBubbleConfig,
    required this.messageDataWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: messageDataWidget,
    );
  }
}
