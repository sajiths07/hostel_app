import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      decoration: InputDecoration(
        hintText: 'CoerID/Username',
        hintStyle: new TextStyle(color: Colors.lightBlueAccent.shade100),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (value) {
        setState(() {
          _email = value!;
        });
      },
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: '',
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: new TextStyle(color: Colors.lightBlueAccent.shade100),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (value) {
        setState(() {
          _password = value!;
        });
      },
    );

    final forgotLabel = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlueAccent.shade100,
        textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        )
            .then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/homePage');
        }).catchError((e) {
          print(e);
        });
      },
      child: Text('Sign Up'),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("assets/background1.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                forgotLabel,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
