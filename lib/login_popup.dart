import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: Text('Login'),
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
          child: new Column(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.orange,
                    child: Text('Login With Google'),
                    onPressed: (){},
                  ),
                ],
              ),
              _LoginForm()
            ],
          )
        ),
      ],
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _emailField;
  String _passField;
  String _error;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    RegExp email = new RegExp(r"^.+?@.+?$");

    return Form(
      key: _formKey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: "Email",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Please Enter Email";
              }
              if (!email.hasMatch(value)) {
                return "Please enter valid email";
              }
            },
            onSaved: (value) { setState(() { _emailField = value; }); },
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
            ),
            validator: (value) {
              if (value.isEmpty || value.length <= 8) {
                return "Password too short";
              }
            },
            onSaved: (value) { setState(() { _passField = value; }); },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                color: Colors.blueAccent,
                child: Text("Register"),
                onPressed: () => _register(context),
              ),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text("Login"),
                onPressed: () => _login(context),
              )
            ],
          ),
          Text(_error)
        ],
      ),
    );
  }

  _register(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _auth.createUserWithEmailAndPassword(email: _emailField, password: _passField);
    }
  }

  _login(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _auth.signInWithEmailAndPassword(email: _emailField, password: _passField).then(
        (user) { Navigator.pop(context); },
        onError: (err) { setState(() { _error = "Invalid Credentials"; }); }
      );
    }
  }

}
