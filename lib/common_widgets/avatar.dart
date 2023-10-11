import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key,required this.radius, this.photoUrl}) : super(key: key);
  final String? photoUrl; // Just make it nullable with ?
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black12,
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null ? Icon(Icons.camera_alt, size: radius) : null,
    );
  }
}
