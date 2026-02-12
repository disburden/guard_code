import 'package:guard_code/public/application.dart'; 
import 'package:flutter/material.dart'; 
import 'package:guard_code/public/style/style.dart'; 
 
 
/// 基本按钮 
class AppBaseButtonStyle extends StatelessWidget { 
  final String text; 
  final VoidCallback onPressed; 
  final Color bgColor; 
  final double textSize; 
  final double height; 
 
  AppBaseButtonStyle( 
      {required this.text, 
      required this.onPressed, 
      this.bgColor = const Color(0x33000000), 
      this.textSize = 16.0, 
      this.height = 40.0}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      child: Row( 
        children: <Widget>[ 
          Expanded( 
            child: SizedBox( 
              height: height, 
              child: ElevatedButton( 
                onPressed: onPressed, 
                style: ElevatedButton.styleFrom( 
                  backgroundColor: bgColor, 
                  shape: RoundedRectangleBorder( 
                    borderRadius: BorderRadius.circular(4.0), 
                  ), 
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
                ), 
                child: Text( 
                  text, 
                  style: TextStyle( 
                    fontSize: textSize, 
                    color: Colors.white, 
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
 
/// 按钮样式 01
class AppMainButton extends AppBaseButtonStyle {
  AppMainButton({
    required String text,
    required VoidCallback onPressed,
    double height = 40.0,
  }) : super(
         text: text,
         onPressed: onPressed,
         bgColor: Theme.of(appContext).appColorStyle.primaryColor,
         height: height,
       );
}

/// 按钮样式 02
class AppSecondButton extends AppBaseButtonStyle {
  AppSecondButton({
    required String text,
    required VoidCallback onPressed,
    double height = 40.0,
  }) : super(
         text: text,
         onPressed: onPressed,
         bgColor: Theme.of(appContext).appColorStyle.primaryColor,
         height: height,
       );
}
