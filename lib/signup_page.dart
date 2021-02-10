import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String data = 'none';
  String _username, _password = "";
  final _formkey = GlobalKey<FormState>();
  bool signupFlage = false;
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  final snackBar_login = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text('Login'),
      Icon(Icons.done,color: Colors.green,)
    ],
  ));
  final snackBar_fail = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Signing Error'),
          Icon(Icons.phonelink_erase_rounded,color: Colors.green,)
        ],
      ));

  Future<String> login() async {
    final res = await http.post(
      'http://172.20.4.46:8000',
      body: {'_Name': _username, '_Pass': _password},
    );
    if (res.statusCode == 200) {
      setState(() {
        this.data = res.body;
      });
    } else {
      setState(() {
        this.data = 'error';
      });
    }
    print(res.body);
    return this.data;
  }

  Future<String> register() async {
    final res = await http.post(
      'https://172.20.4.46:8000/signup',
      body: {'_username': _username, '_pass': _password},
    );
    if (res.statusCode == 200) {
      setState(() {
        this.data = res.body;
      });
    } else {
      setState(() {
        this.data = 'error';
      });
    }
    print(res.body);
    return this.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assests/bedo.png',
                  height: 300,
                ),
                NameInput(),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 16,
                ),
                PasswordInput(),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SignInButton(),
                    SizedBox(
                      width: 5,
                    ),
                    SubmitButton(),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget NameInput() {
    return TextFormField(
      focusNode: _usernameFocusNode,
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Username",
        hintText: "e.g Bedo",
      ),
      textInputAction: TextInputAction.next,
      validator: (name) {
        Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(name)) if (this.signupFlage)
          return 'Invalid username';
        else
          return null;
        else
          return null;
      },
      onSaved: (name) => _username = name,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _usernameFocusNode, _emailFocusNode);
      },
    );
  }

  Widget PasswordInput() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: Icon(Icons.lock),
      ),
      textInputAction: TextInputAction.done,
      validator: (password) {
        Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
        RegExp regex = new RegExp(pattern);
        if (this.signupFlage) {
          if (!regex.hasMatch(password))
            return 'Invalid password';
          else
            return null;
        } else
          return null;
      },
      onSaved: (password) => _password = password,
    );
  }

  TextButton SubmitButton() {
    return TextButton(
      onPressed: () async {
        setState(() {
          this.signupFlage = true;
        });
        if (_formkey.currentState.validate()) {
          _formkey.currentState.save();
          this.data = await this.register();
          toastMessage(this.data);
        }
      },
      child: Text("SignUp"),
    );
  }

  ElevatedButton SignInButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          this.signupFlage = false;
        });
        if (_formkey.currentState.validate()) {
          _formkey.currentState.save();
          this.data = await this.login();
          if (this.data== 'error')
            ScaffoldMessenger.of(context).showSnackBar(snackBar_fail);
          else
            ScaffoldMessenger.of(context).showSnackBar(snackBar_login);
        }
      },
      child: Text(
        "Signin",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        fontSize: 16.0);
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
