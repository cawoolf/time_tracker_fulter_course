import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {

  FormSubmitButton({super.key, required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,}) :
        super(child: Text(text, style: TextStyle(color: textColor, fontSize: 20.0)),
          color: color,
          onPressed: onPressed,
          borderRadius: 6.0);

}
