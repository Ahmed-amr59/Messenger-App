import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetask/Home_Screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _ageController = TextEditingController();
  var Emailcontroller = TextEditingController();
  var Passwordcontroller = TextEditingController();
  bool password = true;
  bool ismale = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
          child: CustomPaint(
            painter: Custompainter(),
          ),
        ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty)
                            return 'Email can\'t be empty';
                          return null;
                        },
                        decoration: InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        controller: Emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty)
                            return 'Password can\'t be empty';
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          label: Text("Password"),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: password == true
                                ? Icon(Icons.remove_red_eye_rounded)
                                : Icon(Icons.visibility_off_rounded),
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

                      // DropdownButtonFormField<String>(
                      //   value: _selectedGender,
                      //   items: ['Male', 'Female', 'Other']
                      //       .map((gender) => DropdownMenuItem<String>(
                      //     value: gender,
                      //     child: Text(gender),
                      //   ))
                      //       .toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedGender = value!;
                      //     });
                      //   },
                      //   decoration: InputDecoration(labelText: 'Gender'),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ismale = true;
                                  });
                                },
                                child: Container(height: 40,
                                  decoration: BoxDecoration(
                                      color: ismale
                                          ? Colors.deepOrange
                                          : Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // Image(
                                      //   image: AssetImage('assets/male.png'),
                                      //   height: 50,
                                      //   width: 50,
                                      // ),

                                      Text(
                                        'MALE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ismale = false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: ismale
                                          ? Colors.grey[400]
                                          : Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Image(
                                      //   image: AssetImage('assets/female.png'),
                                      //   height: 50,
                                      //   width: 50,
                                      // ),

                                      Text(
                                        'FEMALE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          labelText: 'Age',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your age';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final newUser = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: Emailcontroller.text,
                                  password: Passwordcontroller.text,
                                );
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .add({
                                  'name': _nameController.text,
                                  'age': int.parse(_ageController.text),
                                  'email': Emailcontroller.text,
                                  'gender': ismale ? 'Male' : 'Female',
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              } catch (e) {
                                print('Error: ${e.toString()}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.deepOrange,
                                      content: Text(
                                          'Failed to sign up: ${e.toString()}')),
                                );
                              }
                            }
                          },

                          // print(_nameController.text);
                          // print(int.parse(_ageController.text));
                          // print(Passwordcontroller.text);
                          // print(Emailcontroller.text);
                          // print('GENDER : ${ismale ? "Male" : "Female"}');

                          // ...
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class Custompainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =Paint();
    Path path =Path();
    paint.color=Colors.deepOrange;
    paint.style=PaintingStyle.fill;
    path.moveTo(size.width*.15, 0 );
    path.quadraticBezierTo(size.width*.5, size.height*.25, size.width*.85, 0);
    path.close();
    paint.strokeCap;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}