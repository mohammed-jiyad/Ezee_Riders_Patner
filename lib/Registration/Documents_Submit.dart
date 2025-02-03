
import 'package:flutter/material.dart';

class DocumentsSubmittedPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child:  Image.asset(
                'assets/newimage.png',
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Documents Submitted!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You can use the Application Once your details get verified by the Admin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            // Container(
            //   width: 287,
            //   height: 42,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).pop(); // Navigate back to the previous page
            //     },
            //     style: ElevatedButton.styleFrom(
            //
            //       backgroundColor: Colors.white,
            //       side: BorderSide(color: Colors.indigoAccent),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: Text(
            //       'Go back',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.indigoAccent,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
