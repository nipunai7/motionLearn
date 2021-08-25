import 'package:flutter/material.dart';

class Profile_Widget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onclick;

  const Profile_Widget({Key key, this.imagePath, this.onclick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(children: [
        buildImage(),
        Positioned(bottom: 0, right: 4, child: buildedit(Colors.deepPurple)),
      ]),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: onclick,
          ),
        ),
      ),
    );
  }

  Widget buildedit(Color color) {
    return buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            size: 20.0,
            color: Colors.white,
          )),
    );
  }

  Widget buildCircle({Widget child, double all, Color color}) => ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          child: child,
          color: color,
        ),
      );
}
