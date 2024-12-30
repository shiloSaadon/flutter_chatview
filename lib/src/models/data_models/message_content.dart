abstract class MessageContent {}

class TextMessage extends MessageContent {
  final String text;
  TextMessage({
    required this.text,
  });
}

class ImagesMessage extends MessageContent {
  final List<String> images;
  final String caption;
  ImagesMessage({
    required this.images,
    required this.caption,
  });
}

class VoiceMessage extends MessageContent {
  final String url;
  final Duration duration;
  VoiceMessage({
    required this.url,
    required this.duration,
  });
}
