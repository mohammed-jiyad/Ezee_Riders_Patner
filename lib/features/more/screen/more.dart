import 'package:uig/features/documents/screens/documents.dart';
import 'package:uig/features/emergency_contact/screens/emergency_contact.dart';
import 'package:uig/features/more/widgets/custom_list_tile.dart';
import 'package:uig/features/my_vehicles/screens/my_vehicles.dart';
import 'package:uig/features/profile/profile.dart';
import 'package:uig/features/trip_activity/screens/trip_activity.dart';
import 'package:uig/main.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:uig/utils/serverlink.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  var _isSwitched = false;
  String? PhoneNumber;
  String? Name;
  String? imageUrl;
  String? base64String;
  var _isSwitched2 = false;
  Future<String> RetrieveDocs(String phno, String Name) async {
    final response = await http.get(
      Uri.parse('${server.link}/fetchFileForUser?phoneNumber=$phno&uploadTitle=$Name'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Debugging the response

      // Assuming the backend returns the Base64 string in 'fileData'
      final base64Str = data; // Adjust this based on your backend response

      return base64Str;
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to fetch file');
    }
  }
  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const HelpScreen();
        });
  }

  @override
  void initState() {
    wait();
    super.initState();
  }

  void wait() async {
    await getUserdata();
  }

  Future<void> getUserdata() async {
    final prefs = await SharedPreferences.getInstance();
    PhoneNumber = prefs.getString('phone_number');
    print(PhoneNumber);
    Name = prefs.getString('DriverName');
    print(Name);
    setState(() {
      PhoneNumber = prefs.getString('phone_number');
      Name = prefs.getString('DriverName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: Container(
                height: ResponsiveSize.height(context, 126),
                width: ResponsiveSize.width(context, 340),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    border: Border.all(
                      width: ResponsiveSize.width(context, 1),
                      color: AppColors.boxColor,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Container(
                      color: AppColors.purplebackground,
                      height: ResponsiveSize.height(context, 70),
                      width: ResponsiveSize.width(context, 340),
                      child: ListTile(
                        textColor: AppColors.newgreyColor,
                        leading: Container(
                          height: ResponsiveSize.height(context, 50), // Container height
                          width: ResponsiveSize.width(context, 50),  // Container width
                          child: PhoneNumber == null // Wait until phone_number is fetched
                              ? Center(child: CircularProgressIndicator())
                              : FutureBuilder<String>(
                            future: RetrieveDocs(PhoneNumber!, "profile"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.hasData) {
                                // Decode the Base64 string to bytes
                                final bytes = base64Decode(snapshot.data!);

                                return Center(
                                  child: ClipOval(  // Clip to make it circular
                                    child: Image.memory(
                                      Uint8List.fromList(bytes),
                                      fit: BoxFit.cover,  // Ensure the image fills the circle
                                      width: ResponsiveSize.width(context, 50), // Adjust size
                                      height: ResponsiveSize.height(context, 50),
                                    ),
                                  ),
                                );
                              }

                              return Center(child: Text('No image found'));
                            },
                          ),
                        ),
                        title:  Text(
                          "$Name",
                          style: AppTextStyles.baseStyle,
                        ),
                        subtitle: Text(
                          "ER1234958",
                          style: AppTextStyles.subtitle,
                        ),
                        trailing: Container(
                          height: ResponsiveSize.height(context, 17),
                          width: ResponsiveSize.width(context, 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.backgroundColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "0.0",
                                style: AppTextStyles.subtitle,
                              ),
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD600),
                                size: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.height(context, 11),
                        vertical: ResponsiveSize.height(context, 12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.ad_units,
                                size: 12,
                                color: Color(0xFF818587),
                              ),
                              const SizedBox(width: 5),
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.subtitle,
                                  children: [
                                    TextSpan(
                                      text: "Phone:",
                                      style: AppTextStyles.smalltitle
                                          .copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(text: " $PhoneNumber"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     const Icon(
                          //       Icons.location_on,
                          //       size: 12,
                          //       color: Color(0xFF818587),
                          //     ),
                          //     const SizedBox(width: 5),
                          //     // RichText(
                          //     //   text: TextSpan(
                          //     //     style: AppTextStyles.smalltitle,
                          //     //     children: [
                          //     //       TextSpan(
                          //     //         text: "Zone: ",
                          //     //         style: AppTextStyles.smalltitle
                          //     //             .copyWith(fontWeight: FontWeight.w500),
                          //     //       ),
                          //     //       const TextSpan(text: "Zone: Raipur"),
                          //     //     ],
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveSize.height(context, 12),
            ),
            Container(
              height: ResponsiveSize.height(context, 552),
              width: ResponsiveSize.width(context, 340),
              decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  border: Border.all(
                    width: ResponsiveSize.width(context, 1),
                    color: AppColors.boxColor,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  // CustomListTile(
                  //   icon: const Icon(Icons.abc),
                  //   text: "Auto accept",
                  //   trailing: Switch(
                  //     activeColor: AppColors.primaryColor
                  //     ,
                  //     value: _isSwitched2,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _isSwitched2 = value;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // CustomListTile(
                  //   // onTap: () {
                  //   //   Navigator.push(
                  //   //       context, MaterialPageRoute(builder: (context) =>
                  //   //   const MyRouteBooking()));
                  //   // },
                  //   icon: const Icon(Icons.merge),
                  //   text: "My Route Booking",
                  //   trailing: Switch(
                  //     activeColor: AppColors.primaryColor,
                  //     value: _isSwitched,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _isSwitched = value;
                  //       });
                  //     },
                  //   ),
                  // ),
                 CustomListTile(
                    coming:false,
                    onTap:(){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                      const Profile()));
                    },
                      icon: Icon(Icons.account_circle_outlined),
                      text: "Manage profile",
                      trailing: SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10,))),
                  CustomListTile(
                      coming: false,
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                        const TripActivity()));
                      },
                      icon: const Icon(Icons.sports),
                      text: "Trip Activity",
                      trailing: const SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10))),
                  CustomListTile(
                    coming: false,
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                        const Documents()));
                      },
                      icon: const Icon(Icons.contact_page_outlined),
                      text: "Documents",
                      trailing: const SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10))),
                  CustomListTile(
                    coming: false,
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                        const MyVehicles()));
                      },
                      icon: const Icon(Icons.two_wheeler_outlined),
                      text: "Vehicles",
                      trailing: const SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10))),
                  const CustomListTile(
                    coming: true,
                      icon: Icon(Icons.percent),
                      text: "Offers",
                      trailing: SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10))),
                  CustomListTile(
                    coming: true,
                      // onTap: () {
                      //   Navigator.push(
                      //       context, MaterialPageRoute(builder: (context) =>
                      //   const BankDetails()));
                      // },


                      icon: const Icon(Icons.assured_workload_outlined),
                      text: "Bank details",
                      trailing: const SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10))),
                  // const CustomListTile(
                  //   coming: true,
                  //     icon: Icon(Icons.image),
                  //     text: "Videos for you",
                  //     trailing: SizedBox(
                  //         height: 10, width: 6.17,
                  //         child: Icon(Icons.arrow_forward_ios, size: 10))),
                  CustomListTile(
                      coming: false,
                      onTap: () {
                       Navigator.push(
                                                context, MaterialPageRoute(builder: (context) =>
                                            EmergencyContact()));
                      },


                      icon: Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColors.newColor),
                          child: const Icon(Icons.sos)),
                      text: "Emergency Contact",
                      trailing: const SizedBox(
                          height: 10, width: 6.17,
                          child: Icon(Icons.arrow_forward_ios, size: 10))),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context, MaterialPageRoute(builder: (context) =>
                  //     EmergencyContact()));
                  //   },
                  //   iconColor: AppColors.secondaryColor,
                  //   leading: Container(
                  //       height: 28,
                  //       width: 28,
                  //       decoration: const BoxDecoration(
                  //           shape: BoxShape.circle, color: AppColors.newColor),
                  //       child: const Icon(Icons.sos)),
                  //   title: const Text(
                  //     "Emergency Contact",
                  //     style: AppTextStyles.baseStyle,
                  //   ),
                  // ),
                  SizedBox(height: ResponsiveSize.height(context, 10),),
                  ListTile(

                    iconColor: AppColors.redColor,

                    leading: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.newColor),
                        child: const Icon(Icons.logout)),
                    title: InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>PhoneLoginScreen()));
                      },
                      child: Text(
                        "Log out",
                        style: AppTextStyles.baseStyle,
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50,left: 20),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          const url = 'www.google.com'; // Your URL
                          try {
                            final Uri uri = Uri.parse(url);
                            // Check if the URL can be launched
                            bool canLaunchUrlResult = await canLaunchUrl(uri);
                            print('Can Launch URL: $canLaunchUrlResult'); // Should print true if it's launchable

                            if (canLaunchUrlResult) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication); // Launch URL in external app (browser)
                            } else {
                              throw 'Could not launch $url';
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        }
                        ,
                        child: Text(
                          'Powered By UigGeeks',
                          style: TextStyle(color: AppColors.newgreyColor, fontSize: 16),
                        ),
                      )


                    ),
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
