import 'package:brew_app/authentication/register.dart';
import 'package:brew_app/constant/loading.dart';
import 'package:brew_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_app/constant/constant.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign in "),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Register"),
                ),
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? "Enter Email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecorator.copyWith(hintText: 'Password'),
                        validator: (val) => val.length < 6
                            ? "Password must be greater than 6 char"
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                          color: Colors.brown[400],
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            if (_formKey.currentState.validate()) {
                              dynamic result = await _auth
                                  .signInWithEmailAndPass(email, password);
                              if (result == null) {
                                setState(() => error =
                                    'Could not sign in with credentials provided');
                              }
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(fontSize: 14.0, color: Colors.red),
                      )
                    ],
                  ),
                )),
          );
  }
}
