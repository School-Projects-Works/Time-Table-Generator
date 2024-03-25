import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/features/tables/provider/table_gen_provider.dart';
import 'package:aamusted_timetable_generator/features/tables/views/componenets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/theme.dart';
import '../provider/lib_gen_provider.dart';
import '../provider/table_generation_provider.dart';

class CompleteDataPage extends ConsumerStatefulWidget {
  const CompleteDataPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompleteDataPageState();
}

class _CompleteDataPageState extends ConsumerState<CompleteDataPage> {
  @override
  Widget build(BuildContext context) {
    var table = ref.watch(filteredTableProvider);
    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Generated Tables'.toUpperCase(),
                    style: getTextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                CustomButton(
                    text: 'Generate Table',
                    radius: 10,
                    color: primaryColor,
                    onPressed: () {
                      ref.read(vtpProvider.notifier).generateVTP(ref);
                      ref.read(lccProvider.notifier).generateLCC(ref);
                      ref.read(ltpProvider.notifier).generateLTP(ref);
                      ref.read(tableGenProvider.notifier).generateTables(ref);
                    })
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(children: [
                Expanded(
                    child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: table.isEmpty
                            ? Text(
                                'Notable generated yet',
                                style: GoogleFonts.nunito(),
                              )
                            : const TableWidget()))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
