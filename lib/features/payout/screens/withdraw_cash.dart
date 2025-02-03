import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/payout/screens/payout_done.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uig/utils/serverlink.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WithdrawCash extends StatefulWidget {
  const WithdrawCash({super.key});

  @override
  State<WithdrawCash> createState() => _WithdrawCashState();
}

class _WithdrawCashState extends State<WithdrawCash> {
  String inputAmount = "";
  double withdraw=0;
  String? phone_number;
  @override
  void initState() {
    super.initState();
    Waiting();
  }

  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Retrieve the phone number
    print('Retrieved phone number: $phone_number'); // Print for debugging
  }
  void Waiting() async{
    await _getPhoneNumber();
    await withdrawfetchUser(phone_number);

  }
  Future<void> withdrawfetchUser(String? phonenumber) async {
    final response = await http.get(Uri.parse('${server.link}/withdrawfindUser/$phonenumber'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        withdraw = (data['balance'] is int) ? (data['balance'] as int).toDouble() : data['balance'];
      });

      print(withdraw);
    } else if (response.statusCode == 404) {
      print('User not found');
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
  void numberPressed(String value) {
    setState(() {
      if (value == "back") {
        if (inputAmount.isNotEmpty) {
          inputAmount = inputAmount.substring(0, inputAmount.length - 1);
        }
      } else {
        inputAmount += value;
      }
    });
  }
  String getIndianTimestamp() {

    DateTime utcTime = DateTime.now().toUtc();


    DateTime indianTime = utcTime.add(Duration(hours: 5, minutes: 30));


    return indianTime.toIso8601String();
  }
  Future<void> addFieldtoUser(String? phoneNumber) async {
    if (int.parse(inputAmount) < withdraw) {
      String timestamp = getIndianTimestamp();
      print(timestamp);
      final response = await http.post(
        Uri.parse('${server.link}/addFieldToDriver'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phonenumber': phoneNumber,
          'userData': {
            'request': int.parse(inputAmount),
            'createdAt':timestamp,
            'updatedAt':""
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['message']);
      } else {
        throw Exception('Failed to insert user');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const SizedBox(
                height: 11.31,
                width: 6.71,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF1C1B1F),
                ))),
        title: Text(
          "Withdraw",
          style: AppTextStyles.baseStyle.copyWith(fontSize: 18.72),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                "₹${withdraw} available",
                style: AppTextStyles.smalltitle
                    .copyWith(color: const Color(0xFF221E22)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Text(
                "₹${inputAmount.isEmpty ? '0' : inputAmount}",
                style: AppTextStyles.baseStyle.copyWith(
                  fontSize: 32,
                  color: inputAmount.isEmpty
                      ? const Color(0xFFD9D9D9)
                      : const Color(0xFF221E22),
                ),
              ),
            ),
            Container(
              width: 360,
              color: const Color(0xFFF7F9FF),
              // child: ListTile(
              //   visualDensity: const VisualDensity(vertical: -4),
              //   leading: Container(
              //       height: 32,
              //       width: 32,
              //       decoration: const BoxDecoration(shape: BoxShape.circle),
              //       child: const Icon(
              //         Icons.account_balance,
              //         size: 18,
              //       )),
              //   iconColor: const Color(0xFF4257D3),
              //   title: Text(
              //     "BANK OF INDIA",
              //     style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),
              //   ),
              //   subtitle:
              //   Text("XXXX 1234", style: AppTextStyles.subtitle.copyWith(fontSize: 8)),
              // ),
            ),
            Container(
              color: const Color(0xfffffffff),
              width: 329,
              height: 205,
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return const SizedBox();
                    }
                    if (index == 11) {
                      return IconButton(
                          onPressed: () => numberPressed("back"),
                          icon: const Icon(Icons.close_outlined));
                    }
                    final value = index == 10 ? "0" : "${index + 1}";
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero)),
                          backgroundColor: const Color(0xFFFFFFFF),
                        ),
                        onPressed: () => numberPressed(value),
                        child: Text(
                          value,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000)),
                        ));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (inputAmount.isEmpty || int.parse(inputAmount) <= 0 || int.parse(inputAmount)>withdraw) {

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Invalid Amount"),
                        content: const Text("Please enter a valid amount."),
                      ),
                    );
                    return;
                  }

                  addFieldtoUser(phone_number);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PayoutDone(amount:int.parse(inputAmount) ,)));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: const Color(0xFF4257D3),
                  minimumSize: const Size(320, 48),
                ),
                child: const Text(
                  "Cash Out",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
