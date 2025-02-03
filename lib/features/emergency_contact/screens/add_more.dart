import 'package:uig/features/emergency_contact/widgets/delete_contacts.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class AddMore extends StatefulWidget {
  final List<Map<String, String>> selectedContacts;

  const AddMore({super.key, required this.selectedContacts});

  @override
  State<AddMore> createState() => _AddMoreState();
}

class _AddMoreState extends State<AddMore> {
  void _deleteEmergencyContact(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const DeleteContacts();
        });
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
              icon: const Icon(Icons.arrow_back_ios)),
          title: Text(
            "Emergency contact",
            style: AppTextStyles.baseStyle
                .copyWith(fontWeight: FontWeight.w600, fontSize: 18.72),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: ResponsiveSize.height(context, 42),
                width: ResponsiveSize.width(context, 316),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: AppColors.newColor),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 17.19,
                        color: AppColors.greytextColor,
                      ),
                      hintText: "Search",
                      hintStyle: AppTextStyles.baseStyle2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.greytextColor)),
                ),
              ),   Padding(
            padding: const EdgeInsets.only(left: 17),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("You can only add 4 emergency contact",style: AppTextStyles.baseStyle2.copyWith(fontWeight: FontWeight.w400,color:AppColors.greytextColor ,
              fontSize: 14),),
            ),
          ),SizedBox(height: ResponsiveSize.height(context,20),),

              Expanded(
                  child: ListView.builder(
                      itemCount: widget.selectedContacts.length,
                      itemBuilder: ((context, index) {
                        final contact = widget.selectedContacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                              backgroundColor: AppColors.secondaryColor,
                              child: Text(
                                contact['name']![0],
                                style: AppTextStyles.baseStyle2.copyWith(
                                  color: AppColors.newtextColor,
                                ),
                              )),
                          title: Text(contact['name']!,
                              style: AppTextStyles.baseStyle2.copyWith(
                                  color: AppColors.newtextColor,
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(contact['phone']!,
                              style: AppTextStyles.baseStyle2.copyWith(
                                  color: AppColors.greytextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.purplebackground,
                            ),
                            child: InkWell(
                              onTap: () => _deleteEmergencyContact(context),
                              child: const Icon(
                                Icons.backspace,
                                color: AppColors.primaryColor,
                                size: 15,
                              ),
                            ),
                          ),
                        );
                      })))
            ],
          ),
        ));
  }
}
