// ignore_for_file: public_member_api_docs, sort_constructors_first

// class Reaction {
//   Reaction({
//     required this.reactions,
//     required this.reactedUserIds,
//   });

//   factory Reaction.fromJson(Map<String, dynamic> json) {
//     final reactionsList = json['reactions'] is List<dynamic>
//         ? json['reactions'] as List<dynamic>
//         : <dynamic>[];

//     final reactions = <String>[
//       for (var i = 0; i < reactionsList.length; i++)
//         if (reactionsList[i]?.toString().isNotEmpty ?? false)
//           reactionsList[i]!.toString()
//     ];

//     final reactedUserIdList = json['reactedUserIds'] is List<dynamic>
//         ? json['reactedUserIds'] as List<dynamic>
//         : <dynamic>[];

//     final reactedUserIds = <String>[
//       for (var i = 0; i < reactedUserIdList.length; i++)
//         if (reactedUserIdList[i]?.toString().isNotEmpty ?? false)
//           reactedUserIdList[i]!.toString()
//     ];

//     return Reaction(
//       reactions: reactions,
//       reactedUserIds: reactedUserIds,
//     );
//   }

//   /// Provides list of reaction in single message.
//   final List<String> reactions;

//   /// Provides list of user who reacted on message.
//   final List<String> reactedUserIds;

//   Map<String, dynamic> toJson() => {
//         'reactions': reactions,
//         'reactedUserIds': reactedUserIds,
//       };

//   Reaction copyWith({
//     List<String>? reactions,
//     List<String>? reactedUserIds,
//   }) {
//     return Reaction(
//       reactions: reactions ?? this.reactions,
//       reactedUserIds: reactedUserIds ?? this.reactedUserIds,
//     );
//   }
// }

class Reaction {
  final String user;
  final String reaction;
  Reaction({
    required this.user,
    required this.reaction,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': user,
      'reaction': reaction,
    };
  }

  factory Reaction.fromJson(Map<String, dynamic> map) {
    return Reaction(
      user: map['user'] as String,
      reaction: map['reaction'] as String,
    );
  }

  @override
  String toString() => 'Reaction(user: $user, reaction: $reaction)';

  @override
  bool operator ==(covariant Reaction other) {
    if (identical(this, other)) return true;

    return other.user == user && other.reaction == reaction;
  }

  @override
  int get hashCode => user.hashCode ^ reaction.hashCode;
}
