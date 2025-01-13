class Reaction {
  final String idMessage;
  final String idUser;
  final String reaction;
  Reaction({
    required this.idMessage,
    required this.idUser,
    required this.reaction,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id_message': idMessage,
      'id_user': idUser,
      'reaction': reaction,
    };
  }

  factory Reaction.fromJson(Map<String, dynamic> map) {
    return Reaction(
      idMessage: map['id_message'] as String,
      idUser: map['id_user'] as String,
      reaction: map['reaction'] as String,
    );
  }

  @override
  String toString() => 'Reaction(idMessage: $idMessage, idUser: $idUser, reaction: $reaction)';

  @override
  bool operator ==(covariant Reaction other) {
    if (identical(this, other)) return true;

    return other.idMessage == idMessage && other.idUser == idUser;
  }

  @override
  int get hashCode => idMessage.hashCode ^ idUser.hashCode;

  Reaction replaceReaction({
    required String newReaction,
  }) {
    return Reaction(
      idMessage: idMessage,
      idUser: idUser,
      reaction: newReaction,
    );
  }
}
