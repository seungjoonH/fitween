import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitween/global/firebase.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignCont {
  static Future<UserCredential?> signIn(LoginType type) async {
    switch (type) {
      case LoginType.google: return await signInWithGoogle();
      case LoginType.apple: return await signInWithApple();
    }
  }

  static Future signOut() => a.signOut();

  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    if (googleAuth == null) return null;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await a.signInWithCredential(credential);
  }

  static Future<UserCredential?> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    return await a.signInWithCredential(oauthCredential);
  }
}