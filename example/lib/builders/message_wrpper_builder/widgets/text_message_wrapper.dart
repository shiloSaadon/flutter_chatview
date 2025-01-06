import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

import 'sender_data_widget.dart';

class TextMessageWrapper extends StatelessWidget {
  final bool isMessageBySender;
  final bool highlightMessage;
  final Color highlightColor;
  final Message message;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final SenderDataWidgets senderDataWidgets;
  final Widget messageDataWidget;
  const TextMessageWrapper({
    required this.isMessageBySender,
    required this.highlightMessage,
    required this.highlightColor,
    required this.message,
    required this.inComingChatBubbleConfig,
    required this.outgoingChatBubbleConfig,
    required this.senderDataWidgets,
    required this.messageDataWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      margin: _margin,
      decoration: _decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMessageBySender)
            SenderDataWidget(
              senderDataWidgets: senderDataWidgets,
            ),
          messageDataWidget,
        ],
      ),
    );
  }

  EdgeInsetsGeometry? get _padding =>
      (isMessageBySender
          ? outgoingChatBubbleConfig?.padding
          : inComingChatBubbleConfig?.padding) ??
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      );

  EdgeInsetsGeometry? get _margin =>
      (isMessageBySender
          ? outgoingChatBubbleConfig?.margin
          : inComingChatBubbleConfig?.margin) ??
      EdgeInsets.fromLTRB(5, 0, 6, message.reactions.isNotEmpty ? 15 : 2);

  BoxDecoration? get _decoration => BoxDecoration(
        color: highlightMessage ? highlightColor : _color,
        borderRadius: _borderRadius(content.text),
      );

  TextMessage get content => message.content as TextMessage;
  BorderRadiusGeometry _borderRadius(String message) => isMessageBySender
      ? outgoingChatBubbleConfig?.borderRadius ??
          (message.length < 37
              ? BorderRadius.circular(18)
              : BorderRadius.circular(18))
      : inComingChatBubbleConfig?.borderRadius ??
          (message.length < 29
              ? BorderRadius.circular(18)
              : BorderRadius.circular(18));

  Color get _color => isMessageBySender
      ? outgoingChatBubbleConfig?.color ?? Colors.purple
      : inComingChatBubbleConfig?.color ?? Colors.grey.shade500;
}
