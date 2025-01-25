import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home_Screen.dart';
import 'Sign_Up.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({super.key});

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  var Emailcontroller = TextEditingController();
  var Passwordcontroller = TextEditingController();
  bool password = true;
  bool saveLogin = false;
  var formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  void _loadSavedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      saveLogin = prefs.getBool('saveLogin') ?? false;
      if (saveLogin) {
        Emailcontroller.text = prefs.getString('savedEmail') ?? '';
        Passwordcontroller.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  void _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (saveLogin) {
      await prefs.setString('savedEmail', Emailcontroller.text);
      await prefs.setString('savedPassword', Passwordcontroller.text);
      await prefs.setBool('saveLogin', true);
    } else {
      await prefs.remove('savedEmail');
      await prefs.remove('savedPassword');
      await prefs.setBool('saveLogin', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orange],
                begin: Alignment.topRight,
                end: Alignment.centerRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "welcome back",
                    style: TextStyle(
                        letterSpacing: 5,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 50, right: 10, bottom: 20),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(255, 150, 40, 30)
                                            .withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ],
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value != null && value.isEmpty)
                                        return 'Email can\'t be empty';
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        label: Text(
                                          "Enter your Email",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        prefixIcon: Icon(Icons.email_outlined),
                                        border: InputBorder.none),
                                    controller: Emailcontroller,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value != null && value.isEmpty)
                                        return 'Password can\'t be empty';
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      label: Text(
                                        "Password",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        icon: password == true
                                            ? Icon(Icons.visibility_off_rounded)
                                            : Icon(
                                                Icons.remove_red_eye_rounded),
                                        onPressed: () {
                                          setState(() {
                                            password = !password;
                                          });
                                        },
                                      ),
                                    ),
                                    controller: Passwordcontroller,
                                    keyboardType: TextInputType.text,
                                    obscureText: password,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.deepOrange,
                                value: saveLogin,
                                onChanged: (value) {
                                  setState(() {
                                    saveLogin = value!;
                                  });
                                },
                              ),
                              Text("Save Login"),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 230,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius:
                                  BorderRadiusDirectional.circular(20),
                            ),
                            child: MaterialButton(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () async {
                                  try {
                                    if (formkey.currentState!.validate()) {
                                      final user = await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: Emailcontroller.text,
                                              password:
                                                  Passwordcontroller.text);
                                      _saveLoginState(); // Save login state
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()),
                                  );
                                },
                                child: Text(
                                  'Register Now',
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
