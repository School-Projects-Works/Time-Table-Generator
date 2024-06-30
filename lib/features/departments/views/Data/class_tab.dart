import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassTab extends ConsumerStatefulWidget {
  const ClassTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClassTabState();
}

class _ClassTabState extends ConsumerState<ClassTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: 500,
                  child: CustomTextFields(
                    hintText: 'Search for class',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const Spacer(),
                CustomButton(
                    radius: 10,
                    color: secondaryColor,
                    text: 'Add Class',
                    onPressed: () {},
                    icon: Icons.add),
              ],
            ),
          ),
          const Divider(
            thickness: 4,
            color: primaryColor,
            height: 15,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Class $index'),
                        subtitle: Text('Class $index'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      );
                    },
                    itemCount: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
