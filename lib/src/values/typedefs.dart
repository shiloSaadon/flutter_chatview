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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/profile_circle.dart';
import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);
typedef MessageContentCallBack<Content extends MessageContent> = void Function(
    Content content, ReplyMessage? replyMessage);
typedef ReplyMessageWithReturnWidget = Widget Function(
  ReplyMessage? replyMessage,
);

typedef SendMessageWithReturnWidget = Widget Function(
  SendMessageController replyMessage,
);

typedef ReplyMessageCallBack = void Function(ReplyMessage? replyMessage);
typedef VoidCallBack = void Function();
typedef DoubleCallBack = void Function(double, double);
typedef MessageCallBack<Content extends MessageContent> = void Function(Message<Content> message);
typedef AssignReplayCallBack<Content extends MessageContent> = void Function(
    Message<Content> message, BuildContext context);
typedef VoidCallBackWithFuture = Future<void> Function();
typedef StringsCallBack = void Function(String emoji, String messageId);
typedef ImagesCallBack = void Function(List<ChatImage> paths);
typedef StringWithReturnWidget = Widget Function(String separator);
typedef DragUpdateDetailsCallback = void Function(DragUpdateDetails);
typedef MoreTapCallBack<Content extends MessageContent> = void Function(
  Message<Content> message,
  bool sentByCurrentUser,
);
typedef ReactionCallback<Content extends MessageContent> = void Function(
  Message<Content> message,
  String emoji,
);
typedef ReactedUserCallback = void Function(
  ChatUser reactedUser,
  String reaction,
);

/// customMessageType view for a reply of custom message type
typedef CustomMessageReplyViewBuilder = Widget Function(
  ReplyMessage state,
);

typedef SenderDataWidgets = (ProfileCircle profileCircle, Widget name);

/// to allow the user edit the container around the message
typedef CustomMessageWrapperBuilder<Content extends MessageContent> = Widget Function(
  bool isMessageBySender,
  bool highlightMessage,
  Color highlightColor,
  Message<Content> message,
  ChatBubble? inComingChatBubbleConfig,
  ChatBubble? outgoingChatBubbleConfig,
  VoiceMessageConfiguration? voiceMessageConfiguration,
  SenderDataWidgets senderDataWidgets,
  Widget messageDataWidget,
  dynamic Function(String)? onReplyTap,
);

typedef MessageSorter = int Function(
  Message<MessageContent> message1,
  Message<MessageContent> message2,
);

/// customView for replying to any message
typedef CustomViewForReplyMessage = Widget Function(
  BuildContext context,
  ReplyMessage state,
);
typedef GetMessageSeparator = (Map<int, DateTime>, DateTime);
typedef AssetImageErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);
typedef NetworkImageErrorBuilder = Widget Function(
  BuildContext context,
  String url,
  Object error,
);
typedef NetworkImageProgressIndicatorBuilder = Widget Function(
  BuildContext context,
  String url,
  DownloadProgress progress,
);
typedef SuggestionItemBuilder = Widget Function(
  int index,
  SuggestionItemData suggestionItemData,
);
typedef ImageUrlGetter = String Function(
  String idMsg,
  ChatImage img,
);
