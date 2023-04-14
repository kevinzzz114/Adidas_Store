class User {
  final String name;
  final String email;
  final int id;
  final String password;
  final String role;

  User({required this.id, required this.name, required this.email,
        required this.password, required this.role});

  @override
  String toString() {
    return 'User(name: $name, id:$id password: $password, role: $role, email: $email)';
  }
}