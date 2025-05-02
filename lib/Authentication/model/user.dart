class User {
  User({
    this.id,
    required this.contactno,
    required this.email,
    required this.firstname,
    this.created_at,
    required this.role,
    required this.password,
    this.lastname,
  });

  final String? id;
  final DateTime? created_at;
  final String email;
  final String firstname;
  final int contactno;
  final String role;

  final String password;
  final String? lastname;

//toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'created_at': created_at,
      'email': email,
      'firstname': firstname,
      'contactno': contactno,
      'Role': role,

      'password': password,
      'lastname': lastname,
    };
  }

//fromMap
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      contactno: json['contactno'] ?? 0,
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      created_at: DateTime.parse(json['created_at']),
      role: json['role'] ?? '',
      password: json['password'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }
}
