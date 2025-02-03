import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/features/earning/screens/earning.dart';
import 'package:uig/features/explore/screens/explore.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:uig/features/more/screen/more.dart';
import 'package:uig/features/payout/screens/payout.dart';
import 'package:uig/features/trips/screens/trip.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineState extends StatefulWidget {
  const OnlineState({super.key});

  @override
  State<OnlineState> createState() => _OnlineStateState();
}

class _OnlineStateState extends State<OnlineState> {
  bool _isSwitched = false;
  int myIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadOnlineStatus();
  }

  Future<void> _loadOnlineStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = prefs.getBool('isOnline') ?? false;
    });
  }

  Future<void> _setOnlineStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnline', status);
  }

  final List<Widget> screens = [
    const ExploreScreen(),

    const EarningScreen(),
    const PayOutScreen(),
    const MoreScreen(),
  ];

  void _onTapItem(int index) {
    setState(() {
      myIndex = index;
    });
  }

  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const HelpScreen();
      },
    );
  }

  void _showDialogebox(bool turningOn) {
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Builder(builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              content: SizedBox(
                height: ResponsiveSize.height(context, 197),
                width: ResponsiveSize.width(context, 340),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset(turningOn ? 'assets/images/green.png' : 'assets/images/red.png'),
                        SizedBox(height: ResponsiveSize.height(context, 5)),
                        Text(
                          turningOn ? 'Go Online again?' : 'Go Offline?',
                          style: turningOn ? AppTextStyles.headline2 : AppTextStyles.headline3,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 5)),
                    Text(
                      turningOn
                          ? 'After going online you will receive new ride requests'
                          : 'After going offline you will not receive new ride requests',
                      style: AppTextStyles.smalltitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 30)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: ResponsiveSize.height(context, 42),
                            width: ResponsiveSize.width(context, 100),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style: AppTextStyles.baseStyle2.copyWith(color: AppColors.newgreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveSize.height(context, 42),
                            width: ResponsiveSize.width(context, 100),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: turningOn ? AppColors.greenColor : AppColors.redColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSwitched = turningOn;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Yes',
                                style: AppTextStyles.baseStyle2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body:  IndexedStack(
        index: myIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        color: AppColors.backgroundColor,
        width: ResponsiveSize.width(context, 360),
        height: ResponsiveSize.height(context, 97),
        child: BottomNavigationBar(
            onTap: _onTapItem,
            currentIndex: myIndex,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.greytextColor,
            unselectedLabelStyle: AppTextStyles.subtitle.copyWith(fontSize: 8),
            selectedLabelStyle: AppTextStyles.subtitle
                .copyWith(fontSize: 10.5, color: AppColors.primaryColor),
            items: const [
              BottomNavigationBarItem(
                  backgroundColor: AppColors.backgroundColor,
                  icon: Icon(Icons.explore),
                  label: 'Explore'),
              // BottomNavigationBarItem(
              //     backgroundColor: AppColors.backgroundColor,
              //     icon: Icon(Icons.two_wheeler_outlined),
              //     label: 'Trips'),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.backgroundColor,
                  icon: Icon(Icons.currency_rupee_rounded),
                  label: 'Earning'),
              BottomNavigationBarItem(
                  backgroundColor: AppColors.backgroundColor,
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Payout'),
              BottomNavigationBarItem(
                backgroundColor: AppColors.backgroundColor,
                icon: Icon(Icons.menu),
                label: 'More',
              )
            ]),
      ),

    );
  }
}