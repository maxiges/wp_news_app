import 'package:WP_news_APP/Utils/ColorPicker.dart' as ColorsPicker;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../Globals.dart';
import '../Class/WebPortal.dart';
import '../Utils/ColorsFunc.dart';

import 'package:toast/toast.dart';

// create some values
Color pickerColor = Colors.black;
Color currentColor = Colors.black;
String actUrl = "";

_changeColor(Color newColor) {
  currentColor = newColor;
}

BoxDecoration buttonDecor(Color back) {
  return BoxDecoration(
    color: back,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      width: 2,
      color: Colors.black38,
    ),
  );
}

double _getMaxDialogSize(context) {
  {
    if ((MediaQuery.of(context).size.height) > 480) {
      return 480.0;
    } else {
      return MediaQuery.of(context).size.height;
    }
  }
}

Future<bool> settingAddPageShowDialog(WebPortal web, dynamic context) async {
  pickerColor = web.getColor();
  currentColor = web.getColor();
  actUrl = web.url;
  String dropdownValue = getPortalTypeString(web.portalType);
  int dropdownValueNumber = 5;


  // List of items in our dropdown menu
  var items = getPortalTypeStringList();
  List<int> valuePicker = [5,10,15];

  List<String> recomendedWebsides = ["","android.com.pl","niebezpiecznik.pl", "prawo.pl", "golangnews.com", "tabletowo.pl"  ];

  String pickerChangeURL = recomendedWebsides[0];
  var textController = new TextEditingController(text: actUrl);

  StateSetter _setState;
  bool? shouldUpdate = await showDialog(
      context: context,
      builder: (context) {
        return (new AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              _setState = setState;
              return Container(
                  height: _getMaxDialogSize(context),
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(10)),
                    color: GlobalTheme.backgroundDialog,
                  ),
                  child: ListView(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    shrinkWrap: true,
                    //just set this property
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: 5, left: 0, right: 0, top: 0),
                        child: TextFormField(
                          controller: textController,
                          style: TextStyle(color: GlobalTheme.textColor),
                          decoration: InputDecoration(
                            icon: Icon(Icons.bookmark_border),
                            hintText: '',
                            labelText: 'Click and write http://',
                            labelStyle: TextStyle(color: GlobalTheme.textColor),
                            counterStyle:
                                TextStyle(color: GlobalTheme.textColor),
                            errorStyle: TextStyle(color: GlobalTheme.textColor),
                            hintStyle: TextStyle(color: GlobalTheme.textColor),
                            helperStyle:
                                TextStyle(color: GlobalTheme.textColor),
                          ),
                          onSaved: (String? value) {
                            actUrl = value!;
                          },
                          onChanged: (String value) {
                            actUrl = value;
                          },
                          validator: (String? value) {
                            if (value!.length < 2) return "URL is too short";
                            if (!value.contains("."))
                              return "No prefix ex.  .pl .org .com ";
                            return null;
                          },
                        ),
                      ),
                      Wrap(
                        runAlignment: WrapAlignment.end,
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        direction: Axis.horizontal,
                        spacing: 20,
                        children: [
                          DropdownButton(
                            style: TextStyle(color: GlobalTheme.textColor),
                            dropdownColor: GlobalTheme.backgroundDialog,
                            // Initial Value
                            value: pickerChangeURL,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of valuePicker
                            items: recomendedWebsides.map((String valuePicker) {
                              return DropdownMenuItem(
                                value: valuePicker,
                                child: Text(
                                    style:
                                    TextStyle(color: GlobalTheme.textColor),
                                    ""+valuePicker.toString()),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              if(newValue ==null){
                                return;
                              }
                              _setState(() {
                                actUrl = newValue;
                                pickerChangeURL = newValue;
                                final updatedText =  newValue;
                                textController.value = textController.value.copyWith(
                                  text: updatedText,
                                  selection: TextSelection.collapsed(offset: updatedText.length),
                                );
                              });
                            },
                          ),
                          DropdownButton(
                            style: TextStyle(color: GlobalTheme.textColor),
                            dropdownColor: GlobalTheme.backgroundDialog,
                            // Initial Value
                            value: dropdownValueNumber,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of valuePicker
                            items: valuePicker.map((int valuePicker) {
                              return DropdownMenuItem(
                                value: valuePicker,
                                child: Text(
                                    style:
                                    TextStyle(color: GlobalTheme.textColor),
                                    ""+valuePicker.toString()),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (int? newValue) {
                              if(newValue ==null){
                                return;
                              }
                              _setState(() {
                                dropdownValueNumber = newValue;
                              });
                            },
                          ),
                          DropdownButton(
                            style: TextStyle(color: GlobalTheme.textColor),
                            dropdownColor: GlobalTheme.backgroundDialog,
                            // Initial Value
                            value: dropdownValue,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                    style:
                                        TextStyle(color: GlobalTheme.textColor),
                                    items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              _setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          ),
                          Container(
                            width: 10,
                            height: 10,
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30, top: 15),
                        child: ColorsPicker.ColorPicker(
                          colorPalette.values.toList(),
                          _changeColor,
                          initColor: currentColor,
                          maxRow: MediaQuery.of(context).size.width ~/ 60,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              margin: new EdgeInsets.only(
                                  top: 20, left: 0, right: 0),
                              decoration: buttonDecor(Colors.greenAccent),
                              child: TextButton(
                                child: new Text(
                                  "Add/Edit",
                                  style: TextStyle(
                                      color: Color_getColorText(
                                          Colors.greenAccent)),
                                ),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              margin: new EdgeInsets.only(
                                  top: 20, left: 5, right: 5),
                              decoration: buttonDecor(GlobalTheme.textColor),
                              child: TextButton(
                                child: new Text(
                                  "Cancel",
                                  style:
                                      TextStyle(color: GlobalTheme.background),
                                ),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ));
            })));
      });

  try {
    if (shouldUpdate == true) {
      if (actUrl.length < 3 ||
          currentColor == null ||
          currentColor == Colors.transparent) {
        if (actUrl.length < 3) {
          Toast.show("No add/edit page\r\nUrl is too short",
              duration: Toast.lengthLong, gravity: Toast.bottom);
        } else {
          Toast.show("No add/edit page\r\nColor wasn't choose",
              duration: Toast.lengthLong, gravity: Toast.bottom);
        }
        return false;
      }

      for (WebPortal readWeb in Global_webList) {
        if (readWeb.url == actUrl && actUrl.length > 2) {
          readWeb.decColor = Color_GetColorInString(currentColor);
          web.portalType = getPortalTypeFromString(dropdownValue);
          web.articlesRead = dropdownValueNumber;
          webPortalSaveWebs(Global_webList);
          return true;
        }
      }
      web.url = actUrl;
      web.decColor = Color_GetColorInString(currentColor);
      web.portalType = getPortalTypeFromString(dropdownValue);
      web.articlesRead = dropdownValueNumber;
      Global_webList.add(web);
      webPortalSaveWebs(Global_webList);
      return true;
    }
    if (shouldUpdate == null) {
      return false;
    }
    return shouldUpdate;
  } catch (ex) {
    return false;
  }
}
