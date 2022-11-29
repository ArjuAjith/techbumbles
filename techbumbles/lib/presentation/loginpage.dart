import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techbumbles/model/auth_data.dart';
import 'package:techbumbles/presentation/welcome_screen.dart';
import 'package:techbumbles/repo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool updating = false;
  AuthData? authData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 30,
            child: TextField(
              keyboardType: TextInputType.name,
              controller: userNameController,
              decoration: InputDecoration(
                  hintText: "Username", border: InputBorder.none),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 30,
            child: TextField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Password",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (!updating) {
                    if (validateLoginfield(userNameController.text.trim(),
                        passwordController.text.trim())) {
                      authData = await DataService().doLogin(
                          username: userNameController.text.trim(),
                          password: passwordController.text.trim());
                      if (authData == null) {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                              SnackBar(content: Text("Someting went wrong!!")));
                      }
                      if (authData != null) {
                        userNameController.clear();
                        passwordController.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePage(
                                      authData: authData!,
                                    )));
                      }
                      setState(() {
                        updating = false;
                      });
                    }
                    // print(authData.email);
                  }
                  if (updating) {
                    () {};
                  }
                },
                child: updating
                    ? CupertinoActivityIndicator()
                    : Text(
                        "Login",
                        style:
                            TextStyle(color: Color.fromARGB(255, 71, 59, 74)),
                      )),
          )
        ],
      ),
    ));
  }

  bool validateLoginfield(String username, String password) {
    setState(() {
      updating = true;
    });
    if (username.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Please Enter the UserName"),
        )));
      updating = false;
      return false;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Please Enter the Password"),
        )));
      updating = false;
      return false;
    }
    return true;
  }
}
