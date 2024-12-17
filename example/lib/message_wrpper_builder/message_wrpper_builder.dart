import 'package:chatview/chatview.dart';
import 'package:example/message_wrpper_builder/widgets/image_message_wrapper.dart';
import 'package:example/message_wrpper_builder/widgets/text_message_wrapper.dart';
import 'package:example/message_wrpper_builder/widgets/voice_message_wrapper.dart';
import 'package:flutter/material.dart';

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
