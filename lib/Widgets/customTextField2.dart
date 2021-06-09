import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget
{
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  final String value;



  CustomTextField2(
      {Key key, this.controller, this.data, this.hintText,this.isObsecure,this.value}
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: TextEditingController(text: value),
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.deepPurple,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
