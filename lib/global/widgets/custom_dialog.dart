// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyDialog {
  BuildContext context;
  String? title;
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
      builder: (context) {
        return ContentDialog(
          
          title:  Text(title!),
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
    showDialog(context: context, builder: (context){
      return ContentDialog(
        title: Row(
          children: [
             const Icon(FluentIcons.check_mark, color:Colors.successPrimaryColor),
            Text(title!),
          ],
        ),
        content: Text(message),
        actions: [
          FilledButton(
            child: const Text('Ok'),
            onPressed: (){
             Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    });
  }
  error(){
    showDialog(context: context, builder: (context){
      return ContentDialog(
        title: Row(
          children: [
             const Icon(FluentIcons.error, color:Colors.errorPrimaryColor,size: 40,),
             const SizedBox(width: 15,),
            Text(title!),
          ],
        ),
        content: Text(message),
        actions: [
          FilledButton(
            child: const Text('Ok'),
            onPressed: (){
              //close dialog
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    });
  }

  loading(){
    //implement loading
    showDialog(context: context, builder: (BuildContext context){
      return ContentDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ProgressRing(),
            const SizedBox(height: 10,),
            Text(message),
          ],
        ),
      );
    });
  }
   closeLoading(){
   Navigator.of(context, rootNavigator: true).pop();
  }

  toast(){
    Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER, // Also possible "TOP" and "CENTER" 
);

  }

}
