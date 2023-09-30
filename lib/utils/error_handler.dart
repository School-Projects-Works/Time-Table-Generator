import 'package:aamusted_timetable_generator/global/widgets/custom_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ErorHandler{
  BuildContext context;
  String? message;
  ErorHandler({required this.context, this.message});
  void showError(){
    MyDialog(context: context, title: 'Error', message: message ?? 'An error occured').error();
  }
}