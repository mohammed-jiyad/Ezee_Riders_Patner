import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'dart:typed_data';
class Profile extends StatefulWidget{
  const Profile({super.key});
  @override
  State<Profile> createState()=>_Profile();

}
class _Profile extends State<Profile> {
  String? phone_number;
  List<dynamic> data=[];
  String? imageUrl;
  String? base64String;
  @override
  void initState() {

    super.initState();
    get();

  }
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
  void get()async{
    await _getPhoneNumber();
    if (phone_number != null) {
      print('Calling Fetchdata');
      SearchUser(phone_number.toString());
    }

  }
  Future<void> _getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone_number = prefs.getString('phone_number');
    });
    // Retrieve the phone number
    print('Retrieved phone number for Earning: $phone_number'); // Print for debugging
  }
  Future<void> SearchUser(String phno) async {
    final url = '${server.link}/searchUser/$phno';
    print('Logging URL');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('data found');
      setState(() {
        data = [json.decode(response.body)]; // Store the returned user object
      });
    } else if (response.statusCode == 404) {
      print('No user found for the provided phone number');
      setState(() {
        data = []; // Empty list if no user is found
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: AppColors.blackColor,
            )),
        title: Text(
          "Profile",
          style: AppTextStyles.headline.copyWith(fontWeight: FontWeight.w600),
        ),
       centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:142,top: 40 ),
              child: Stack(
                children: [
              Container(
              height: ResponsiveSize.height(context, 100), // Container height
        width: ResponsiveSize.width(context, 100),  // Container width
        child: phone_number == null // Wait until phone_number is fetched
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<String>(
          future: RetrieveDocs(phone_number!, "profile"),
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
                    width: ResponsiveSize.width(context, 100), // Adjust size
                    height: ResponsiveSize.height(context, 100),
                  ),
                ),
              );
            }

            return Center(child: Text('No image found'));
          },
        ),
      ),
        Positioned(
                    bottom:-0,
                    
                    right:10,
                    child: Container(
                    width: ResponsiveSize.width(context,48),
                  height: ResponsiveSize.height(context,20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.backgroundColor,
                    border: Border.all(
                      color: AppColors.greytextColor,
                      width: 1, 
                    ),
                  ),child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                      "0.0",style: AppTextStyles.smalltitle.copyWith(color: AppColors.blackColor),
                      ),
                      const Icon(Icons.star,color: AppColors.yellowColor,size: 9,)
                    ],
                  ),
                  )
                  )
                ],
              ),
            ),
            Text("Rider Details",style: AppTextStyles.baseStyle.copyWith(
              color: AppColors.primaryColor,fontSize: 13.28
            ),),SizedBox(height:ResponsiveSize.height(context, 15),),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

               Text(data.isNotEmpty && data[0]['fullname'] != null
                   ? "${data[0]['fullname']}"
                   : "Full name not available",
                 style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
              SizedBox(height:ResponsiveSize.height(context, 15),),

               Text("City:  —",style: AppTextStyles.baseStyle.copyWith(
              fontSize: 13.28
              ),),
              SizedBox(height:ResponsiveSize.height(context, 15),),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Vehicle number",style: AppTextStyles.baseStyle.copyWith(
                             fontSize: 13.28
                             ),),
                      Text(data.isNotEmpty && data[0]['fullname'] != null
                          ? "${data[0]['vehiclenumber']}"
                          : "Vehicle Number not available",
                        style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                 ],
               )
                ],
              ),
            ), SizedBox(height: ResponsiveSize.height(context, 20),),
              Text("Personal Details",style: AppTextStyles.baseStyle.copyWith(
              color: AppColors.primaryColor,fontSize: 13.28
            ),),SizedBox(height:ResponsiveSize.height(context, 20),),
            Padding(
              padding: const EdgeInsets.only(left:8,right: 8 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Phone",style: AppTextStyles.baseStyle.copyWith(
                               fontSize: 13.28
                               ),),
                        Text(data.isNotEmpty && data[0]['fullname'] != null
                            ? "+91 ${data[0]['phonenumber']}"
                            : "Number not available",
                          style: AppTextStyles.baseStyle.copyWith(fontSize: 13.28),),
                   ],
                 ),
                   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Alternate phone",style: AppTextStyles.baseStyle.copyWith(
                               fontSize: 13.28
                               ),),
                      SizedBox(
                        height: ResponsiveSize.height(context, 49),
                        width: ResponsiveSize.width(context, 180),
                        child: Padding(
                   padding: const EdgeInsets.only(left: 40),
                          child: TextField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                              ),
                              hintText: "+91 1234567890",
                              hintStyle: AppTextStyles.baseStyle.copyWith(
                                fontSize: 13.28
                              ),
                              suffixIcon: const Icon(Icons.edit,size: 12,)
                            ),
                          ),
                        ),
                      ), 
                   ],
                 ),
             
               Text("DL Expiry",style: AppTextStyles.baseStyle.copyWith(
              fontSize: 13.28
              ),),
                ],
              ),
            )
          ],
        
        ),
      )
    );
  }
}