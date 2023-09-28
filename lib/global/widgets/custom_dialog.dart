// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';

class MyDialog {
  BuildContext context;
  String title;
  String message;
  String? confirmButtonText;
  String? otherButtonText;
  VoidCallback? confirmButtonPress;
  VoidCallback? otherButtonPress;
  MyDialog({
    required this.context,
    required this.title,
    required this.message,
    this.confirmButtonText,
    this.otherButtonText,
    this.confirmButtonPress,
    this.otherButtonPress,
  });

  confirmation() {
    showDialog(
      context: context,
      builder: (_) {
        return ContentDialog(
          
          title:  Text(title),
          content:  Text(message),
          actions: [
            FilledButton(
              child:  Text(confirmButtonText??'Yes'),
              onPressed: () {
                Navigator.pop(context);
                if (confirmButtonPress != null) {
                  confirmButtonPress!.call();
                }
              },
            ),
            Button(
              child:  Text(otherButtonText??'Cancel'),
              onPressed: () {
                 Navigator.pop(context);
                if (otherButtonPress != null) {
                 
                  otherButtonPress!.call();
                }
              },
            ),
          ],
        );
      },
    );
  }
  success(){


  }
  error(){

  }

}
