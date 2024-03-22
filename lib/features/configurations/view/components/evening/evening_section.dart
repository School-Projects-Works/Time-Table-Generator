import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parts/even_day_section.dart';
import 'parts/even_liberal_section.dart';
import 'parts/even_period_sections.dart';

class EveningConfigSection extends ConsumerStatefulWidget {
  const EveningConfigSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EveningConfigSectionState();
}

class _EveningConfigSectionState extends ConsumerState<EveningConfigSection> {

  @override
   Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EveningDaySection(),
                EveningLiberalSection()
              ],
            ),
          ),
          EveningPeriodsSection(),
        ],
      ),
    );
  }

}