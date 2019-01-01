import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login_popup.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) { setState(() { _user = user; }); });
    _auth.onAuthStateChanged.listen((user) {
      setState(() { _user = user; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          _buildUser(context)
        ],
      ),
    );
  }

  Widget _buildUser(context) {
    TextStyle _style = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      shadows: <Shadow>[
        Shadow(
          color: Colors.black26,
          blurRadius: 3.0,
          offset: Offset(1.0, 1.0)
        )
      ]
    );

    if (_user != null && _user.uid != null) {
      String dname = _user.displayName;
      if (dname == null || dname == '') { dname = _user.email; }
      return new DrawerHeader(
        decoration: BoxDecoration(color: Colors.orangeAccent),
        child: new Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
            children: <Widget>[
              Text(
                dname,
                style: _style,
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text("Logout"),
                    onPressed: _logout,
                  )
                ],
              )
            ],
          )
        ),
      );
    } else {
      return new DrawerHeader(
        decoration: BoxDecoration(color: Colors.orangeAccent),
        child: new Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "You're not Logged in",
                style: _style
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (BuildContext context) => new LoginPopup().build(context));
                    },
                  )
                ],
              ),
            ],
          )
        )
      );
    }
  }

  void _logout() {
    _auth.signOut();
  }
}
