import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widget/custom_button.dart';
import '../provider/table_gen_provider.dart';

class TableFilterBox extends ConsumerStatefulWidget {
  const TableFilterBox(this.critaria, {super.key});
  final String critaria;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TableFilterPageState();
}

class _TableFilterPageState extends ConsumerState<TableFilterBox> {
  final _queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enter filter criteria',
                    style: getTextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                IconButton(
                    onPressed: () {
                      if(_queryController.text.isEmpty) {
                        ref.read(filterProvider.notifier).state = 'All';
                         ref
                            .read(filteredTableProvider.notifier)
                            .filter('', ref);
                      }
                      CustomDialog.dismiss();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 2,
              color: secondaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFields(
              controller: _queryController,
              label: 'Enter ${widget.critaria}',
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                onPressed: () {
                  if (_queryController.text.isEmpty) {
                    return;
                  }
                  ref
                      .read(filteredTableProvider.notifier)
                      .filter(_queryController.text, ref);
                },
                radius: 10,
                text: 'Filter',
                color: secondaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
