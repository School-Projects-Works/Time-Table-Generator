import 'package:aamusted_timetable_generator/Components/CustomButton.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomDropDown.dart';
import '../../../../SateManager/ConfigDataFlow.dart';
import '../../../../SateManager/HiveListener.dart';
import 'DaysSection.dart';
import 'PeriodSection.dart';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  String? loadFrom;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Configurations',
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Row(
                    children: [
                      Text('Load From: ',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: secondaryColor,
                          )),
                      Expanded(
                        child: CustomDropDown(
                          items: const [],
                          value: loadFrom,
                          color: Colors.white,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(child: DaysSection()),
                Expanded(child: PeriodSection()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: CustomButton(
                    onPressed: saveConfig,
                    text: 'Save Configurations',
                    color: secondaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void saveConfig() {
    var data = Provider.of<ConfigDataFlow>(context, listen: false);
    var hiveData = Provider.of<HiveListener>(context, listen: false);
    data.saveConfig(hiveData);
  }
}
