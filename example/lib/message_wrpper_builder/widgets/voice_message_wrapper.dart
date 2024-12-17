import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class VoiceMessageWrapper extends StatelessWidget {
  final bool isMessageBySender;
  final bool highlightMessage;
  final Color highlightColor;
  final Message message;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final VoiceMessageConfiguration? voiceMessageConfiguration;
  final SenderDataWidgets senderDataWidgets;
  final Widget messageDataWidget;
  const VoiceMessageWrapper({
    super.key,
    required this.isMessageBySender,
    required this.highlightMessage,
    required this.highlightColor,
    required this.message,
    required this.inComingChatBubbleConfig,
    required this.outgoingChatBubbleConfig,
    required this.voiceMessageConfiguration,
    required this.senderDataWidgets,
    required this.messageDataWidget,
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
            Container(
              color: Colors.blue,
              // height: 20,
              width: 30,
            ),
          messageDataWidget,
        ],
      ),
    );
  }

  EdgeInsetsGeometry? get _padding =>
      voiceMessageConfiguration?.padding ??
      const EdgeInsets.symmetric(horizontal: 8);

  EdgeInsetsGeometry? get _margin =>
      voiceMessageConfiguration?.margin ??
      EdgeInsets.symmetric(
        horizontal: 8,
        vertical: message.reaction.reactions.isNotEmpty ? 15 : 0,
      );

  BoxDecoration? get _decoration =>
      voiceMessageConfiguration?.decoration ??
      BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isMessageBySender
            ? outgoingChatBubbleConfig?.color
            : inComingChatBubbleConfig?.color,
      );
}
