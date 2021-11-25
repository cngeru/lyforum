class AuthUser {
  String userID;
  String? displayName;
  String? photoURL;
  String? email;
  String? phoneNumber;
  AuthUser({
    required this.userID,
    required this.displayName,
    required this.photoURL,
    required this.email,
    this.phoneNumber = "",
  });
}
