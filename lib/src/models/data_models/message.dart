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

abstract class MessageBase<Content extends MessageContent> {
  final String id;
  final String idGroup;
  final DateTime sentAt;
  final Content content;
  final GlobalKey key;
  MessageBase({
    required this.id,
    required this.idGroup,
    required this.sentAt,
    required this.content,
  }) : key = GlobalKey();
  bool get isSystemMsg => this is SystemMessage;
  SystemMessage? get asSystemMsg {
    if (!isSystemMsg) return null;
    return this as SystemMessage;
  }

  bool get isUserMsg => this is UserMessage;
  UserMessage? get asUserMsg {
    if (!isUserMsg) return null;
    return this as UserMessage;
  }

  factory MessageBase.fromJson(Map<String, dynamic> json) {
    final sentBy = json['sent_by'] as String?;
    if (sentBy == null) {
      return SystemMessage.fromJson(json) as MessageBase<Content>;
    }
    return UserMessage.fromJson(json);
  }

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class UserMessage<Content extends MessageContent> extends MessageBase<Content> {
  final String sentBy;
  final Set<Reaction> reactions;
  final bool isStarred;
  final Set<String> readBy;
  final ReplyMessage? _replyOfMsg;
  final MessageStatus status;

  ReplyMessage? get replyOfMsg => _replyOfMsg;

  /// Every other user is in the [readBy] set of users
  bool isMsgRead(Set<ChatUser> allUsers) => allUsers.every((u) => readBy.contains(u.id));

  /// Is user in the [readBy] set of users
  bool isMsgReadBy(ChatUser user) => readBy.contains(user.id);

  UserMessage({
    required super.id,
    required super.idGroup,
    required this.sentBy,
    required super.sentAt,
    this.reactions = const {},
    this.isStarred = false,
    this.readBy = const {},
    required super.content,
    this.status = MessageStatus.pending,
    ReplyMessage? replyOfMsg,
  }) : _replyOfMsg = replyOfMsg;

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

  UserMessage<Content> copyWith<MessageContent>({
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
    return UserMessage<Content>(
      id: id ?? this.id,
      idGroup: idGroup,
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

  @override
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

  factory UserMessage.fromJson(Map<String, dynamic> map) {
    final type = MessageType.tryParse(map['type'] as String);
    assert(type != null, "Message type must be provided");
    return UserMessage<Content>(
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
  bool operator ==(covariant UserMessage<Content> other) {
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

class SystemMessage extends MessageBase<TextMessage> {
  @override
  final GlobalKey key;

  SystemMessage({
    required super.id,
    required super.idGroup,
    required super.sentAt,
    required super.content,
  }) : key = GlobalKey();

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  factory SystemMessage.fromJson(Map<String, dynamic> map) {
    return SystemMessage(
      id: map['id'] as String,
      idGroup: map['id_group'] as String,
      sentAt: DateFormat('yyyy-MM-ddTHH:mm:ss').parseUtc(map['sent_at'] as String).toLocal(),
      content: TextMessage.fromJson(map['content'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(covariant SystemMessage other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return 'Message(id: $id, sentAt: $sentAt, content: $content)';
  }
}
