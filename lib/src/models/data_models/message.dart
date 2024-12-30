// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:flutter/cupertino.dart';

// class Message {
//   /// Provides id
//   final String id;

//   /// Used for accessing widget's render box.
//   final GlobalKey key;

//   /// Provides actual message it will be text or image/audio file path.
//   final String message;

//   /// Provides message created date time.
//   final DateTime createdAt;

//   /// Provides id of sender of message.
//   final String sentBy;

//   /// Provides reply message if user triggers any reply on any message.
//   final ReplyMessage replyMessage;

//   /// Represents reaction on message.
//   final Reaction reaction;

//   /// Provides message type.
//   final MessageType messageType;

//   /// Status of the message.
//   final MessageStatus status;

//   /// Provides max duration for recorded voice message.
//   Duration? voiceMessageDuration;

//   Message({
//     this.id = '',
//     required this.message,
//     required this.createdAt,
//     required this.sentBy,
//     this.replyMessage = const ReplyMessage(),
//     Reaction? reaction,
//     this.messageType = MessageType.text,
//     this.voiceMessageDuration,
//     this.status = MessageStatus.pending,
//   })  : reaction = reaction ?? Reaction(reactions: [], reactedUserIds: []),
//         key = GlobalKey(),
//         assert(
//           (messageType.isVoice
//               ? ((defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android))
//               : true),
//           "Voice messages are only supported with android and ios platform",
//         );

//   factory Message.fromJson(Map<String, dynamic> json) => Message(
//         id: json['id']?.toString() ?? '',
//         message: json['message']?.toString() ?? '',
//         createdAt: DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
//         sentBy: json['sentBy']?.toString() ?? '',
//         replyMessage: json['reply_message'] is Map<String, dynamic>
//             ? ReplyMessage.fromJson(json['reply_message'])
//             : const ReplyMessage(),
//         reaction: json['reaction'] is Map<String, dynamic> ? Reaction.fromJson(json['reaction']) : null,
//         messageType: MessageType.tryParse(json['message_type']?.toString()) ?? MessageType.text,
//         voiceMessageDuration: Duration(
//           microseconds: int.tryParse(json['voice_message_duration'].toString()) ?? 0,
//         ),
//         status: MessageStatus.tryParse(json['status']?.toString()) ?? MessageStatus.pending,
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'message': message,
//         'createdAt': createdAt.toIso8601String(),
//         'sentBy': sentBy,
//         'reply_message': replyMessage.toJson(),
//         'reaction': reaction.toJson(),
//         'message_type': messageType.name,
//         'voice_message_duration': voiceMessageDuration?.inMicroseconds,
//         'status': status.name,
//       };

//   Message copyWith({
//     String? id,
//     GlobalKey? key,
//     String? message,
//     DateTime? createdAt,
//     String? sentBy,
//     ReplyMessage? replyMessage,
//     Reaction? reaction,
//     MessageType? messageType,
//     Duration? voiceMessageDuration,
//     MessageStatus? status,
//     bool forceNullValue = false,
//   }) {
//     return Message(
//       id: id ?? this.id,
//       message: message ?? this.message,
//       createdAt: createdAt ?? this.createdAt,
//       sentBy: sentBy ?? this.sentBy,
//       messageType: messageType ?? this.messageType,
//       voiceMessageDuration: forceNullValue ? voiceMessageDuration : voiceMessageDuration ?? this.voiceMessageDuration,
//       reaction: reaction ?? this.reaction,
//       replyMessage: replyMessage ?? this.replyMessage,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   bool operator ==(covariant Message other) {
//     if (identical(this, other)) return true;

//     return other.id == id;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode;
//   }
// }

class Message<Content extends MessageContent> {
  final String id;
  final GlobalKey key;
  final String sentBy;
  final DateTime sentAt;
  final Set<Reaction> reactions;
  final bool isStarred;
  final bool isRead;
  final Content content;
  final ReplyMessage? _replyOfMsg;
  final MessageStatus status;

  ReplyMessage? get replyOfMsg => _replyOfMsg;

  Message({
    required this.id,
    required this.sentBy,
    required this.sentAt,
    this.reactions = const {},
    this.isStarred = false,
    this.isRead = false,
    required this.content,
    this.status = MessageStatus.pending,
    ReplyMessage? replyOfMsg,
  })  : _replyOfMsg = replyOfMsg,
        key = GlobalKey();

  ReplyMessage get asReply => ReplyMessage(
        id: id,
        sentBy: sentBy,
        sentAt: sentAt,
        reactions: reactions,
        isStarred: isStarred,
        isRead: isRead,
        content: content,
      );

  Message copyWith({
    String? id,
    GlobalKey? key,
    String? sentBy,
    DateTime? sentAt,
    Set<Reaction>? reactions,
    bool? isStarred,
    bool? isRead,
    MessageContent? content,
    ReplyMessage? replyTo,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      sentBy: sentBy ?? this.sentBy,
      sentAt: sentAt ?? this.sentAt,
      reactions: reactions ?? this.reactions,
      isStarred: isStarred ?? this.isStarred,
      isRead: isRead ?? this.isRead,
      content: content ?? this.content,
      replyOfMsg: replyTo ?? _replyOfMsg,
      status: status ?? this.status,
    );
  }
}
