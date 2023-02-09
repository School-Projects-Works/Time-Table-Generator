import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:aamusted_timetable_generator/Models/Table/table_model.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/hive_listener.dart';

class GenerateTablePage extends StatefulWidget {
  const GenerateTablePage({super.key});

  @override
  State<GenerateTablePage> createState() => _GenerateTablePageState();
}

class _GenerateTablePageState extends State<GenerateTablePage> {
  String selectedRadio = 'Provisional';

  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HiveListener>(builder: (context, hive, child) {
      List<TableModel> table = hive.getListOfTables
          .where((element) => element.tableType == selectedRadio)
          .toList();
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: 500,

                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  // alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      Text(
                        'Select Table Type to Proceed',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.black,
                        indent: 20,
                        endIndent: 20,
                      ),
                      RadioListTile(
                        value: 'Provisional',
                        groupValue: selectedRadio,
                        title: Text(
                          "Provisional Table",
                          style: GoogleFonts.nunito(fontSize: 18),
                        ),
                        onChanged: (val) {
                          setSelectedRadio(val!);
                        },
                        activeColor: primaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      RadioListTile(
                        value: 'Final',
                        groupValue: selectedRadio,
                        title: Text("Final Table",
                            style: GoogleFonts.nunito(fontSize: 18)),
                        onChanged: (val) {
                          setSelectedRadio(val!);
                        },
                        activeColor: primaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      if (table.isNotEmpty)
                        Text(
                          'You already have a $selectedRadio table generated. Do you want to overwrite it?',
                          style: GoogleFonts.nunito(
                              color: secondaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      CustomButton(
                          onPressed: () {
                            // hive.generateTables(selectedRadio);
                            //close page
                            Navigator.pop(context);
                          },
                          text: table.isNotEmpty
                              ? 'Regenerate Table'
                              : 'Generate Table')
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
