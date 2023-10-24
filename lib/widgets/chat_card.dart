import 'package:chat_application/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.name,
    required this.imgUrl,
    required this.onPressed,
  });
  final String imgUrl;
  final String name;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imgUrl),
            ),
            Gap(),
            Text(
              name,
              style: GoogleFonts.sourceCodePro(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
