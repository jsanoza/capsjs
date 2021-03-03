import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
Future<bool> signOutUser() async {
  User user = auth.currentUser;
  auth.signOut();
}
