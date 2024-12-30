import 'package:chatview/chatview.dart';

abstract class MessageContent {
  MessageContent();

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
}

class ImagesMessage extends MessageContent {
  final List<String> images;
  final String caption;
  ImagesMessage({
    required this.images,
    required this.caption,
  }) : assert(images.isNotEmpty);

  factory ImagesMessage.fromJson(Map<String, dynamic> json) {
    return ImagesMessage(
      caption: json['caption'] as String,
      images: json['images'] as List<String>,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'images': images,
    };
  }
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
}
