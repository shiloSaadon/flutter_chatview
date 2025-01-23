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
import 'package:intl/intl.dart';

class Message<Content extends MessageContent> {
  final String id;
  final String idGroup;
  final GlobalKey key;
  final String sentBy;
  final DateTime sentAt;
  final Set<Reaction> reactions;
  final bool isStarred;
  final Set<String> readBy;
  final Content content;
  final ReplyMessage? _replyOfMsg;
  final MessageStatus status;

  ReplyMessage? get replyOfMsg => _replyOfMsg;

  /// Every other user is in the [readBy] set of users
  bool isMsgRead(Set<ChatUser> allUsers) => allUsers.every((u) => readBy.contains(u.id));

  /// Is user in the [readBy] set of users
  bool isMsgReadBy(ChatUser user) => readBy.contains(user.id);

  Message({
    required this.id,
    required this.idGroup,
    required this.sentBy,
    required this.sentAt,
    this.reactions = const {},
    this.isStarred = false,
    this.readBy = const {},
    required this.content,
    this.status = MessageStatus.pending,
    ReplyMessage? replyOfMsg,
  })  : _replyOfMsg = replyOfMsg,
        key = GlobalKey();

  ReplyMessage get asReply => ReplyMessage(
        id: id,
        idGroup: idGroup,
        sentBy: sentBy,
        sentAt: sentAt,
        reactions: reactions,
        isStarred: isStarred,
        readBy: readBy,
        content: content,
      );

  Message<Content> copyWith<MessageContent>({
    String? id,
    GlobalKey? key,
    String? sentBy,
    DateTime? sentAt,
    Set<Reaction>? reactions,
    bool? isStarred,
    Set<String>? readBy,
    Content? content,
    ReplyMessage? replyTo,
    MessageStatus? status,
  }) {
    return Message<Content>(
      id: id ?? this.id,
      idGroup: this.idGroup,
      sentBy: sentBy ?? this.sentBy,
      sentAt: sentAt ?? this.sentAt,
      reactions: reactions ?? this.reactions,
      isStarred: isStarred ?? this.isStarred,
      readBy: readBy ?? this.readBy,
      content: content ?? this.content,
      replyOfMsg: replyTo ?? _replyOfMsg,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'id_group': idGroup,
      'sent_by': sentBy,
      'sent_at': sentAt.toIso8601String(),
      'reactions': reactions.map((x) => x.toJson()).toList(),
      'is_starred': isStarred,
      'read_by': readBy,
      'content': content.toJson(),
      'reply_of_msg': _replyOfMsg?.toJson(),
      'status': status.name,
    };
  }

  factory Message.fromJson(Map<String, dynamic> map) {
    final type = MessageType.tryParse(map['type'] as String);
    assert(type != null, "Message type must be provided");
    return Message<Content>(
      id: map['id'] as String,
      idGroup: map['id_group'] as String,
      sentBy: map['sent_by'] as String,
      sentAt: DateFormat('yyyy-MM-ddTHH:mm:ss').parseUtc(map['sent_at'] as String).toLocal(),
      reactions: map['reactions'] == null
          ? {}
          : Set<Reaction>.from(
              (map['reactions'] as List<dynamic>).map<Reaction>(
                (x) => Reaction.fromJson(x as Map<String, dynamic>),
              ),
            ),
      isStarred: map['is_starred'] == null ? false : map['is_starred'] as bool,
      readBy: map['read_by'] == null
          ? {}
          : Set<String>.from((map['read_by'] as List<dynamic>).map<String>((x) => x as String)),
      content: MessageContent.fromJson(map['content'] as Map<String, dynamic>, type!) as Content,
      replyOfMsg:
          map['reply_of_msg'] != null ? ReplyMessage.fromJson(map['reply_of_msg'] as Map<String, dynamic>) : null,
      status: MessageStatus.delivered,
    );
  }

  @override
  bool operator ==(covariant Message<Content> other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return 'Message(id: $id, sentBy: $sentBy, sentAt: $sentAt, reactions: $reactions, isStarred: $isStarred, readBy: $readBy, content: $content, replyOfMsg: $replyOfMsg, status: $status)';
  }
}
