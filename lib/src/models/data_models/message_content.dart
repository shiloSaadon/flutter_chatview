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
        return ImageMessage.fromJson(json);
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

class ImageMessage extends MessageContent {
  final ChatImage image;
  final String? caption;
  ImageMessage({
    required this.image,
    this.caption,
  });

  factory ImageMessage.fromJson(Map<String, dynamic> json) {
    return ImageMessage(
      caption: json['caption'] as String?,
      image: ChatImage.fromJson(json['image'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'images': image.toJson(),
    };
  }

  @override
  String toString() => 'ImagesMessage(image: $image, caption: $caption)';
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

  VoiceMessage copyWith({
    String? url,
    Duration? duration,
  }) {
    return VoiceMessage(
      url: url ?? this.url,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() => 'VoiceMessage(url: $url, duration: $duration)';
}
