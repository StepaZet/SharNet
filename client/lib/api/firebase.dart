import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<PossibleErrorResult<Map<String, String>>> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  final tmp = await FirebaseAuth.instance.signInWithCredential(credential);

  final user = FirebaseAuth.instance.currentUser;

  final id_token = await user!.getIdToken();

 return await loginGoogleUser(id_token!);
}