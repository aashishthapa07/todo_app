import 'package:flutter/material.dart';

class DateTimeSelection extends StatelessWidget {
  const DateTimeSelection({
    super.key,
    required this.ontap,
    required this.title,
    required this.time,
    this.isTime = false,
  });
  final VoidCallback ontap;
  final String title;
  final String time;
  final bool isTime;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: double.infinity,
        height: height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(title, style: textTheme.headlineSmall),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.04,
              width: isTime ? width * 0.27 : 0.17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100),
              child: Center(
                child: Text(
                  time,
                  style: textTheme.titleSmall,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
