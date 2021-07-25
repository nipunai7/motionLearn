import 'package:e_shop/User/user.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final User user;
  const NumbersWidget({Key key,this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildButton(context, user.totReports, 'Reports'),
            divider(),
            buildButton(context, user.totpurtutes, 'Purshases'),
            divider(),
            buildButton(context, user.totSpent, 'Total Spent')
          ],
        ),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Widget divider() => Container(
      height: 24,
      child: VerticalDivider(
        color: Colors.deepPurple,
        thickness: 1.4,
      ));
}
