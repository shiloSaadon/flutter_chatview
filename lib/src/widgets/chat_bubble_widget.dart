/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:chatview/src/widgets/reply_message_widget.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';
import 'message_time_widget.dart';
import 'message_view.dart';
import 'profile_circle.dart';
import 'swipe_to_reply.dart';

class ChatBubbleWidget<Content extends MessageContent> extends StatefulWidget {
  const ChatBubbleWidget({
    required GlobalKey key,
    required this.message,
    required this.onLongPress,
    required this.slideAnimation,
    required this.onSwipe,
    this.onReplyTap,
    this.shouldHighlight = false,
  }) : super(key: key);

  /// Represent current instance of message.
  final UserMessage<Content> message;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Provides callback of when user swipe chat bubble for reply.
  final AssignReplayCallBack<Content> onSwipe;

  /// Provides slide animation when user swipe whole chat.
  final Animation<Offset>? slideAnimation;

  /// Provides callback when user tap on replied message upon chat bubble.
  final Function(String)? onReplyTap;

  /// Flag for when user tap on replied message and highlight actual message.
  final bool shouldHighlight;

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState<Content extends MessageContent> extends State<ChatBubbleWidget>
    with AutomaticKeepAliveClientMixin {
  ReplyMessage? get replyMessage => widget.message.replyOfMsg;

  bool get isMessageBySender => widget.message.sentBy == currentUser?.id;

  bool get isLastMessage => chatController?.initialMessageList.last.id == widget.message.id;

  FeatureActiveConfig? featureActiveConfig;
  ChatController? chatController;
  ChatUser? currentUser;
  int? maxDuration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chatViewIW != null) {
      featureActiveConfig = chatViewIW!.featureActiveConfig;
      chatController = chatViewIW!.chatController;
      currentUser = chatController?.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //! Handle Banners
    // Get user from id.
    final messagedUser = chatController?.getUserFromId(widget.message.sentBy);
    return Stack(
      children: [
        if (featureActiveConfig?.enableSwipeToSeeTime ?? true) ...[
          Visibility(
            visible: widget.slideAnimation?.value.dx == 0.0 ? false : true,
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: MessageTimeWidget(
                  messageTime: widget.message.sentAt,
                  isCurrentUser: isMessageBySender,
                ),
              ),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation!,
            child: _chatBubbleWidget(messagedUser),
          ),
        ] else
          _chatBubbleWidget(messagedUser),
      ],
    );
  }

  Widget _chatBubbleWidget(ChatUser? messagedUser) {
    final chatBubbleConfig = chatListConfig.chatBubbleConfig;
    return Container(
      padding: chatBubbleConfig?.padding ?? const EdgeInsets.symmetric(horizontal: 5.0),
      margin: chatBubbleConfig?.margin ?? const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMessageBySender && (featureActiveConfig?.enableOtherUserProfileAvatar ?? true))
            profileCircle(messagedUser),
          Expanded(
            child: _messagesWidgetColumn(messagedUser),
          ),
          if (isMessageBySender) ...[getReceipt()],
          if (isMessageBySender && (featureActiveConfig?.enableCurrentUserProfileAvatar ?? true))
            profileCircle(messagedUser),
        ],
      ),
    );
  }

  ProfileCircle profileCircle(ChatUser? messagedUser) {
    final profileCircleConfig = chatListConfig.profileCircleConfig;
    return ProfileCircle(
      bottomPadding: widget.message.reactions.isNotEmpty
          ? profileCircleConfig?.bottomPadding ?? 15
          : profileCircleConfig?.bottomPadding ?? 2,
      profileCirclePadding: profileCircleConfig?.padding,
      user: messagedUser,
      circleRadius: profileCircleConfig?.circleRadius,
      onTap: () => _onAvatarTap(messagedUser),
      onLongPress: () => _onAvatarLongPress(messagedUser),
    );
  }

  void onRightSwipe() {
    var content = widget.message.content;
    if (maxDuration != null && content is VoiceMessage) {
      content = content.copyWith(duration: Duration(milliseconds: maxDuration!));
    }
    if (chatListConfig.swipeToReplyConfig?.onRightSwipe != null) {
      chatListConfig.swipeToReplyConfig?.onRightSwipe!(widget.message.copyWith(content: content));
    }
    widget.onSwipe(widget.message, context);
  }

  void onLeftSwipe() {
    var content = widget.message.content;
    if (maxDuration != null && content is VoiceMessage) {
      content = content.copyWith(duration: Duration(milliseconds: maxDuration!));
    }

    if (chatListConfig.swipeToReplyConfig?.onLeftSwipe != null) {
      chatListConfig.swipeToReplyConfig?.onLeftSwipe!(widget.message.copyWith(content: content));
    }
    widget.onSwipe(widget.message, context);
  }

  void _onAvatarTap(ChatUser? user) {
    if (chatListConfig.profileCircleConfig?.onAvatarTap != null && user != null) {
      chatListConfig.profileCircleConfig?.onAvatarTap!(user);
    }
  }

  Widget getReceipt() {
    return const SizedBox();
    // final showReceipts = chatListConfig.chatBubbleConfig
    //         ?.outgoingChatBubbleConfig?.receiptsWidgetConfig?.showReceiptsIn ??
    //     ShowReceiptsIn.lastMessage;
    // if (showReceipts == ShowReceiptsIn.all) {
    //   return ValueListenableBuilder(
    //     valueListenable: widget.message.statusNotifier,
    //     builder: (context, value, child) {
    //       if (ChatViewInheritedWidget.of(context)
    //               ?.featureActiveConfig
    //               .receiptsBuilderVisibility ??
    //           true) {
    //         return chatListConfig.chatBubbleConfig?.outgoingChatBubbleConfig
    //                 ?.receiptsWidgetConfig?.receiptsBuilder
    //                 ?.call(value) ??
    //             sendMessageAnimationBuilder(value);
    //       }
    //       return const SizedBox();
    //     },
    //   );
    // } else if (showReceipts == ShowReceiptsIn.lastMessage && isLastMessage) {
    //   return ValueListenableBuilder(
    //       valueListenable:
    //           chatController!.initialMessageList.last.statusNotifier,
    //       builder: (context, value, child) {
    //         if (ChatViewInheritedWidget.of(context)
    //                 ?.featureActiveConfig
    //                 .receiptsBuilderVisibility ??
    //             true) {
    //           return chatListConfig.chatBubbleConfig?.outgoingChatBubbleConfig
    //                   ?.receiptsWidgetConfig?.receiptsBuilder
    //                   ?.call(value) ??
    //               sendMessageAnimationBuilder(value);
    //         }
    //         return sendMessageAnimationBuilder(value);
    //       });
    // }
    // return const SizedBox();
  }

  void _onAvatarLongPress(ChatUser? user) {
    if (chatListConfig.profileCircleConfig?.onAvatarLongPress != null && user != null) {
      chatListConfig.profileCircleConfig?.onAvatarLongPress!(user);
    }
  }

  Widget senderName(ChatUser? messagedUser, EdgeInsetsGeometry Function() padding) {
    if ((chatController?.otherUsers.isNotEmpty ?? false) && !isMessageBySender) {
      return Padding(
        padding: padding(),
        child: Text(
          messagedUser?.name ?? '',
          style: chatListConfig.chatBubbleConfig?.inComingChatBubbleConfig?.senderNameTextStyle,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _messagesWidgetColumn(ChatUser? messagedUser) {
    return Column(
      crossAxisAlignment: isMessageBySender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (featureActiveConfig?.enableOtherUserName ?? true)
          senderName(messagedUser, () {
            return chatListConfig.chatBubbleConfig?.inComingChatBubbleConfig?.padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
          }),
        if (replyMessage != null && chatListConfig.repliedMessageConfig?.displyeReply != false)
          chatListConfig.repliedMessageConfig?.repliedMessageWidgetBuilder != null
              ? chatListConfig.repliedMessageConfig!.repliedMessageWidgetBuilder!(replyMessage)
              : ReplyMessageWidget(
                  message: replyMessage!,
                  repliedMessageConfig: chatListConfig.repliedMessageConfig,
                  networkImageHeaders: chatListConfig.messageConfig.imageMessageConfig.networkImageHeaders,
                  onTap: () => widget.onReplyTap?.call(replyMessage!.id),
                ),
        SwipeToReply(
          isMessageByCurrentUser: isMessageBySender,
          onSwipe: isMessageBySender ? onLeftSwipe : onRightSwipe,
          child: MessageView(
            onReplyTap: widget.onReplyTap,
            outgoingChatBubbleConfig: chatListConfig.chatBubbleConfig?.outgoingChatBubbleConfig,
            isLongPressEnable: (featureActiveConfig?.enableReactionPopup ?? true) ||
                (featureActiveConfig?.enableReplySnackBar ?? true),
            inComingChatBubbleConfig: chatListConfig.chatBubbleConfig?.inComingChatBubbleConfig,
            message: widget.message,
            isMessageBySender: isMessageBySender,
            messageConfig: chatListConfig.messageConfig,
            onLongPress: widget.onLongPress,
            chatBubbleMaxWidth: chatListConfig.chatBubbleConfig?.maxWidth,
            longPressAnimationDuration: chatListConfig.chatBubbleConfig?.longPressAnimationDuration,
            onDoubleTap: featureActiveConfig?.enableDoubleTapToLike ?? false
                ? chatListConfig.chatBubbleConfig?.onDoubleTap ??
                    (message) => currentUser != null
                        ? chatController?.setReaction(
                            emoji: heart,
                            messageId: message.id,
                            idUser: currentUser!.id,
                          )
                        : null
                : null,
            shouldHighlight: widget.shouldHighlight,
            controller: chatController!,
            highlightColor:
                chatListConfig.repliedMessageConfig?.repliedMsgAutoScrollConfig.highlightColor ?? Colors.grey,
            highlightScale: chatListConfig.repliedMessageConfig?.repliedMsgAutoScrollConfig.highlightScale ?? 1.1,
            onMaxDuration: _onMaxDuration,
            senderDataWidgets: (
              profileCircle(messagedUser),
              senderName(messagedUser, () => EdgeInsets.zero),
            ),
          ),
        ),
      ],
    );
  }

  void _onMaxDuration(int duration) => maxDuration = duration;

  /// Keep an image message's state alive
  @override
  bool get wantKeepAlive => widget.message.content is ImageMessage;
}
