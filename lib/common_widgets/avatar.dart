import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key,required this.radius, this.photoUrl}) : super(key: key);
  final String? photoUrl; // Just make it nullable with ?
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( // decoration useful for customizing the look of Widgets
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black45,
          width: 3.0,
        )
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null, // This is the actual image of the avatar
        child: photoUrl == null ? Icon(Icons.camera_alt, size: radius) : null, // This is just a place holder if it is null
      ),
    );
  }
}
