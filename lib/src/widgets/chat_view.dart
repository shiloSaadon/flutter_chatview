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
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/widgets/chat_list_widget.dart';
import 'package:chatview/src/widgets/chatview_state_widget.dart';
import 'package:chatview/src/widgets/reaction_popup.dart';
import 'package:chatview/src/widgets/suggestions/suggestions_config_inherited_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as chm;
import 'package:timeago/timeago.dart';

import '../values/custom_time_messages.dart';
import 'send_message_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.chatController,
    this.onSendTap,
    this.profileCircleConfig,
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.swipeToReplyConfig,
    this.replyPopupConfig,
    this.reactionPopupConfig,
    this.loadMoreData,
    this.loadingWidget,
    required this.messageConfig,
    this.isLastPage,
    this.appBar,
    ChatBackgroundConfiguration? chatBackgroundConfig,
    this.typeIndicatorConfig,
    this.sendMessageBuilder,
    this.sendMessageConfig,
    this.onChatListTap,
    ChatViewStateConfiguration? chatViewStateConfig,
    this.featureActiveConfig = const FeatureActiveConfig(),
    this.emojiPickerSheetConfig,
    this.replyMessageBuilder,
    this.replySuggestionsConfig,
    this.scrollToBottomButtonConfig,
    this.appBarConfiguration = const AppBarConfiguration(),
  })  : chatBackgroundConfig =
            chatBackgroundConfig ?? const ChatBackgroundConfiguration(),
        chatViewStateConfig =
            chatViewStateConfig ?? const ChatViewStateConfiguration(),
        super(key: key);

  /// Provides configuration related to user profile circle avatar.
  final ProfileCircleConfiguration? profileCircleConfig;

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration messageConfig;

  /// Allow user to giving customisation to the app bar behavoiur
  final AppBarConfiguration appBarConfiguration;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configurations related to swipe chat bubble which triggers
  /// when user swipe chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides configuration for reply snack bar's appearance and options.
  final ReplyPopupConfiguration? replyPopupConfig;

  /// Provides configuration for reaction pop up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Allow user to give customisation to background of chat
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides callback when user actions reaches to top and needs to load more
  /// chat
  final VoidCallBackWithFuture? loadMoreData;

  /// Provides widget for loading view while pagination is enabled.
  final Widget? loadingWidget;

  /// Provides flag if there is no more next data left in list.
  final bool? isLastPage;

  /// Provides call back when user tap on send button in text field. It returns
  /// message, reply message and message type.
  final MessageContentCallBack? onSendTap;

  /// Provides builder which helps you to make custom text field and functionality.
  final SendMessageWithReturnWidget? sendMessageBuilder;

  /// Allow user to giving customisation typing indicator.
  final TypeIndicatorConfiguration? typeIndicatorConfig;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides configuration for chat view state appearance and functionality.
  final ChatViewStateConfiguration? chatViewStateConfig;

  /// Provides configuration for turn on/off specific features.
  final FeatureActiveConfig featureActiveConfig;

  /// Provides parameter so user can assign ChatViewAppbar.
  final Widget? appBar;

  /// Provides callback when user tap on chat list.
  final VoidCallBack? onChatListTap;

  /// Configuration for emoji picker sheet
  final Config? emojiPickerSheetConfig;

  /// Suggestion Item Config
  final ReplySuggestionsConfig? replySuggestionsConfig;

  /// Provides a callback for the view when replying to message
  final CustomViewForReplyMessage? replyMessageBuilder;

  /// Provides a configuration for scroll to bottom button config
  final ScrollToBottomButtonConfig? scrollToBottomButtonConfig;

  static void closeReplyMessageView(BuildContext context) {
    final state = context.findAncestorStateOfType<_ChatViewState>();
    if (state == null) return;

    state.replyMessageViewClose();
  }

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<SendMessageWidgetState> _sendMessageKey = GlobalKey();
  ValueNotifier<ReplyMessage?> replyMessage = ValueNotifier(null);

  late SendMessageController sendMessageController;

  ChatController get chatController => widget.chatController;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  ChatViewStateConfiguration? get chatViewStateConfig =>
      widget.chatViewStateConfig;

  FeatureActiveConfig get featureActiveConfig => widget.featureActiveConfig;

  @override
  void initState() {
    super.initState();
    setLocaleMessages('en', ReceiptsCustomMessages());

    sendMessageController = SendMessageController(
      onSendTap: (message, replyMessage) {
        if (context.suggestionsConfig?.autoDismissOnSelection ?? true) {
          chatController.removeReplySuggestions();
        }
        _onSendTap(message, replyMessage);
      },
      onReplyCallback: (reply) => replyMessage.value = reply,
      onReplyCloseCallback: () => replyMessage.value = null,
      currentUser: chatController.currentUser,
      //! Handle Banners
      repliedUser: (replayMessage) => replayMessage == null
          ? null
          : chatController.getUserFromId(replayMessage.sentBy),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scroll to last message on in hasMessages state.
    // if (widget.chatController.showTypingIndicator &&
    //     chatViewState.hasMessages) {
    //   chatController.scrollToLastMessage();
    // }
    // final sendMessageController = SendMessageController(
    //   onSendTap: (message, replyMessage, messageType) {
    //     if (context.suggestionsConfig?.autoDismissOnSelection ?? true) {
    //       chatController.removeReplySuggestions();
    //     }
    //     _onSendTap(message, replyMessage, messageType);
    //   },
    //   onReplyCallback: (reply) => replyMessage.value = reply,
    //   onReplyCloseCallback: () => replyMessage.value = const ReplyMessage(),
    //   currentUser: null,
    //   repliedUser: null,
    // );

    return ChatViewInheritedWidget(
      chatController: chatController,
      featureActiveConfig: featureActiveConfig,
      profileCircleConfiguration: widget.profileCircleConfig,
      child: SuggestionsConfigIW(
        suggestionsConfig: widget.replySuggestionsConfig,
        child: Builder(builder: (context) {
          return ConfigurationsInheritedWidget(
            chatBackgroundConfig: widget.chatBackgroundConfig,
            reactionPopupConfig: widget.reactionPopupConfig,
            typeIndicatorConfig: widget.typeIndicatorConfig,
            chatBubbleConfig: widget.chatBubbleConfig,
            replyPopupConfig: widget.replyPopupConfig,
            messageConfig: widget.messageConfig,
            profileCircleConfig: widget.profileCircleConfig,
            repliedMessageConfig: widget.repliedMessageConfig,
            swipeToReplyConfig: widget.swipeToReplyConfig,
            emojiPickerSheetConfig: widget.emojiPickerSheetConfig,
            scrollToBottomButtonConfig: widget.scrollToBottomButtonConfig,
            appBarConfiguration: widget.appBarConfiguration,
            child: Stack(
              children: [
                Container(
                  height: chatBackgroundConfig.height ??
                      MediaQuery.of(context).size.height,
                  width: chatBackgroundConfig.width ??
                      MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: chatBackgroundConfig.backgroundColor ?? Colors.white,
                    image: chatBackgroundConfig.backgroundImage != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: chatBackgroundConfig.isBackgroundLocal
                                ? AssetImage(
                                    chatBackgroundConfig.backgroundImage!,
                                  ) as ImageProvider
                                : CachedNetworkImageProvider(
                                    chatBackgroundConfig.backgroundImage!,
                                    cacheManager: chm.CacheManager(
                                      chm.Config(
                                        'imagesCacheManager',
                                        maxNrOfCacheObjects: 1000,
                                        stalePeriod: const Duration(days: 7),
                                      ),
                                    ),
                                    cacheKey:
                                        chatBackgroundConfig.backgroundImage!,
                                    headers: chatBackgroundConfig
                                        .networkImageHeaders,
                                  ))
                        : null,
                  ),
                ),
                Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: Stack(
                    children: [
                      Container(
                        height: chatBackgroundConfig.height ??
                            MediaQuery.of(context).size.height,
                        width: chatBackgroundConfig.width ??
                            MediaQuery.of(context).size.width,
                        padding: chatBackgroundConfig.padding,
                        margin: chatBackgroundConfig.margin,
                        child: Column(
                          children: [
                            if (widget.appBar != null &&
                                !widget
                                    .appBarConfiguration.extendListBelowAppbar)
                              widget.appBar!,
                            Expanded(
                              child: ValueListenableBuilder(
                                  valueListenable:
                                      chatController.chatViewStateNotifier,
                                  builder: (context, value, _) {
                                    return Stack(
                                      children: [
                                        if (value.isLoading)
                                          ChatViewStateWidget(
                                            chatViewStateWidgetConfig:
                                                chatViewStateConfig
                                                    ?.loadingWidgetConfig,
                                            chatViewState: value,
                                          )
                                        else if (value.noMessages)
                                          ChatViewStateWidget(
                                            chatViewStateWidgetConfig:
                                                chatViewStateConfig
                                                    ?.noMessageWidgetConfig,
                                            chatViewState: value,
                                            onReloadButtonTap:
                                                chatViewStateConfig
                                                    ?.onReloadButtonTap,
                                          )
                                        else if (value.isError)
                                          ChatViewStateWidget(
                                            chatViewStateWidgetConfig:
                                                chatViewStateConfig
                                                    ?.errorWidgetConfig,
                                            chatViewState: value,
                                            onReloadButtonTap:
                                                chatViewStateConfig
                                                    ?.onReloadButtonTap,
                                          )
                                        else if (value.hasMessages)
                                          ValueListenableBuilder<
                                                  List<AttachmentFile>>(
                                              valueListenable: sendMessageController
                                                  .waitingForSendAttachmentsListener,
                                              builder:
                                                  (_, attachedFiles, child) {
                                                return ValueListenableBuilder<
                                                    ReplyMessage?>(
                                                  valueListenable: replyMessage,
                                                  builder: (_, state, child) {
                                                    return ValueListenableBuilder<
                                                            bool>(
                                                        valueListenable:
                                                            sendMessageController
                                                                .messagesListSizeUpdated,
                                                        builder:
                                                            (_, __, child) {
                                                          return ChatListWidget(
                                                            replyMessage: state,
                                                            chatController: widget
                                                                .chatController,
                                                            loadMoreData: widget
                                                                .loadMoreData,
                                                            isLastPage: widget
                                                                .isLastPage,
                                                            loadingWidget: widget
                                                                .loadingWidget,
                                                            onChatListTap: widget
                                                                .onChatListTap,
                                                            assignReplyMessage:
                                                                sendMessageController
                                                                    .assignReplyMessage,
                                                          );
                                                        });
                                                  },
                                                );
                                              }),
                                        if (featureActiveConfig.enableTextField)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: SendMessageWidget(
                                              key: _sendMessageKey,
                                              sendMessageBuilder:
                                                  widget.sendMessageBuilder,
                                              sendMessageConfig:
                                                  widget.sendMessageConfig,
                                              sendMessageController:
                                                  sendMessageController,
                                              messageConfig:
                                                  widget.messageConfig,
                                              replyMessageBuilder:
                                                  widget.replyMessageBuilder,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      if (widget.appBar != null &&
                          widget.appBarConfiguration.extendListBelowAppbar)
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.appBar!,
                            ],
                          ),
                        ),
                      if (featureActiveConfig.enableReactionPopup)
                        ValueListenableBuilder<bool>(
                          valueListenable: context.chatViewIW!.showPopUp,
                          builder: (_, showPopupValue, child) {
                            return ReactionPopup(
                              key: context.chatViewIW!.reactionPopupKey,
                              onTap: () => _onChatListTap(context),
                              showPopUp: showPopupValue,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _onChatListTap(BuildContext context) {
    widget.onChatListTap?.call();
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      FocusScope.of(context).unfocus();
    }
    context.chatViewIW?.showPopUp.value = false;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _onSendTap(MessageContent content, ReplyMessage? replyMessage) {
    // --- Replace this ---
    // if (widget.sendMessageBuilder == null) {
    //   if (widget.onSendTap != null) {
    //     widget.onSendTap!(message, replyMessage, messageType);
    //   }
    //   _assignReplyMessage();
    // }
    // ------------------------
    // --- Whit this ----
    widget.onSendTap?.call(content, replyMessage);
    _assignReplyMessage();
    chatController.scrollToLastMessage();
  }

  void replyMessageViewClose() => sendMessageController.onCloseTap();

  void _assignReplyMessage() {
    replyMessage.value = null;
  }

  @override
  void dispose() {
    replyMessage.dispose();
    chatViewIW?.showPopUp.dispose();
    super.dispose();
  }
}
