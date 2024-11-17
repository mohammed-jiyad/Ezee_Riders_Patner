import 'package:bikeapp/Registration/DrivingLicenseScreen.dart';
import 'package:bikeapp/Registration/Registration.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
class DocumentsSubmittedPage extends StatelessWidget {
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
              child:  Image.network(
                'https://s3-alpha-sig.figma.com/img/be7b/48a5/1826d6fdc892aa501f37ac8fb16062bd?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=YB9Ggrm4jBAZ5Rp1swc24i9S8lMkJZjca2ZAiRHN9WF3GMTkh7KNwzhvra4-7SnUokt103tYYI7SisWSZzAzcBUHKMpPUH6ps~3mMSNgwA78HDM~3o0ELMK-xWvn9dhPOBCC9E4nFurcSlcWVkfubO30b0khkhLuLg8jkUJNZy8UX~HKrgzXhuT-iAspgD34hLIdMQvZD96Qr6ieIFF3B3JIbZQDok6wNlOG4UHzwPKeHA5Fpp924tYzmx1do4OZRO3CQwNBS6VhyC39QC2l2UXFMv0qf~szxEBKgg2ZJPZXU-N0nSSd5J9HcC1L5~QZ-CBrWmZulFIQcHjgqUoc4g__',
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
              'You will get a verification call on your registered phone number +91 123345567',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 287,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to the previous page
                },
                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.indigoAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Go back',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}