import 'package:flutter/material.dart';
import 'package:todo_app/extension/space_extension.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';

class CustomSliderDrawer extends StatefulWidget {
  CustomSliderDrawer({super.key});

  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  State<CustomSliderDrawer> createState() => _CustomSliderDrawerState();
}

class _CustomSliderDrawerState extends State<CustomSliderDrawer> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;

    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
          ),
          8.h,
          Text(
            "Lesley Browning",
            style: textTheme.displayMedium,
          ),
          Text(
            "Flutter DEV",
            style: textTheme.displaySmall,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: height * 0.3,
            child: ListView.builder(
              itemCount: widget.icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    print('${widget.texts[index]} Item Tapped!');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Icon(
                        widget.icons[index],
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        widget.texts[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
