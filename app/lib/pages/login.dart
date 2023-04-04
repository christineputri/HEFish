import 'dart:convert';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:he_fish/pages/front.dart';
import '../constants.dart';
import 'registration.dart';
import 'package:http/http.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:he_fish/helper/google_signin_api.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    validateToken();
  }

  void validateToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FrontPage()));
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])");
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isInAsyncCall = false;
  bool _passwordVisible = false;

  Future<void> _login(String username, password) async {
    try {
      setState(() => _isInAsyncCall = true);
      Response response = await post(Uri.parse('${httpUrl}users/login/'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({'username': username, 'password': password}));

      if (response.statusCode == 200) {
        setState(() => _isInAsyncCall = false);
        var data = jsonDecode(response.body.toString());
        var user = data["user"];
        var userID = user["id"];
        var userToken = user["token"];

        final userPref = await SharedPreferences.getInstance();

        userPref.setInt('id', userID);
        userPref.setString('token', userToken);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FrontPage(),
            ));
      } else {
        var snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('Login failed. Check your username and password.'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() => _isInAsyncCall = false);
        print('failed');
      }
    } catch (e) {
      setState(() => _isInAsyncCall = false);
      print("ERROR " + e.toString());
    }
  }

  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Container(
          padding: EdgeInsets.only(top: 20),
          width: 180.0,
          height: 180.0,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/images/logo_hefish.png")))),
    );

    final loginButton = ElevatedButton(
        onPressed: () {
          _login(usernameController.text.toString(),
              passwordController.text.toString());
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(45, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Text('Login',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)));

    final userName = TextFormField(
      validator: MultiValidator([
        RequiredValidator(errorText: "* Required"),
        MinLengthValidator(4,
            errorText: ("Username should be at least 4 characters")),
      ]),
      controller: usernameController,
      decoration: const InputDecoration(
        hintText: 'Input your username',
        labelText: 'Username',
      ),
    );

    final userPass = TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "* Required";
        } else {
          bool result = validatePassword(value);
          if (result) {
            return null;
          } else {
            return " Password should contain Capital, small letter & Number & Special";
          }
        }
      },
      controller: passwordController,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.lightBlue,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );

    final createAccount = Row(
      children: <Widget>[
        const Text('Does not have account?'),
        TextButton(
          child: const Text(
            'Create',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RegistrationPage()));
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );

    final rowDivider = Row(children: <Widget>[
      Expanded(child: Divider()),
      Text("OR"),
      Expanded(child: Divider()),
    ]);

    final googleButton = Container(
        width: 80.0,
        height: 30.0,
        child: SignInButton(
          Buttons.GoogleDark,
          onPressed: signIn,
        ));

    final pageTitle = Center(
      child: Text('SIGN IN',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900)),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
            isLoading: _isInAsyncCall,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formkey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                children: <Widget>[
                  SizedBox(height: 48.0),
                  logo,
                  SizedBox(height: 48.0),
                  pageTitle,
                  SizedBox(height: 12.0),
                  userName,
                  SizedBox(height: 12.0),
                  userPass,
                  SizedBox(height: 34.0),
                  loginButton,
                  createAccount,
                  SizedBox(height: 12.0),
                  rowDivider,
                  SizedBox(height: 12.0),
                  googleButton
                ],
              ),
            )));
  }
}

Future signIn() async {
  final user = await GoogleSignInApi.login();
  print(user);
}
