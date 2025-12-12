class MemberResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  MemberResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory MemberResponse.fromJson(Map<String, dynamic>? json) => MemberResponse(
        id: json?['id'] ?? 'null',
        firstName: json?['firstName'] ?? 'null',
        lastName: json?['lastName'] ?? 'null',
        email: json?['email'] ?? 'null',
        phone: json?['phone'] ?? 'null',
      );
}
