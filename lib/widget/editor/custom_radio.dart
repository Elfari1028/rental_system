//library custom_radio_grouped_button;
import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:flutter/material.dart';

class CabinRadioField extends StatelessWidget{  
  bool enabled;
  String title;
  List<String>labels;
  List<dynamic>values;
  void Function(dynamic) onChange;
  CabinRadioField({
    @required this.enabled,
    @required this.title,
    @required this.labels,
    @required this.values,
    @required this.onChange,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Text(title,style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
      CustomRadioButton(
        buttonColor: Colors.white,
        selectedColor: Colors.brown,
        width: 75,
        height: 50,
        customShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),side: BorderSide.none),
        buttonLables: labels,
        buttonValues: values,
        enabled: enabled,
        enableShape:  true,
         horizontal: true,
         radioButtonValue: onChange,
      ),
    ],));
  }
}

class CustomRadioButton extends StatefulWidget {
  CustomRadioButton({
    this.initalIndex = 0,
    this.buttonLables,
    this.buttonValues,
    this.radioButtonValue,
    this.buttonColor,
    this.selectedColor,
    this.height = 35,
    this.width = 100,
    this.horizontal = true,
    this.enableShape = false,
    this.elevation = 10,
    this.customShape,
    this.enabled,
  })  : assert(buttonLables.length == buttonValues.length),
        assert(buttonColor != null),
        assert(selectedColor != null);

  final bool horizontal;
  final bool enabled;
  final List buttonValues;
  final int initalIndex;
  final double height;
  final double width;

  final List<String> buttonLables;

  final void Function(dynamic) radioButtonValue;

  final Color selectedColor;

  final Color buttonColor;
  final ShapeBorder customShape;
  final bool enableShape;
  final double elevation;

  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int currentSelected;
  String currentSelectedLabel;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.initalIndex;
    currentSelectedLabel = widget.buttonLables[currentSelected];
  }

  List<Widget> buildButtonsColumn() {
    List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      var button = Expanded(
        // flex: 1,
        child: Card(
          color: currentSelectedLabel == widget.buttonLables[index]
              ? widget.selectedColor
              : widget.buttonColor,
          elevation: widget.elevation,
          shape: widget.enableShape
              ? widget.customShape == null
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    )
                  : widget.customShape
              : null,
          child: Container(
            height: widget.height,
            child: MaterialButton(
              shape: widget.enableShape
                  ? widget.customShape == null
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )
                      : widget.customShape
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 0),
                      borderRadius: BorderRadius.zero,
                    ),
              onPressed:!widget.enabled?(){
                Toaster.showToast(title: "暂无权限！");
              }: () {
                widget.radioButtonValue(widget.buttonValues[index]);
                setState(() {
                  currentSelected = index;
                  currentSelectedLabel = widget.buttonLables[index];
                });
              },
              child: Text(
                widget.buttonLables[index],
                style: TextStyle(
                  color: currentSelectedLabel == widget.buttonLables[index]
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1.color,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      );
      buttons.add(button);
    }
    return buttons;
  }

  List<Widget> buildButtonsRow() {
    List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      var button = Card(
          color: currentSelectedLabel == widget.buttonLables[index]
              ? widget.selectedColor
              : widget.buttonColor,
          elevation: widget.elevation,
          shape: widget.enableShape
            ? widget.customShape == null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  )
                : widget.customShape
            : null,
          child: Container(
            height: widget.height,
            // width: 200,
            constraints: BoxConstraints(maxWidth: 250),
            child: MaterialButton(
              shape: widget.enableShape
                  ? widget.customShape == null
                      ? OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )
                      : widget.customShape
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 0),
                      borderRadius: BorderRadius.zero,
                    ),
              onPressed:!widget.enabled?(){
                Toaster.showToast( title: "暂无权限！");}: () {
                widget.radioButtonValue(widget.buttonValues[index]);
                setState(() {
                  currentSelected = index;
                  currentSelectedLabel = widget.buttonLables[index];
                });
              },
              child: Text(
                widget.buttonLables[index],
                style: TextStyle(
                  color: currentSelectedLabel == widget.buttonLables[index]
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1.color,
                  fontSize: 15,
                ),
              ),
            ),
          ),
      );
      buttons.add(button);
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.horizontal
          ?null: widget.height * (widget.buttonLables.length + 0.5),
      child: Center(
        child: widget.horizontal? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildButtonsRow(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildButtonsColumn(),
              )
            ,
      ),
    );
  }
}
