import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'parts/day_section.dart';
import 'parts/liberal_section.dart';
import 'parts/period_sections.dart';

class RegularConfigSection extends ConsumerStatefulWidget {
  const RegularConfigSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegularConfigSectionState();
}

class _RegularConfigSectionState extends ConsumerState<RegularConfigSection> {
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
                RegularDaySection(),
                RegularLiberalSection()
              ],
            ),
          ),
          RegularPeriodsSection(),
        ],
      ),
    );
  }
}
