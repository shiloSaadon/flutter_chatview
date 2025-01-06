import 'package:chatview/chatview.dart';
import 'package:chatview/src/utils/package_strings.dart';
import 'package:flutter/material.dart';

class SendMessageController extends ChangeNotifier {
  /// Provides call back when user tap on send button
  final MessageContentCallBack onSendTap;

  /// Provides callback when user swipes chat bubble for reply.
  final ReplyMessageCallBack? onReplyCallback;

  /// Provides call when user tap on close button which is showed in reply pop-up.
  final VoidCallBack? onReplyCloseCallback;

  /// controller for the chat textField
  final textEditingController = TextEditingController();

  // Use to focue the chat textField
  final focusNode = FocusNode();

  /// The crrent message that been replyed as ValueListener
  final ValueNotifier<ReplyMessage?> replyMessageListener = ValueNotifier(null);

  final ValueNotifier<bool> messagesListSizeUpdated = ValueNotifier(false);

  /// The user that we replayed to
  ChatUser? Function(ReplyMessage<MessageContent>? message) repliedUser;

  /// The current user that uses the chat
  ChatUser? currentUser;

  SendMessageController({
    required this.onSendTap,
    required this.currentUser,
    required this.repliedUser,
    required this.onReplyCallback,
    required this.onReplyCloseCallback,
  });

  /// The current message that been replyed
  ReplyMessage? get replyMessage => replyMessageListener.value;

  String get replyTo => replyMessage?.sentBy == currentUser?.id
      ? PackageStrings.you
      : repliedUser(replyMessage)?.name ?? '';

  void onRecordingComplete(VoiceMessage voiceMsg) {
    onSendTap.call(voiceMsg, replyMessage);
    resetReply();
  }

  void onImageSelected(List<ChatImage> images) {
    debugPrint('Call in Send Message Widget');
    onSendTap.call(ImagesMessage(images: images), replyMessage);
    resetReply();
  }

  void resetReply() {
    replyMessageListener.value = null;
  }

  void onPressed() {
    final messageText = textEditingController.text.trim();
    textEditingController.clear();
    if (messageText.isEmpty) return;

    onSendTap.call(TextMessage(text: messageText.trim()), replyMessage);
    resetReply();
  }

  void assignReplyMessage(Message message, BuildContext context) {
    if (currentUser != null) {
      replyMessageListener.value = message.asReply;
    }
    FocusScope.of(context).requestFocus(focusNode);
    if (onReplyCallback != null) onReplyCallback!(replyMessage);
  }

  void onCloseTap() {
    replyMessageListener.value = null;
    onReplyCloseCallback?.call();
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
