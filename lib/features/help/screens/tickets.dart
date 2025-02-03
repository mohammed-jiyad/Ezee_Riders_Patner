import 'package:uig/features/help/screens/ticket_form.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uig/utils/serverlink.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  List<dynamic> _tickets = []; // Stores fetched tickets
  bool _isLoading = true; // Loading state
  bool _isError = false; // Error state

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  /// Fetch tickets from the backend using the stored phone number
  Future<void> _fetchTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? phoneNumber = prefs.getString('phone_number');

      if (phoneNumber == null) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${server.link}/ticketdata/$phoneNumber'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _tickets = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _tickets = [];
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      print("Error fetching tickets: $e");
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
          ),
        ),
        title: Text(
          "Tickets",
          style: AppTextStyles.headline.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateTicketPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: ResponsiveSize.width(context, 97),
                height: ResponsiveSize.height(context, 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        width: 1,color: AppColors.primaryColor
                    )
                ),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround ,
                  children: [
                    const Icon(Icons.edit_square,color: AppColors.primaryColor,size: 15,),
                    Text("New Ticket",style: AppTextStyles.title.copyWith(
                        fontSize: 10.72,color: AppColors.primaryColor
                    ),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : _tickets.isEmpty
          ? _buildNoTicketsUI() // Show "No tickets found"
          : _buildTicketsList(), // Show tickets
    );
  }
  String convertToIST(String timestamp) {
    try {
      // Convert the timestamp string to DateTime (assuming timestamp is in UTC)
      DateTime utcTime = DateTime.parse(timestamp).toUtc();

      // Convert the UTC time to Indian Standard Time (IST)
      DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));

      // Format the IST time into a readable format
      String formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(istTime);
      return formattedTime;
    } catch (e) {
      print('Error parsing timestamp: $e');
      return "Invalid Date";
    }
  }
  /// Builds the UI for displaying tickets in a list
  Widget _buildTicketsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        var ticket = _tickets[index];
        return Card(
          color: AppColors.newColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              ticket['Title'] ?? 'Unknown Title',
              style: AppTextStyles.baseStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              ticket['body'] ?? 'No description',
              style: AppTextStyles.smalltitle,
            ),
            trailing: Text(
              convertToIST(ticket['createdAt']) ?? '',
              style: AppTextStyles.smalltitle.copyWith(color: AppColors.primaryColor),
            ),
          ),
        );
      },
    );
  }

  /// Builds the UI when no tickets are found
  Widget _buildNoTicketsUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.redColor,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            "No tickets found",
            style: AppTextStyles.smalltitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.redColor,
            ),
          ),
        ],
      ),
    );
  }
}
