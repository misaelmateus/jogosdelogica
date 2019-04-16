import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginPage extends StatelessWidget {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _handleSignIn(BuildContext context) async {
    print("Cheguei on sign in");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);

    if (user != null) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: "Lógica APP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build login");
    return Scaffold(
        body: Center(child:Column(
          children: [
            Container(child: Text("Entre com uma conta", style: TextStyle(fontSize: 20),), padding: EdgeInsets.all(5)),
            GoogleButton(onPressed: () {
              _handleSignIn(context);
            })
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ))
    );
  }
}

class GoogleButton extends StatelessWidget {
  final onPressed;
  GoogleButton( {this.onPressed} );
  @override
  Widget build(BuildContext context){
    return new Container(
      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
    new Expanded(
      child: new FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Color(0Xffdb3236),
        onPressed: this.onPressed,
        child: new Container(
          child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new FlatButton(
                onPressed: this.onPressed,
                padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                ),
                child: new Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    Text(
                      "GOOGLE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    ),
        ],
      ),
    );
  }
}
