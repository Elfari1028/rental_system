import 'package:cabin/widget/editor/custom_radio.dart';
import 'package:flutter/material.dart';

class CabinInputFieldController {
  bool isModified = false;
  String initValue;
  TextEditingController controller;
  bool hasError = false;
  CabinInputFieldController({this.initValue}) {
    controller = TextEditingController(text: initValue);
  }
  String get text => controller.text;

  // void init({Function getError}) {
  //   this.hasError = getError;
  // }
}

class CabinInputField extends StatefulWidget {
  String Function(String value) makeErrorText;
  String title;
  String hintText;
  int maxLines;
  bool obscure;
  bool enabled;
  CabinInputFieldController controller;
  TextInputType keyboardType;
  CabinInputField(
      {this.controller,
      this.keyboardType,
      this.maxLines,
      this.obscure = false,
      this.enabled = true,
      @required this.title,
      @required this.makeErrorText,
      this.hintText}) {
    this.controller ??= CabinInputFieldController();
    this.keyboardType ??= TextInputType.multiline;
    this.title = this.title + "  ";
    if(this.obscure == true)
      this.maxLines =1;
  }
  createState() => CabinInputFieldState();
}

class CabinInputFieldState extends State<CabinInputField> {
  String errorText;
  CabinInputFieldController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    // controller.init(getError: () => !(errorText == null));
  }

  @override
  Widget build(BuildContext context) {
    controller.hasError = (errorText != null);
    return Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
            minLines: 1,
            maxLines: widget.maxLines,
            obscureText: widget.obscure,
            enabled: widget.enabled,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixText: widget.title,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.brown)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey[300])),
              errorText: errorText,
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2)),
            ),
            onChanged: (value) {
              errorText = widget.makeErrorText(value);
              controller.isModified = true;
              setState(() {});
            },
            controller: controller.controller));
  }
}
