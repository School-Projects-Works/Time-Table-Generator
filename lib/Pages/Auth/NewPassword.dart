// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Components/SmartDialog.dart';
import 'package:aamusted_timetable_generator/Components/TextInputs.dart';
import 'package:aamusted_timetable_generator/Models/Admin/Admin.dart';
import 'package:aamusted_timetable_generator/SateManager/HiveCache.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../SateManager/NavigationProvider.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String? newPassword;
  String? confirmPassword;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * .4,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'You Logged in for the first time with a default Password. The system require that you set a new Password Please set a new password. Note that the new password must be at least 6 characters long and must contain at least one number and one special character.',
                style: GoogleFonts.nunito(),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: CustomTextFields(
                  label: 'New Password',
                  obscureText: _obscureText,
                  validator: (p0) {
                    if (p0!.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onChanged: (p0) {
                    setState(() {
                      newPassword = p0;
                    });
                  },
                  onSaved: (p0) {
                    setState(() {
                      newPassword = p0;
                    });
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: CustomTextFields(
                  label: 'Confirm Password',
                  obscureText: _obscureText,
                  validator: (p0) {
                    if (p0 != newPassword) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                  onChanged: (p0) {
                    setState(() {
                      confirmPassword = p0;
                    });
                  },
                  onSaved: (p0) {
                    setState(() {
                      confirmPassword = p0;
                    });
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: CustomButton(
                    onPressed: setNewPassword, text: 'Set Password'),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void setNewPassword() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CustomDialog.showLoading(message: 'Setting New Password');
      Admin admin = HiveCache.getAdmin()!;
      admin.password = newPassword;
      HiveCache.setAdmin(admin);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        message: 'Password Changed Successfully',
      );
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentIndex(0);
    }
  }
}
