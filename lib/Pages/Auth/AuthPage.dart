// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Components/TextInputs.dart';
import 'package:aamusted_timetable_generator/Models/Admin/Admin.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:aamusted_timetable_generator/SateManager/NavigationProvider.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Components/CustomButton.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * .6,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                  child: Container(
                height: size.height * .55,
                decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Welcome to',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                              angle: 6.1,
                              child: Text(
                                'A',
                                style: GoogleFonts.adamina(
                                    fontSize: 60, fontWeight: FontWeight.w700),
                              )),
                          Text(
                            'Tt',
                            style: GoogleFonts.pacifico(
                                fontSize: 60,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          Transform.rotate(
                              angle: 6.1,
                              child: Text(
                                'G',
                                style: GoogleFonts.russoOne(
                                    fontSize: 60,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ))
                        ],
                      ),
                      Text('Aamusted Timetable Generator',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.4),
                            borderRadius: BorderRadius.circular(10)),
                        child: RichText(
                            text: TextSpan(
                                text: 'Notice: ',
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                text:
                                    'By default the administrator username is "admin" and the password is "admin". You will be required to set a new password after logging in for the first time.',
                                style: GoogleFonts.nunito(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              )
                            ])),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.4),
                            borderRadius: BorderRadius.circular(10)),
                        child: RichText(
                            text: TextSpan(
                                text: 'Notice: ',
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                text:
                                    'This is a beta version of the app. Please report any bugs to the developer.',
                                style: GoogleFonts.nunito(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              )
                            ])),
                      )
                    ],
                  ),
                ),
              )),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('LOGIN',
                          style: GoogleFonts.alfaSlabOne(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w500)),
                      const Divider(
                        color: secondaryColor,
                        thickness: 10,
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: CustomTextFields(
                          label: 'Username',
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _username = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: CustomTextFields(
                          label: 'Password',
                          prefixIcon: Icons.lock,
                          obscureText: _obscureText,
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            disabledColor: Colors.grey,
                            highlightColor: primaryColor,
                            focusColor: primaryColor,
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: CustomButton(
                          text: 'Log in',
                          onPressed: signIn,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Admin admin = HiveCache.getAdmin()!;
      if (admin.name!.toLowerCase() == _username!.toLowerCase() &&
          admin.password == _password) {
        if (_password == '123456') {
          Provider.of<NavigationProvider>(context, listen: false)
              .setCurrentIndex(2);
        } else {
          HiveCache.saveIsLoggedIn(true);
          Provider.of<NavigationProvider>(context, listen: false)
              .setCurrentIndex(1);
        }
      } else {
        CustomDialog.showError(message: 'Invalid username or password');
      }
    }
  }
}
