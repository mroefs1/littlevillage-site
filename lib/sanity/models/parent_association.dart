import 'portable_text.dart';

class PaBoardMember {
  final String role;
  final String name;

  const PaBoardMember({required this.role, required this.name});

  factory PaBoardMember.fromJson(Map<String, dynamic> json) {
    return PaBoardMember(role: json['role'] as String, name: json['name'] as String);
  }
}

class PaContact {
  final String name;
  final String email;

  const PaContact({required this.name, required this.email});

  factory PaContact.fromJson(Map<String, dynamic> json) {
    return PaContact(name: json['name'] as String, email: json['email'] as String);
  }
}

/// The `parentAssociation` singleton — intro copy, dues, signup link, board
/// members, and contacts for the Parent Association page.
class ParentAssociationInfo {
  final PortableText intro;
  final String duesAnnual;
  final String duesLifetime;
  final String signupUrl;
  final List<PaBoardMember> boardMembers;
  final List<PaContact> contacts;

  const ParentAssociationInfo({
    required this.intro,
    required this.duesAnnual,
    required this.duesLifetime,
    required this.signupUrl,
    this.boardMembers = const [],
    this.contacts = const [],
  });

  factory ParentAssociationInfo.fromJson(Map<String, dynamic> json) {
    return ParentAssociationInfo(
      intro: PortableText.fromJson(json['intro'] as List<dynamic>?),
      duesAnnual: json['duesAnnual'] as String,
      duesLifetime: json['duesLifetime'] as String,
      signupUrl: json['signupUrl'] as String,
      boardMembers: (json['boardMembers'] as List<dynamic>? ?? const [])
          .map((item) => PaBoardMember.fromJson(item as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>? ?? const [])
          .map((item) => PaContact.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
