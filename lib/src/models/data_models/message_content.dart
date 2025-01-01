// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatview/chatview.dart';

abstract class MessageContent {
  MessageContent();

  @override
  String toString();

  Map<String, dynamic> toJson();

  factory MessageContent.fromJson(Map<String, dynamic> json, MessageType type) {
    switch (type) {
      case MessageType.text:
        return TextMessage.fromJson(json);
      case MessageType.image:
        return ImagesMessage.fromJson(json);
      case MessageType.voiceNote:
        return VoiceMessage.fromJson(json);
      case MessageType.gif:
        throw UnimplementedError();
      case MessageType.link:
        throw UnimplementedError();
      case MessageType.document:
        throw UnimplementedError();
      case MessageType.video:
        throw UnimplementedError();
      case MessageType.sticker:
        throw UnimplementedError();
      case MessageType.voiceSticker:
        throw UnimplementedError();
    }
  }
}

class TextMessage extends MessageContent {
  final String text;
  TextMessage({
    required this.text,
  });

  factory TextMessage.fromJson(Map<String, dynamic> json) {
    return TextMessage(
      text: json['text'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }

  @override
  String toString() => 'TextMessage(text: $text)';
}

class ImagesMessage extends MessageContent {
  final List<ChatImage> images;
  final String? caption;
  ImagesMessage({
    required this.images,
    this.caption,
  }) : assert(images.isNotEmpty);

  factory ImagesMessage.fromJson(Map<String, dynamic> json) {
    return ImagesMessage(
      caption: json['caption'] as String?,
      images: (json['images'] as List<dynamic>).map((e) => ChatImage.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'images': images.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => 'ImagesMessage(images: $images, caption: $caption)';
}

class VoiceMessage extends MessageContent {
  final String url;
  final Duration duration;
  VoiceMessage({
    required this.url,
    required this.duration,
  });

  factory VoiceMessage.fromJson(Map<String, dynamic> json) {
    return VoiceMessage(
      url: json['url'] as String,
      duration: Duration(
        microseconds: int.tryParse(json['duration'] as String) ?? 0,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'duration': duration.inMicroseconds,
    };
  }

  @override
  String toString() => 'VoiceMessage(url: $url, duration: $duration)';
}
