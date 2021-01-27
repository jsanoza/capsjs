import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/second.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'session.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

// a simple sialog to be visible everytime some error occurs
showErrDialog(BuildContext context, String err) {
  // to hide the keyboard, if it is still p
  FocusScope.of(context).requestFocus(new FocusNode());
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}


 

Future<User> signInWithGoogle() async {
  User user;
  var errorMessage;

  try {
    GoogleSignInAccount googleAccount = await gooleSignIn.signIn();

    if (googleAccount == null) {
      errorMessage = "CANCELLED_SIGN_IN";
      return Future.error(errorMessage);
    }

    GoogleSignInAuthentication googleAuthentication =
        await googleAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );

    UserCredential authResult = await auth.signInWithCredential(credential);
    user = authResult.user;
    var disp = user.displayName;
    print(disp + "hahahha");
    // List<String> signInMethods =
    //     await auth.fetchSignInMethodsForEmail(email: user.email);
    // if (signInMethods.length > 0) {
    //   print("im here" + signInMethods.toString());
    //   try {
    //     authResult.user.linkWithCredential(credential);
    //   } catch (e) {
    //     if (e == "User has already been linked to the given provider") {
    //       print("already link bruh");
    //     }
    //   }
    // }

    Util.uid = user.uid;
    Util.email = user.email;
    print(user.email);
    // get what you need to identify the user
    return user;
  } catch (error) {
    switch (error.code) {
      case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
        errorMessage = "Account already exists with a different credential.";

        break;

      case "ERROR_INVALID_CREDENTIAL":
        errorMessage = "Invalid credential.";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened. ";
    }
  }
  if (errorMessage != null) {
    return Future.error(errorMessage);
  }

  return null;
}

// instead of returning true or false
// returning user to directly access UserID
Future<User> signin(
    String email, String password, BuildContext context) async {
  try {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user;
    Util.uid = user.uid;
    Util.email = user.email;

    return Future.value(user);
  } catch (e) {
    // simply passing error code as a message
    print(e.code);
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_WRONG_PASSWORD':
        List<String> signInMethods =
            await auth.fetchSignInMethodsForEmail(email);
        print(signInMethods);
        if (signInMethods.length == 1) {
          if (signInMethods.contains("password")) {
            showErrDialog(context, "Wrong Password.");
          } else if (signInMethods.contains("facebook.com")) {
            showErrDialog(context,
                "This email is linked with Facebook provider. Log in using the provider and set up your password to use this future.");
          } else if (signInMethods.contains("google.com")) {
            showErrDialog(context,
                "This email is linked with Google provider. Log in using the provider and set up your password to use this future.");
          }
        } else if (signInMethods.length == 2) {
          //showErrDialog(context, "This email is linked with another provider.");

          showErrDialog(context,
              "This email is linked with Facebook provider. Log in using Facebook / Google and Set up your password to use this future.");
        } else if (signInMethods.length == 3) {
          showErrDialog(context, "Wrong Password.x");
        } else {
          showErrDialog(context, e.code);
        }
        break;
      case 'ERROR_USER_NOT_FOUND':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_USER_DISABLED':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        showErrDialog(context, e.code);
        break;
    }
    // since we are not actually continuing after displaying errors
    // the false value will not be returned
    // hence we don't have to check the valur returned in from the signin function
    // whenever we call it anywhere
    return Future.value(null);
  }
}

// change to Future<FirebaseUser> for returning a user
Future<User> signUp(
    String email, String password, BuildContext context) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;

    return Future.value(user);
  } catch (error) {
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        showErrDialog(context, "Email Address Exists");
        List<String> signInMethods =
            await auth.fetchSignInMethodsForEmail(email);
        if (signInMethods.length > 0) {
          print("im here" + signInMethods[0]);
        }
        break;
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, "Invalid Email Address");
        break;
      case 'ERROR_WEAK_PASSWORD':
        showErrDialog(context, "Please Choose a stronger password");
        break;
    }
    return Future.value(null);
  }
}

Future<void> signOut() async {
  signOutFBUser();
  signOut();

  return Future.value(true);
}

Future<bool> signOutUser() async {
  User user = auth.currentUser;
  // print(user.providerData[2].providerId);
  if (user.providerData[0].providerId == 'google.com') {
    await gooleSignIn.disconnect();
    print(user.providerData[1].providerId);
  }
  if (user.providerData[0].providerId == 'facebook.com') {
    var facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
  }

  await auth.signOut();
  return Future.value(true);
}

Future<bool> signOutFBUser() async {
  User user = auth.currentUser;
  // print(user.providerData[2].providerId);
  if (user.providerData[0].providerId == 'facebook.com') {
    var facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
  }
  await auth.signOut();
  return Future.value(true);
}


Future<dynamic> handleFacebookSignInz() async {
    final FacebookLogin _facebookLogin = FacebookLogin();
    User user;
    FacebookLoginResult result;
    // Usuario usuario = new Usuario();
    String token;
    AuthCredential credential;
    try {
      _facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
      result = await _facebookLogin
          .logIn(['email', 'public_profile']);
      Util.uid = result.accessToken.userId.toString();

      credential = FacebookAuthProvider.credential(result.accessToken.token);
      token = result.accessToken.token;
      UserCredential firebaseUser = await auth.signInWithCredential(credential);

      user = firebaseUser.user;
    } catch (e) {
      print(result.errorMessage);
      print("handle facebook sign in: $e");
      if (e.code == 'ACCOUNT-EXISTS-WITH-DIFFERENT-CREDENTIAL') {
        // if exists get email of your simple get (i will write the code by this later)
       final graphResponse = await Session.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token.toString()}');

       final email = graphResponse["email"];
        // unused
        final signInMethods = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(email);
        User guser; // create a google user
        //get credential google here
        try {
          final GoogleSignIn _googleSignIn = GoogleSignIn();
          GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final UserCredential firebaseUser =
              await auth.signInWithCredential(credential);
          guser = firebaseUser.user;
          // get google user
        } catch (e) {
          print("handle google sign in: $e");
        }
        final authResult = guser;
        if (authResult.email == email) {
          // link facebook + google.
          await authResult.linkWithCredential(credential);
        }

        //return usuario;
      }
    }
    return user;
  }

void handleFacebookSignIn() async {
    User user;
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
// Remember you MUST login with email permission
    final loginResult = await facebookLogin.logIn(['email']);
    final credential = FacebookAuthProvider.credential(
       loginResult.accessToken.token);
    try {
      // Assume we'll login with an error that causes `ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL`
      UserCredential authResult = await auth.signInWithCredential(credential);
      user = authResult.user;
      var displayname = user.displayName;
      Util.uid = user.uid;
      print(displayname);
       Get.to(Second());
    } on PlatformException catch (e) {
      if (e.code != 'account-exists-with-different-credential') throw e;
      
      // Now we caught the error we're talking about, we get the email by calling graph API manually
      final httpClient = new HttpClient();
      final graphRequest = await httpClient.getUrl(Uri.parse(
          "https://graph.facebook.com/v2.12/me?fields=email&access_token=${loginResult.accessToken.token}"));
      final graphResponse = await graphRequest.close();
      final graphResponseJSON =
          json.decode((await graphResponse.transform(utf8.decoder).single));
      final email = graphResponseJSON["email"];
      print(email + 'helloimemail');

      print(Util.gender);
      // Now we have both credential and email that is required for linking
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      print(email);
      print(signInMethods[0].toString());
      // Assume that signInMethods[0] is 'google.com'
      // ... do the Google sign-in logic here and get the Firebase AuthResult

      try {
        GoogleSignInAccount googleAccount = await gooleSignIn.signIn();

        if (googleAccount == null) {
          print("error");
        }

        GoogleSignInAuthentication googleAuthentication =
            await googleAccount.authentication;

        AuthCredential credentialx = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
          accessToken: googleAuthentication.accessToken,
        );

        UserCredential authResult = await auth.signInWithCredential(credentialx);
        user = authResult.user;
        if (authResult.user.email == email) {
          // Now we can link the accounts together
          await authResult.user.linkWithCredential(credential);
          Util.uid = user.uid;
           Get.to(Second());
        }
      } catch (e) {
        if (e == "User has already been linked to the given provider") {
          print("already link bruh");
        }
      }

      // if (signInMethods[0].toString().contains('password')) {}

    }
  }