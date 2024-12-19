import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

import 'widgets/image_message_wrapper.dart';
import 'widgets/text_message_wrapper.dart';
import 'widgets/voice_message_wrapper.dart';

Widget messageWrapperBuilder(
  bool isMessageBySender,
  bool highlightMessage,
  Color highlightColor,
  Message message,
  ChatBubble? inComingChatBubbleConfig,
  ChatBubble? outgoingChatBubbleConfig,
  VoiceMessageConfiguration? voiceMessageConfiguration,
  SenderDataWidgets senderDataWidgets,
  Widget messageDataWidget,
) {
  switch (message.messageType) {
    case MessageType.text:
      return TextMessageWrapper(
        isMessageBySender: isMessageBySender,
        highlightMessage: highlightMessage,
        highlightColor: highlightColor,
        message: message,
        inComingChatBubbleConfig: inComingChatBubbleConfig,
        outgoingChatBubbleConfig: outgoingChatBubbleConfig,
        senderDataWidgets: senderDataWidgets,
        messageDataWidget: messageDataWidget,
      );
    case MessageType.voice:
      return VoiceMessageWrapper(
        isMessageBySender: isMessageBySender,
        highlightMessage: highlightMessage,
        highlightColor: highlightColor,
        message: message,
        inComingChatBubbleConfig: inComingChatBubbleConfig,
        outgoingChatBubbleConfig: outgoingChatBubbleConfig,
        voiceMessageConfiguration: voiceMessageConfiguration,
        senderDataWidgets: senderDataWidgets,
        messageDataWidget: messageDataWidget,
      );
    case MessageType.image:
      return ImageMessageWrapper(
          isMessageBySender: isMessageBySender,
          highlightMessage: highlightMessage,
          highlightColor: highlightColor,
          message: message,
          inComingChatBubbleConfig: inComingChatBubbleConfig,
          outgoingChatBubbleConfig: outgoingChatBubbleConfig,
          messageDataWidget: messageDataWidget);
    default:
      return const SizedBox();
  }
}