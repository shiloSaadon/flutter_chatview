// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';
import 'package:uuid/v4.dart';

class ChatImage {
  /// This is the path of the image in the [chats] bucket in the backend
  final String id;

  /// The file bytes are stored under a random UUID so we need to store
  /// the file name as well so it can be used in the display or when someone
  /// tries to download the file
  final String name;

  /// File when it was selected by the user
  /// This will be null if this object comes from the backend
  /// But it is useful when the user selects an image and we need
  /// to show it while it is uploading/sending
  final XFile? file;

  ChatImage._({
    required this.id,
    required this.name,
    required this.file,
  });

  ChatImage.fromPicker({
    required XFile this.file,
  })  : id = const UuidV4().generate(),
        name = file.name;

  // Image copyWith({
  //   String? url,
  //   String? name,
  //   XFile? file,
  // }) {
  //   return Image(
  //     url: url ?? this.url,
  //     name: name ?? this.name,
  //     file: file ?? this.file,
  //   );
  // }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      // 'file': file?.toMap(),
    };
  }

  factory ChatImage.fromJson(Map<String, dynamic> map) {
    return ChatImage._(
      id: map['id'] as String,
      name: map['name'] as String,
      file: null,
    );
  }

  @override
  String toString() => 'ChatImage(id: $id, name: $name, file: $file)';

  @override
  bool operator ==(covariant ChatImage other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.file == file;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ file.hashCode;
}
