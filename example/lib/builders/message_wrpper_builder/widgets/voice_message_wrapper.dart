import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

import 'sender_data_widget.dart';

class VoiceMessageWrapper extends StatelessWidget {
  final bool isMessageBySender;
  final bool highlightMessage;
  final Color highlightColor;
  final UserMessage message;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final VoiceMessageConfiguration? voiceMessageConfiguration;
  final SenderDataWidgets senderDataWidgets;
  final Widget messageDataWidget;
  const VoiceMessageWrapper({
    required this.isMessageBySender,
    required this.highlightMessage,
    required this.highlightColor,
    required this.message,
    required this.inComingChatBubbleConfig,
    required this.outgoingChatBubbleConfig,
    required this.voiceMessageConfiguration,
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

  EdgeInsetsGeometry? get _padding => voiceMessageConfiguration?.padding ?? const EdgeInsets.symmetric(horizontal: 8);

  EdgeInsetsGeometry? get _margin =>
      voiceMessageConfiguration?.margin ??
      EdgeInsets.symmetric(
        horizontal: 8,
        vertical: message.reactions.isNotEmpty ? 15 : 0,
      );

  BoxDecoration? get _decoration =>
      voiceMessageConfiguration?.decoration ??
      BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isMessageBySender ? outgoingChatBubbleConfig?.color : inComingChatBubbleConfig?.color,
      );
}
