import 'package:flutter/material.dart';
import 'package:flutter_multi_store/controllers/auth_controller.dart';
import 'package:flutter_multi_store/utils/show_snackBar.dart';
import 'package:flutter_multi_store/vendor/views/auth/vendor_auth.dart';
import 'package:flutter_multi_store/views/auth/register_screen.dart';
import 'package:flutter_multi_store/views/buyers/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ignore: unused_field
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    // setState(() {
    //   _isLoading = true;
    // });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);

      if (res == 'Success') {
        // showSnackDialog(context, 'Login Success.');
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MainScreen();
            },
          ),
        );
      } else {
        showSnack(context, 'Login Failed. Incorrect email or password.');
      }
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
      return showSnack(context, 'Please fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login Customer Account',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please email field must not be empty';
                      } else {
                        return null;
                      }
                    },
                    onChanged: ((value) {
                      email = value;
                    }),
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please password field must not be empty';
                      } else {
                        return null;
                      }
                    },
                    onChanged: ((value) {
                      password = value;
                    }),
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _loginUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child:
                          _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                'Login',
                                style: TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Need An Account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BuyerRegisterScreen();
                            },
                          ),
                        );
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login Account Vendor',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorAuthScreen(),
                          ),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
