import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Utils/ColorsFunc.dart';
class ColorPicker extends StatefulWidget {
  List<Color> _colorList;
  Color _initColor;
  double _width;
  double _hight;
  var _setColorFunction;
  int _maxinRow;

  ColorPicker(List<Color> colorList, Function setColor(Color color),
      {Color initColor = Colors.black,
      double width = 50,
      double hight = 50,
      int maxRow = 5}) {
    this._colorList = colorList;
    this._initColor = initColor;
    this._width = width;
    this._hight = hight;
    this._setColorFunction = setColor;
    this._maxinRow = maxRow;
  }

  @override
  _ColorPicker createState() => _ColorPicker();
}

class _ColorPicker extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _colorsWidgetList = new List<Widget>();

    for (Color acCol in widget._colorList) {
      Color _thisColorIsPicked = Colors.transparent;
      if (widget._initColor == acCol) {
        _thisColorIsPicked = Color_getColorText(acCol);
      }

      Color _frameColor = Color_getColorText(acCol);
      
      _colorsWidgetList.add(
           Container(
               child:Container(
          width: widget._width,
          height: widget._hight,
          margin: new EdgeInsets.all(5),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  widget._setColorFunction(acCol);

                  widget._initColor = acCol;
                });
              },
              child: Container(
                padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: _frameColor,
                    borderRadius: new BorderRadius.all(Radius.circular(50)),
                  ),
              child: Container(
                decoration: new BoxDecoration(
                  color: acCol,
                  borderRadius: new BorderRadius.all(Radius.circular(50)),
                ),
                child: Icon(
                  Icons.check,
                  color: _thisColorIsPicked,
                  size: 20.0,
                ),
              ))
          )

          )));
    }

    List<Widget> _colorsWidgetRowsList = new List<Widget>();

    for (int i = 0; i < _colorsWidgetList.length; i += widget._maxinRow) {
      int avalable = widget._maxinRow;
      if (_colorsWidgetList.length - i < widget._maxinRow) {
        avalable = _colorsWidgetList.length - i;
      }

      _colorsWidgetRowsList.add(Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: _colorsWidgetList.sublist(i, i + avalable)),
      ));
    }

    return (Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _colorsWidgetRowsList,
    )));
  }
}
