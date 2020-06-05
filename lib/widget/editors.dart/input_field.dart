import 'package:flutter/material.dart';

class CabinInputFieldController {
  bool isModified = false;
  String initValue;
  TextEditingController controller;
  bool Function() hasError;
  CabinInputFieldController({this.initValue}) {
    controller = TextEditingController(text: initValue);
  }
  String get text => controller.text;

  void init({bool Function() getError}) {
    this.hasError = getError;
  }
}

class CabinInputField extends StatefulWidget {
  String Function(String value) makeErrorText;
  String hintText;
  CabinInputFieldController controller;
  TextInputType keyboardType;
  CabinInputField(
      {this.controller,
      this.keyboardType,
      @required this.makeErrorText,
      @required this.hintText}) {
    this.controller ??= CabinInputFieldController();
    this.keyboardType ??= TextInputType.multiline;
  }
  createState() => CabinInputFieldState();
}

class CabinInputFieldState extends State<CabinInputField> {
  String errorText = null;
  CabinInputFieldController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.init(getError: () => !(errorText == null));
  }

  @override
  Widget build(BuildContext context) => TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: errorText,
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1)),
      ),
      onChanged: (value) {
        errorText = widget.makeErrorText(value);
        controller.isModified = true;
        setState(() {});
      },
      controller: controller.controller);
}
