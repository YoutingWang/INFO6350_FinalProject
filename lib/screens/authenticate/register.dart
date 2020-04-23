import 'package:flutter/material.dart';
import '../../screens/authenticate/sign_in.dart';
import '../../screens/home/home.dart';
import '../../services/auth.dart';
import '../../shared/customContainer.dart';
import '../../shared/loading.dart';
import '../../shared/logo2.dart';
import '../../theme/light_color.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // get user email and password
  String _email = '';
  String _password = '';
  String _error = '';

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text(
              'Back',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (val) => val.isEmpty ? 'Email cannot be empty' : null,
            onChanged: (val) {
              setState(() => _email = val);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            // length of password needs to be longer than 6
            validator: (val) =>
                val.length < 6 ? 'Password length must be longer than 6' : null,
            onChanged: (val) {
              setState(() => _password = val);
            },
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [LightColor.lightOrange, LightColor.darkOrange])),
      child: Text(
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: LightColor.lightOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 40.0),
                                Logo2(),
                                SizedBox(height: 50.0),
                                _emailField(),
                                _passwordField(),
                                SizedBox(height: 20.0),
                                RaisedButton(
                                  color: Colors.white,
                                  elevation: 0.0,
                                  child: _registerButton(),
                                  onPressed: () async {
                                    // if the input email and password meet validators
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              _email, _password);
                                      if (result == null) {
                                        setState(
                                          () {
                                            _error =
                                                'Please provide a valid email';
                                            loading = false;
                                          },
                                        );
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home()));
                                      }
                                    }
                                  },
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: _loginAccountLabel(),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  _error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(top: 40, left: 0, child: _backButton()),
                    Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: CustomContainer(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
