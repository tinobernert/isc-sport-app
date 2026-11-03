import 'package:flutter/material.dart';
import '../../../core/widgets/page_heading.dart';
import '../../../core/widgets/app_layout.dart';

class DisziplinPage extends StatelessWidget {
  const DisziplinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Disziplinen',
      selectedIndex: 3,
      child: Column(
        children: [
          Container(
            height: 60,
            color: Colors.blue,
            child: PageHeading(title: "Disziplinen")
          ),

          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),

          Container(
            height: 40,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}