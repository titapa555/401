import 'package:flutter/material.dart';  //หน้าตาแบบandroid

void main(){            //void=ไม่มีผลลัทธ์ ต้องเริ่มด้วยคำสั่ง main เสมอ
  runApp(const MyApp());    //const=ไม่เปลี่ยนค่า,ค่าคงที่
}

class MyApp extends StatelessWidget {     //stl
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: Shades(),          //home=หน้าหลัก
    );
  }
}

class Shades extends StatefulWidget {     //stf 
  const Shades({super.key});

  @override
  State<Shades> createState() => _ShadesState();
}

class _ShadesState extends State<Shades> {
  int _shades = 854321;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(                       // ()ฟังก์ชั่น {}ให้ทำอะไร
      onTapDown: (details) {
        setState(() {        //เปลี่ยนหน้าจอ
         
        });
      }, 
      onVerticalDragUpdate: (details){    // ลากไปมาแล้วให้เปลี่ยนสี 
        setState(() {
           _paint(context, details) ; 
        });

      } ,  // ลากไปมาแล้วให้เปลี่ยนสี
      child:  Scaffold(
        backgroundColor: Color(0XFF000000 + _shades),
      ),
    );
  }
  
  void _paint (context, details){
    double maxScr = MediaQuery.of(context).size.height;           //double=เลขทศนิยม   
    double yPos = details.globalPosition.dy;
    _shades = (yPos / maxScr * 16777215).round(); 
    if(_shades > 16777215) _shades = 16777215;
    print(_shades);
  }
}