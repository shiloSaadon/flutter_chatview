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
import 'package:flutter/material.dart';

import 'chat_bubble_widget.dart';
import 'chat_group_header.dart';

class ChatGroupedListWidget extends StatefulWidget {
  const ChatGroupedListWidget({
    Key? key,
    required this.showPopUp,
    required this.scrollController,
    required this.replyMessage,
    required this.assignReplyMessage,
    required this.onChatListTap,
    required this.onChatBubbleLongPress,
    required this.isEnableSwipeToSeeTime,
  }) : super(key: key);

  /// Allow user to swipe to see time while reaction pop is not open.
  final bool showPopUp;

  /// Pass scroll controller
  final ScrollController scrollController;

  /// Provides reply message if actual message is sent by replying any message.
  final ReplyMessage? replyMessage;

  /// Provides callback for assigning reply message when user swipe on chat bubble.
  final AssignReplayCallBack assignReplyMessage;

  /// Provides callback when user tap anywhere on whole chat.
  final VoidCallBack onChatListTap;

  /// Provides callback when user press chat bubble for certain time then usual.
  final void Function(double, double, UserMessage) onChatBubbleLongPress;

  /// Provide flag for turn on/off to see message crated time view when user
  /// swipe whole chat.
  final bool isEnableSwipeToSeeTime;

  @override
  State<ChatGroupedListWidget> createState() => _ChatGroupedListWidgetState();
}

class _ChatGroupedListWidgetState extends State<ChatGroupedListWidget>
    with TickerProviderStateMixin {
  bool get showPopUp => widget.showPopUp;

  bool highlightMessage = false;
  final ValueNotifier<String?> _replyId = ValueNotifier(null);

  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  FeatureActiveConfig? featureActiveConfig;

  ChatController? chatController;

  bool get isEnableSwipeToSeeTime => widget.isEnableSwipeToSeeTime;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      chatListConfig.chatBackgroundConfig;

  double chatTextFieldHeight = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    updateChatTextFieldHeight();
  }

  @override
  void didUpdateWidget(covariant ChatGroupedListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateChatTextFieldHeight();
  }

  void updateChatTextFieldHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        chatTextFieldHeight =
            chatViewIW?.chatTextFieldViewKey.currentContext?.size?.height ?? 10;
      });
    });
  }

  void _initializeAnimation() {
    // When this flag is on at that time only animation controllers will be
    // initialized.
    if (isEnableSwipeToSeeTime) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );
      _slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          curve: Curves.decelerate,
          parent: _animationController!,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chatViewIW != null) {
      featureActiveConfig = chatViewIW!.featureActiveConfig;
      chatController = chatViewIW!.chatController;
    }
    _initializeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    // final suggestionsListConfig = suggestionsConfig?.listConfig ?? const SuggestionListConfig();
    return GestureDetector(
      onHorizontalDragUpdate: (details) => isEnableSwipeToSeeTime && !showPopUp
          ? _onHorizontalDrag(details)
          : null,
      onHorizontalDragEnd: (details) => isEnableSwipeToSeeTime && !showPopUp
          ? _animationController?.reverse()
          : null,
      onTap: widget.onChatListTap,
      child: _animationController != null
          ? AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return _chatStreamBuilder;
              },
            )
          : _chatStreamBuilder,
    );
  }

  Future<void> _onReplyTap(String id, Set<MessageBase>? messages) async {
    // Finds the replied message if exists
    final repliedMessages = messages?.firstWhere((message) => id == message.id);
    final repliedMsgAutoScrollConfig =
        chatListConfig.repliedMessageConfig?.repliedMsgAutoScrollConfig;
    final highlightDuration = repliedMsgAutoScrollConfig?.highlightDuration ??
        const Duration(milliseconds: 300);
    // Scrolls to replied message and highlights
    if (repliedMessages != null && repliedMessages.key.currentState == null) {
      int counter = 0;
      while (repliedMessages.key.currentState == null && counter < 1200) {
        widget.scrollController.jumpTo(widget.scrollController.offset + 10);
        counter++;
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }
    if (repliedMessages != null && repliedMessages.key.currentState != null) {
      await Scrollable.ensureVisible(
        repliedMessages.key.currentState!.context,
        // This value will make widget to be in center when auto scrolled.
        alignment: 0.5,
        curve:
            repliedMsgAutoScrollConfig?.highlightScrollCurve ?? Curves.easeIn,
        duration: highlightDuration,
      );
      if (repliedMsgAutoScrollConfig?.enableHighlightRepliedMsg ?? false) {
        _replyId.value = id;

        Future.delayed(highlightDuration, () {
          _replyId.value = null;
        });
      }
    }
  }

  /// When user swipe at that time only animation is assigned with value.
  void _onHorizontalDrag(DragUpdateDetails details) {
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.2, 0.0),
    ).animate(
      CurvedAnimation(
        curve: chatBackgroundConfig.messageTimeAnimationCurve,
        parent: _animationController!,
      ),
    );

    details.delta.dx > 1
        ? _animationController?.reverse()
        : _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _replyId.dispose();
    super.dispose();
  }

  Widget get _chatStreamBuilder {
    // DateTime lastMatchedDate = DateTime.now();
    return StreamBuilder<Set<MessageBase>>(
      stream: chatController?.messageStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.connectionState.isActive) {
          return Center(
            child: chatBackgroundConfig.loadingWidget ??
                const CircularProgressIndicator(),
          );
        } else {
          final messages = (chatBackgroundConfig.sortEnable
              ? sortMessage(snapshot.data!)
              : snapshot.data!);

          final enableSeparator =
              (featureActiveConfig?.enableChatSeparator ?? false);

          // Create a combined list of messages and separators
          var combinedList = <dynamic>[];

          if (enableSeparator) {
            DateTime lastMatchedDate = DateTime.now();

            for (int i = 0; i < messages.length; i++) {
              // Add separator if it's the first message or date changes
              if (combinedList.isEmpty ||
                  lastMatchedDate.getDateFromDateTime !=
                      messages.elementAt(i).sentAt.getDateFromDateTime) {
                // Add date separator
                combinedList.add(messages.elementAt(i).sentAt);
                lastMatchedDate = messages.elementAt(i).sentAt;
              }

              // Add message
              combinedList.add(messages.elementAt(i));
            }
          } else {
            // If separators are disabled, just use the messages list
            combinedList.addAll(messages);
          }
          combinedList = combinedList.reversed.toList();

          return ListView.builder(
            cacheExtent: chatListConfig.messageConfig.cacheExtent,
            controller: widget.scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            key: widget.key,
            // addAutomaticKeepAlives: true,
            physics: showPopUp
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: chatTextFieldHeight +
                    MediaQuery.of(context).viewInsets.bottom,
                top: chatListConfig.appBarConfiguration.extendListBelowAppbar
                    ? chatListConfig.appBarConfiguration.appBarSize ??
                        appBarSize
                    : 10),
            shrinkWrap: false,
            reverse: true,
            itemCount: combinedList.length,
            itemBuilder: (context, index) {
              final item = combinedList[index];

              // Check if the item is a DateTime (separator)
              if (item is DateTime) {
                return _groupSeparator(item);
              }

              // Item is a Message
              return ValueListenableBuilder<String?>(
                valueListenable: _replyId,
                builder: (context, state, child) {
                  final message = item as MessageBase;
                  final enableScrollToRepliedMsg = chatListConfig
                          .repliedMessageConfig
                          ?.repliedMsgAutoScrollConfig
                          .enableScrollToRepliedMsg ??
                      false;
                  if (message.isSystemMsg) {
                    //! Handle Banners
                    if (chatListConfig
                            .messageConfig.customSystemMessageWrapper ==
                        null) {
                      return Text(message.asSystemMsg!.content.text);
                    } else {
                      return chatListConfig.messageConfig
                          .customSystemMessageWrapper!(message.asSystemMsg!);
                    }
                  }
                  final userMessage = message.asUserMsg!;
                  return ChatBubbleWidget(
                    key: message.key,
                    message: userMessage,
                    slideAnimation: _slideAnimation,
                    onLongPress: (yCoordinate, xCoordinate) =>
                        widget.onChatBubbleLongPress(
                      yCoordinate,
                      xCoordinate,
                      userMessage,
                    ),
                    onSwipe: widget.assignReplyMessage,
                    shouldHighlight: state == message.id,
                    onReplyTap: enableScrollToRepliedMsg
                        ? (replyId) => _onReplyTap(replyId, snapshot.data)
                        : null,
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  double get appBarSize {
    if (chatListConfig.appBarConfiguration.extendListBelowAppbar &&
        chatListConfig.appBarConfiguration.key != null) {
      final renderObj = chatListConfig.appBarConfiguration.key!.currentContext
          ?.findRenderObject() as RenderBox?;

      if (renderObj == null) {
        return 10.0;
      }

      return renderObj.size.height + 10;
    }
    return 10.0;
  }

  Set<MessageBase<MessageContent>> sortMessage(
      Set<MessageBase<MessageContent>> messages) {
    final elements = [...messages];
    elements.sort(
      chatBackgroundConfig.messageSorter ??
          (a, b) => a.sentAt.compareTo(b.sentAt),
    );
    if (chatBackgroundConfig.groupedListOrder.isAsc) {
      return elements.toSet();
    } else {
      return elements.reversed.toSet();
    }
  }

  /// return DateTime by checking lastMatchedDate and message created DateTime
  DateTime _groupBy(
    UserMessage message,
    DateTime lastMatchedDate,
  ) {
    /// If the conversation is ongoing on the same date,
    /// return the same date [lastMatchedDate].

    /// When the conversation starts on a new date,
    /// we are returning new date [message.sentAt].
    return lastMatchedDate.getDateFromDateTime ==
            message.sentAt.getDateFromDateTime
        ? lastMatchedDate
        : message.sentAt;
  }

  Widget _groupSeparator(DateTime createdAt) {
    return featureActiveConfig?.enableChatSeparator ?? false
        ? _GroupSeparatorBuilder(
            separator: createdAt,
            defaultGroupSeparatorConfig:
                chatBackgroundConfig.defaultGroupSeparatorConfig,
            groupSeparatorBuilder: chatBackgroundConfig.groupSeparatorBuilder,
          )
        : const SizedBox.shrink();
  }

//   GetMessageSeparator _getMessageSeparator(
//     List<Message> messages,
//     DateTime lastDate,
//   ) {
//     final messageSeparator = <int, DateTime>{};
//     var lastMatchedDate = lastDate;
//     var counter = 0;

//     /// Holds index and separator mapping to display in chat
//     for (var i = 0; i < messages.length; i++) {
//       if (messageSeparator.isEmpty) {
//         /// Separator for initial message
//         messageSeparator[0] = messages[0].createdAt;
//         continue;
//       }
//       lastMatchedDate = _groupBy(
//         messages[i],
//         lastMatchedDate,
//       );
//       var previousDate = _groupBy(
//         messages[i - 1],
//         lastMatchedDate,
//       );

//       if (previousDate != lastMatchedDate) {
//         /// Group separator when previous message and
//         /// current message time differ
//         counter++;

//         messageSeparator[i + counter] = messages[i].createdAt;
//       }
//     }

//     return (messageSeparator, lastMatchedDate);
//   }
}

class _GroupSeparatorBuilder extends StatelessWidget {
  const _GroupSeparatorBuilder({
    Key? key,
    required this.separator,
    this.groupSeparatorBuilder,
    this.defaultGroupSeparatorConfig,
  }) : super(key: key);
  final DateTime separator;
  final StringWithReturnWidget? groupSeparatorBuilder;
  final DefaultGroupSeparatorConfiguration? defaultGroupSeparatorConfig;

  @override
  Widget build(BuildContext context) {
    return groupSeparatorBuilder != null
        ? groupSeparatorBuilder!(separator.toString())
        : ChatGroupHeader(
            day: separator,
            groupSeparatorConfig: defaultGroupSeparatorConfig,
          );
  }
}
