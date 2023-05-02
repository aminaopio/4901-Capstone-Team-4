import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //google sign in
  signInWithGoogle() async {
    //interactive process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //obtain auth from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //create new user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    //sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithApple() async {}
}
