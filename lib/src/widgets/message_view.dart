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
import 'package:chatview/chatview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/widgets/voice_message_view.dart';
import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';
import 'image_message_view.dart';
import 'reaction_widget.dart';
import 'text_message_view.dart';

class MessageView<Content extends MessageContent> extends StatefulWidget {
  const MessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    required this.onLongPress,
    required this.isLongPressEnable,
    required this.senderDataWidgets,
    required this.onReplyTap,
    this.chatBubbleMaxWidth,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.longPressAnimationDuration,
    this.onDoubleTap,
    this.highlightColor = Colors.grey,
    this.shouldHighlight = false,
    this.highlightScale = 1.2,
    required this.messageConfig,
    this.onMaxDuration,
    required this.controller,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message<Content> message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Allow users to give max width of chat bubble.
  final double? chatBubbleMaxWidth;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Allow users to give duration of animation when user long press on chat bubble.
  final Duration? longPressAnimationDuration;

  /// Allow user to set some action when user double tap on chat bubble.
  final MessageCallBack? onDoubleTap;

  /// Allow users to pass colour of chat bubble when user taps on replied message.
  final Color highlightColor;

  /// Allow users to turn on/off highlighting chat bubble when user tap on replied message.
  final bool shouldHighlight;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration messageConfig;

  /// Allow user to turn on/off long press tap on chat bubble.
  final bool isLongPressEnable;

  /// Data about the sender to allow differen modes for the ui
  final SenderDataWidgets senderDataWidgets;

  final ChatController controller;

  final Function(int)? onMaxDuration;

  /// Provides callback when user tap on replied message upon chat bubble.
  final Function(String)? onReplyTap;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  MessageConfiguration get messageConfig => widget.messageConfig;

  bool get isLongPressEnable => widget.isLongPressEnable;

  @override
  void initState() {
    super.initState();
    if (isLongPressEnable) {
      _animationController = AnimationController(
        vsync: this,
        duration: widget.longPressAnimationDuration ?? const Duration(milliseconds: 250),
        upperBound: 0.1,
        lowerBound: 0.0,
      );
      if (!widget.message.isMsgRead(widget.controller.otherUsers) && !widget.isMessageBySender) {
        widget.inComingChatBubbleConfig?.onMessageRead?.call(widget.message);
      }
      _animationController?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController?.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: isLongPressEnable ? _onLongPressStart : null,
      onDoubleTap: () {
        if (widget.onDoubleTap != null) widget.onDoubleTap!(widget.message);
      },
      child: (() {
        if (isLongPressEnable) {
          return AnimatedBuilder(
            builder: (_, __) {
              return Transform.scale(
                scale: 1 - _animationController!.value,
                child: _messageView,
              );
            },
            animation: _animationController!,
          );
        } else {
          return _messageView;
        }
      }()),
    );
  }

  Widget get _messageView {
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.message.reactions.isNotEmpty ? 6 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          messageWithReaction,
          lastSeenIndicator,
        ],
      ),
    );
  }

  Widget get messageWithReaction => Stack(
        children: [
          singleMessageBubble,
          if (widget.message.reactions.isNotEmpty)
            ReactionWidget(
              // key: key,
              isMessageBySender: widget.isMessageBySender,
              reactions: widget.message.reactions,
              messageReactionConfig: messageConfig.messageReactionConfig,
            ),
        ],
      );

  Widget get singleMessageBubble {
    final emojiMessageConfiguration = messageConfig.emojiMessageConfig;
    final useInternalMessageWrapper = messageConfig.customMessageWrapperBuilder == null;

    final Widget messageData = switch (widget.message) {
      Message(content: TextMessage content, reactions: final reactions) => content.text.isAllEmoji
          ? Padding(
              padding: emojiMessageConfiguration?.padding ??
                  EdgeInsets.fromLTRB(
                    leftPadding2,
                    4,
                    leftPadding2,
                    widget.message.reactions.isNotEmpty ? 14 : 0,
                  ),
              child: Transform.scale(
                scale: widget.shouldHighlight ? widget.highlightScale : 1.0,
                child: Text(
                  content.text,
                  style: emojiMessageConfiguration?.textStyle ?? const TextStyle(fontSize: 30),
                ),
              ),
            )
          : TextMessageView(
              inComingChatBubbleConfig: widget.inComingChatBubbleConfig,
              outgoingChatBubbleConfig: widget.outgoingChatBubbleConfig,
              isMessageBySender: widget.isMessageBySender,
              messageContent: content,
              reactions: reactions,
              chatBubbleMaxWidth: widget.chatBubbleMaxWidth,
              messageReactionConfig: messageConfig.messageReactionConfig,
              highlightColor: widget.highlightColor,
              highlightMessage: widget.shouldHighlight,
              useIndernalMessageWrpper: useInternalMessageWrapper,
            ),
      Message(content: ImageMessage content, id: final idMsg, reactions: final reactions) => ImageMessageView(
          idMsg: idMsg,
          messageContent: content,
          reactions: reactions,
          isMessageBySender: widget.isMessageBySender,
          imageMessageConfig: messageConfig.imageMessageConfig,
          messageReactionConfig: messageConfig.messageReactionConfig,
          highlightImage: widget.shouldHighlight,
          highlightScale: widget.highlightScale,
        ),
      Message(content: VoiceMessage content, reactions: final reactions) => VoiceMessageView(
          screenWidth: MediaQuery.of(context).size.width,
          messageContent: content,
          reactions: reactions,
          config: messageConfig.voiceMessageConfig,
          onMaxDuration: widget.onMaxDuration,
          isMessageBySender: widget.isMessageBySender,
          messageReactionConfig: messageConfig.messageReactionConfig,
          inComingChatBubbleConfig: widget.inComingChatBubbleConfig,
          outgoingChatBubbleConfig: widget.outgoingChatBubbleConfig,
          useInternalMessageWrapper: useInternalMessageWrapper,
        ),
      _ => Text(
          'Message data could not be parsed for some reason',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
        ),
    };

    //  Custom message wrapper
    if (messageConfig.customMessageWrapperBuilder != null) {
      return messageConfig.customMessageWrapperBuilder!(
          widget.isMessageBySender,
          widget.shouldHighlight,
          widget.highlightColor,
          widget.message,
          widget.inComingChatBubbleConfig,
          widget.outgoingChatBubbleConfig,
          messageConfig.voiceMessageConfig,
          widget.senderDataWidgets,
          messageData,
          widget.onReplyTap);
    }

    /// ----------------- TO REMOVE ----------------
    //! Temporarily removed
    // if (!widget.message.messageType.isText) {
    //   return const SizedBox();
    // }
    // return TextMessageView(
    //   inComingChatBubbleConfig: widget.inComingChatBubbleConfig,
    //   outgoingChatBubbleConfig: widget.outgoingChatBubbleConfig,
    //   isMessageBySender: widget.isMessageBySender,
    //   message: widget.message,
    //   chatBubbleMaxWidth: widget.chatBubbleMaxWidth,
    //   messageReactionConfig: messageConfig?.messageReactionConfig,
    //   highlightColor: widget.highlightColor,
    //   highlightMessage: widget.shouldHighlight,
    //   useIndernalMessageWrpper: useInternalMessageWrapper,
    // );

    /// -----------------  ----------------

    return messageData;
  }

  Widget get lastSeenIndicator {
    if (widget.isMessageBySender &&
        widget.controller.initialMessageList.isNotEmpty &&
        widget.controller.initialMessageList.last.id == widget.message.id &&
        widget.message.isMsgRead(widget.controller.otherUsers)) {
      if (ChatViewInheritedWidget.of(context)?.featureActiveConfig.lastSeenAgoBuilderVisibility ?? true) {
        return widget.outgoingChatBubbleConfig?.receiptsWidgetConfig?.lastSeenAgoBuilder
                ?.call(widget.message, applicationDateFormatter(widget.message.sentAt)) ??
            lastSeenAgoBuilder(widget.message, applicationDateFormatter(widget.message.sentAt));
      }
      return const SizedBox();
    }
    return const SizedBox();
  }

  void _onLongPressStart(LongPressStartDetails details) async {
    await _animationController?.forward();
    widget.onLongPress(
      details.globalPosition.dy,
      details.globalPosition.dx,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
