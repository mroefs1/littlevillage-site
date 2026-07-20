class StaffMember {
  final String name;
  final String title;
  final String? bio;
  final String? photoUrl;

  const StaffMember({required this.name, required this.title, this.bio, this.photoUrl});

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      name: json['name'] as String,
      title: json['title'] as String,
      bio: json['bio'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}

class BoardMember {
  final String name;
  final String? title;
  final String? bio;
  final String? photoUrl;

  const BoardMember({required this.name, this.title, this.bio, this.photoUrl});

  factory BoardMember.fromJson(Map<String, dynamic> json) {
    return BoardMember(
      name: json['name'] as String,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}
