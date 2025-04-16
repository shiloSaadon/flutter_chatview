// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatview/src/models/data_models/attachment_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/v4.dart';

class ChatImage extends AttachmentFile {
  /// This is the path of the image in the [chats] bucket in the backend
  final String id;

  /// The file bytes are stored under a random UUID so we need to store
  /// the file name as well so it can be used in the display or when someone
  /// tries to download the file
  final String name;
  final String? ext;
  final String? mimeType;

  /// File when it was selected by the user
  /// This will be null if this object comes from the backend
  /// But it is useful when the user selects an image and we need
  /// to show it while it is uploading/sending
  final XFile? file;

  ChatImage._({
    required this.id,
    required this.name,
    required this.file,
    this.ext,
    this.mimeType,
  });

  ChatImage.fromPicker({
    required XFile this.file,
  })  : id = const UuidV4().generate(),
        name = file.name,
        ext = file.path.split('.').lastOrNull,
        mimeType = file.mimeType;

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
      'ext': ext,
      'mime_type': mimeType,
      // 'file': file?.toMap(),
    };
  }

  factory ChatImage.fromJson(Map<String, dynamic> map) {
    return ChatImage._(
      id: map['id'] as String,
      name: map['name'] as String,
      ext: map['ext'] as String?,
      mimeType: map['mime_type'] as String?,
      file: null,
    );
  }

  @override
  String toString() =>
      'ChatImage(id: $id, name: $name, file: $file, ext: $ext, mimeType: $mimeType)';

  @override
  bool operator ==(covariant ChatImage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.file == file &&
        other.ext == ext &&
        other.mimeType == mimeType;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      file.hashCode ^
      ext.hashCode ^
      mimeType.hashCode;
}
