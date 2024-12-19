import 'package:chatview/chatview.dart';
import 'package:chatview/src/utils/package_strings.dart';
import 'package:flutter/material.dart';

class SendMessageController extends ChangeNotifier {
  /// Provides call back when user tap on send button on text field.
  final StringMessageCallBack onSendTap;

  /// Provides callback when user swipes chat bubble for reply.
  final ReplyMessageCallBack? onReplyCallback;

  /// Provides call when user tap on close button which is showed in reply pop-up.
  final VoidCallBack? onReplyCloseCallback;

  /// controller for the chat textField
  final textEditingController = TextEditingController();

  // Use to focue the chat textField
  final focusNode = FocusNode();

  /// The crrent message that been replyed as ValueListener
  final ValueNotifier<ReplyMessage> replyMessageListener =
      ValueNotifier(const ReplyMessage());

  final ValueNotifier<bool> messagesListSizeUpdated = ValueNotifier(false);

  /// The user that we replayed to
  ChatUser? repliedUser;

  /// The current user that uses the chat
  ChatUser? currentUser;

  SendMessageController({
    required this.onSendTap,
    required this.currentUser,
    required this.repliedUser,
    required this.onReplyCallback,
    required this.onReplyCloseCallback,
  });

  /// The crrent message that been replyed
  ReplyMessage get replyMessage => replyMessageListener.value;

  String get replyTo => replyMessage.replyTo == currentUser?.id
      ? PackageStrings.you
      : repliedUser?.name ?? '';

  void onRecordingComplete(String? path) {
    if (path != null) {
      onSendTap.call(path, replyMessage, MessageType.voice);
      assignRepliedMessage();
    }
  }

  void onImageSelected(String imagePath, String error) {
    debugPrint('Call in Send Message Widget');
    if (imagePath.isNotEmpty) {
      onSendTap.call(imagePath, replyMessage, MessageType.image);
      assignRepliedMessage();
    }
  }

  void assignRepliedMessage() {
    if (replyMessage.message.isNotEmpty) {
      replyMessageListener.value = const ReplyMessage();
    }
  }

  void onPressed() {
    final messageText = textEditingController.text.trim();
    textEditingController.clear();
    if (messageText.isEmpty) return;

    onSendTap.call(
      messageText.trim(),
      replyMessage,
      MessageType.text,
    );
    assignRepliedMessage();
  }

  void assignReplyMessage(Message message, BuildContext context) {
    if (currentUser != null) {
      replyMessageListener.value = ReplyMessage(
        message: message.message,
        replyBy: currentUser!.id,
        replyTo: message.sentBy,
        messageType: message.messageType,
        messageId: message.id,
        voiceMessageDuration: message.voiceMessageDuration,
      );
    }
    FocusScope.of(context).requestFocus(focusNode);
    if (onReplyCallback != null) onReplyCallback!(replyMessage);
  }

  void onCloseTap() {
    replyMessageListener.value = const ReplyMessage();
    if (onReplyCloseCallback != null) onReplyCloseCallback!();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    replyMessageListener.dispose();
    super.dispose();
  }

  void updateMessagesListSize() {
    messagesListSizeUpdated.notifyListeners();
  }
}
