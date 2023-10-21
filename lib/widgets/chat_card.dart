import 'package:chat_application/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.name, required this.imgUrl});
final String imgUrl;
final String name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: ElevatedButton(
        onPressed: () {
          // Handle user item click
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imgUrl),
            ),
            Gap(),
            Text(
              name,
              style: GoogleFonts.openSans(
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
