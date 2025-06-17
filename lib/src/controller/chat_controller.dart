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
import 'dart:async';

import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/suggestions/suggestion_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatController {
  /// Represents initial message list in chat which can be add by user.
  Set<MessageBase<MessageContent>> initialMessageList;

  ScrollController scrollController;

  /// Allow user to show typing indicator defaults to false.
  final ValueNotifier<ChatViewState> chatViewStateNotifier =
      ValueNotifier(ChatViewState.loading);

  ChatViewState get chatViewState => chatViewStateNotifier.value;

  /// Set state of the chat.
  set setChatViewState(ChatViewState value) {
    if (value != chatViewStateNotifier.value) {
      chatViewStateNotifier.value = value;
      // chatViewStateNotifier.notifyListeners();
    }
  }

  /// Allow user to show typing indicator defaults to false.
  final ValueNotifier<bool> _showTypingIndicator = ValueNotifier(false);

  /// TypingIndicator as [ValueNotifier] for [GroupedChatList] widget's typingIndicator [ValueListenableBuilder].
  ///  Use this for listening typing indicators
  ///   ```dart
  ///    chatcontroller.typingIndicatorNotifier.addListener((){});
  ///  ```
  /// For more functionalities see [ValueNotifier].
  ValueListenable<bool> get typingIndicatorNotifier => _showTypingIndicator;

  /// Allow user to add reply suggestions defaults to empty.
  final ValueNotifier<List<SuggestionItemData>> _replySuggestion =
      ValueNotifier([]);

  /// newSuggestions as [ValueNotifier] for [SuggestionList] widget's [ValueListenableBuilder].
  ///  Use this to listen when suggestion gets added
  ///   ```dart
  ///    chatcontroller.newSuggestions.addListener((){});
  ///  ```
  /// For more functionalities see [ValueNotifier].
  ValueListenable<List<SuggestionItemData>> get newSuggestions =>
      _replySuggestion;

  /// Getter for typingIndicator value instead of accessing [_showTypingIndicator.value]
  /// for better accessibility.
  bool get showTypingIndicator => _showTypingIndicator.value;

  /// Setter for changing values of typingIndicator
  /// ```dart
  ///  chatContoller.setTypingIndicator = true; // for showing indicator
  ///  chatContoller.setTypingIndicator = false; // for hiding indicator
  ///  ````
  set setTypingIndicator(bool value) => _showTypingIndicator.value = value;

  /// Represents list of chat users
  Set<ChatUser> otherUsers;

  /// Provides current user which is sending messages.
  final ChatUser currentUser;

  Set<ChatUser> get allUsers => {...otherUsers, currentUser};

  ChatController({
    required this.initialMessageList,
    required this.scrollController,
    required this.otherUsers,
    required this.currentUser,
  });

  /// Represents message stream of chat
  StreamController<Set<MessageBase<MessageContent>>> messageStreamController =
      StreamController();

  /// Used to dispose ValueNotifiers and Streams.
  void dispose() {
    _showTypingIndicator.dispose();
    _replySuggestion.dispose();
    scrollController.dispose();
    messageStreamController.close();
  }

  /// Set status of a message in message list.
  void setMessageStatus(
      UserMessage<MessageContent> message, MessageStatus status) {
    initialMessageList.remove(message);
    initialMessageList.add(message.copyWith(status: status));
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Used to add reply suggestions.
  void addReplySuggestions(List<SuggestionItemData> suggestions) {
    _replySuggestion.value = suggestions;
  }

  /// Used to remove reply suggestions.
  void removeReplySuggestions() {
    _replySuggestion.value = [];
  }

  /// Function for setting reaction on specific chat bubble
  void setReaction({
    required String messageId,
    required String idUser,
    required String? emoji,
  }) {
    final message = initialMessageList
        .where((m) => m.id == messageId)
        .firstOrNull
        ?.asUserMsg;
    if (message == null) return;
    final reaction = message.reactions
        .where((r) => r.idMessage == message.id && r.idUser == idUser)
        .firstOrNull;
    // There is no reaction on this message by this user
    if (reaction == null) {
      if (emoji == null) return;
      initialMessageList = {
        ...initialMessageList.where((m) => m.id != message.id),
        message.copyWith(
          reactions: {
            ...message.reactions,
            Reaction(idMessage: message.id, idUser: idUser, reaction: emoji),
          },
        ),
      };
    } else {
      // Backend returns null or there is already a reaction by this user
      if (emoji == null || reaction.reaction == emoji) {
        // The reaction is the same. So we remove the existing one
        initialMessageList = {
          ...initialMessageList.where((m) => m.id != message.id),
          message.copyWith(
            reactions: {
              ...message.reactions.where(
                  (r) => r.idUser != idUser && r.idMessage == message.id),
            },
          ),
        };
      } else {
        // The reaction is different. So we remove the previous and add the new
        initialMessageList = {
          ...initialMessageList.where((m) => m.id != message.id),
          message.copyWith(
            reactions: {
              ...message.reactions.where(
                  (r) => r.idUser != idUser && r.idMessage == message.id),
              Reaction(idMessage: message.id, idUser: idUser, reaction: emoji),
            },
          ),
        };
      }
    }
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Function for marking a message as read
  void markAsRead({
    required String messageId,
    required String idUser,
  }) {
    final message = initialMessageList
        .where((m) => m.id == messageId)
        .firstOrNull
        ?.asUserMsg;
    if (message == null) return;
    initialMessageList = {
      ...initialMessageList.where((m) => m.id != message.id),
      message.copyWith(
        readBy: {...message.readBy, idUser},
      ),
    };
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Function to scroll to last messages in chat view
  void scrollToLastMessage() => Timer(
        const Duration(milliseconds: 10000),
        () {
          if (!scrollController.hasClients) return;
          scrollController.animateTo(
            scrollController.positions.last.minScrollExtent,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 10000),
          );
        },
      );

  /// Used to add message in message list.
  void addMessage(MessageBase<MessageContent> message) {
    // initialMessageList.add(message);
    initialMessageList = {message, ...initialMessageList};
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
      setChatViewState = initialMessageList.isEmpty
          ? ChatViewState.noData
          : ChatViewState.hasMessages;
    }
  }

  /// Function for loading data while pagination.
  void loadMoreData(Set<MessageBase<MessageContent>> messageList) {
    /// Here, we have passed 0 index as we need to add data before first data
    initialMessageList = {...messageList, ...initialMessageList};
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
      setChatViewState = initialMessageList.isEmpty
          ? ChatViewState.noData
          : ChatViewState.hasMessages;
    }
  }

  /// Function for adding messages. This replaces all existing data.
  void addMessages(Set<MessageBase<MessageContent>> messageList) {
    initialMessageList = {...messageList};
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
      setChatViewState = initialMessageList.isEmpty
          ? ChatViewState.noData
          : ChatViewState.hasMessages;
    }
  }

  /// Function for getting ChatUser object from user id
  ChatUser getUserFromId(String userId) => userId == currentUser.id
      ? currentUser
      : otherUsers.firstWhere((element) => element.id == userId);
}
