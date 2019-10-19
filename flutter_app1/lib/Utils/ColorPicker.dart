
import 'package:flutter/material.dart';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';





class ColorPicker  extends StatefulWidget {

   List<Color> ColorList;
   Color initColor;
   double p_width;
   double p_hight;
  var function_set;
  int MaxinRow;

  ColorPicker(List<Color> ColorList , Function setColor(Color color) , {Color initColor =Colors.black ,double p_width =50 , double p_hight = 50  , int MaxinRow = 5 } ){
    this.ColorList = ColorList;
    this.initColor = initColor;
    this.p_width = p_width;
    this.p_hight = p_hight;
    this.function_set = setColor;
    this.MaxinRow = MaxinRow;
  }






  @override
  _ColorPicker createState() => _ColorPicker();

}

class _ColorPicker extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {

List<Widget> m_colorsWi = new List<Widget>();


for(Color acCol in widget.ColorList)
{
Color m_thisIsSet = Colors.transparent;
if(widget.initColor == acCol)
{
  if(widget.initColor.computeLuminance()>0.3)
    {
      m_thisIsSet = Colors.black;
    }
  else
    {
      m_thisIsSet = Colors.white;
    }

}
m_colorsWi.add(

Container(
width: widget.p_width,
height:widget.p_hight ,
    margin:new EdgeInsets.all(5),
child:
GestureDetector(
onTap: (){
setState(() {
  widget.function_set(acCol);

  widget.initColor = acCol;
});

},
child:  Container(

decoration: new BoxDecoration(
color: acCol,
borderRadius: new BorderRadius.all(  Radius.circular(50)   ),

),
child: Icon(
Icons.check,
color: m_thisIsSet,
size: 20.0,
),

)

)
));


}


List<Widget> m_colorsWiRows = new List<Widget>();

for( int i = 0 ; i < m_colorsWi.length ; i+=widget.MaxinRow)
  {
    int avalable = widget.MaxinRow;
if( m_colorsWi.length -i < widget.MaxinRow) {
  avalable = m_colorsWi.length - i;
}


    m_colorsWiRows.add(
      Padding(
        padding: EdgeInsets.all(8.0),
        child:Row(



mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize:MainAxisSize.min,
      children:  m_colorsWi.sublist(i , i+avalable)
    ),
      )
    );



  }

return(
Container( child:  Column(

  mainAxisAlignment: MainAxisAlignment.spaceBetween,
children:m_colorsWiRows,
)
)

);




  }


}




