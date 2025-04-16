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

  /// The current message that been replyed as ValueListener
  final ValueNotifier<ReplyMessage?> replyMessageListener = ValueNotifier(null);

  /// The current attachment files that been waiting to be sent as ValueListener
  final ValueNotifier<List<AttachmentFile>> waitingForSendAttachmentsListener =
      ValueNotifier([]);

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

  void removeImagesFromAttachment(List<ChatImage> images) {
    Set<String> pates = images.map((e) => e.file?.path ?? '').toSet();
    waitingForSendAttachmentsListener.value.removeWhere(
        (element) => pates.contains((element as ChatImage).file?.path));
    waitingForSendAttachmentsListener.notifyListeners();
  }

  void onImageSelected(List<ChatImage> images) {
    debugPrint('Call in add image to attachments');
    for (var img in images) {
      waitingForSendAttachmentsListener.value.add(img);
      // onSendTap.call(ImageMessage(image: img), replyMessage);
    }
    waitingForSendAttachmentsListener.notifyListeners();
    // resetReply();
  }

  void sendImages(List<ChatImage> images, {String? caption}) {
    debugPrint('Call in send images');
    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      onSendTap.call(
          ImageMessage(
              caption: i == images.length - 1 ? caption : null, image: image),
          replyMessage);
    }
    waitingForSendAttachmentsListener
      ..value = []
      ..notifyListeners();
    resetReply();
  }

  void resetReply() {
    replyMessageListener.value = null;
  }

  void onPressed() {
    final messageText = textEditingController.text.trim();
    textEditingController.clear();
    final textToSend = messageText.trim();
    // Regular flow just send the message
    if (waitingForSendAttachmentsListener.value.isEmpty) {
      if (textToSend.isEmpty) return;

      onSendTap.call(TextMessage(text: textToSend), replyMessage);
      resetReply();
    }
    // Attach the message to the last image
    else {
      final List<ChatImage> images = [];
      waitingForSendAttachmentsListener.value.forEach((file) {
        if (file is ChatImage) {
          images.add(file);
        }
      });
      sendImages(
        images,
        caption: textToSend,
      );
    }
  }

  void assignReplyMessage(UserMessage message, BuildContext context) {
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
