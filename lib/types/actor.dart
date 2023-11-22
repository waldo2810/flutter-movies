class Actor {
  final String id;
  final String name;
  final String character;
  final String profilePath;

  Actor(
      {required this.id,
      required this.name,
      required this.character,
      required this.profilePath});

  Actor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        character = json['character'],
        profilePath = json['profile_path'] != null
            ? "https://image.tmdb.org/t/p/w500${json['profile_path']}"
            : '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'character': character,
        'profilePath': profilePath
      };
}
