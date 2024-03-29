import 'dart:io';

import 'package:aamusted_timetable_generator/core/data/constants/excel_headings.dart';
import 'package:aamusted_timetable_generator/core/functions/excel_settings.dart';
import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';
import 'package:aamusted_timetable_generator/features/venues/repo/venue_repo.dart';
import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../core/data/constants/instructions.dart';
import '../../../utils/app_utils.dart';

class VenueUseCase extends VenueRepo {
  @override
  Future<(bool, String)> addVenues(List<VenueModel> venues)async {
    try {
      final Box<VenueModel> venueBox = await Hive.openBox<VenueModel>('venues');
      //check if box is open
      if (!venueBox.isOpen) {
       await Hive.openBox('venues');
      }
      for (var venue in venues) {
        venueBox.put(venue.id, venue);
      }
      return Future.value((true, 'Venues added successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String)> deleteAllVenues() {
    // TODO: implement deleteAllVenues
    throw UnimplementedError();
  }

  @override
  Future<(bool, String, VenueModel?)> deleteVenue(String id) {
    // TODO: implement deleteVenue
    throw UnimplementedError();
  }

  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
      final Workbook workbook = Workbook();
      ExcelSettings(
              book: workbook,
              sheetName: 'Venues',
              columnCount: venueHeader.length,
              headings: venueHeader,
              sheetAt: 0,
              instructions: venueInstructions)
          .sheetSettings();

      Directory directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/venues_template.xlsx';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        file.deleteSync();
        file.createSync();
      }
      file.writeAsBytesSync(workbook.saveAsStream());
      // workbook.dispose();
      if (file.existsSync()) {
        return Future.value((true, file.path));
      } else {
        return Future.value((false, 'Error downloading template'));
      }
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String, List<VenueModel>?)> importVenues(String path) async {
    try {
      //read from excel file and get all venues
      var bytes = File(path).readAsBytesSync();
      Excel excel = Excel.decodeBytes(List<int>.from(bytes));
      List<VenueModel> venues = [];
      var venueSheet = excel.tables['Venues']!;
      List<Data?>? venueHeaderRow =
          venueSheet.row(venueInstructions.length + 1);
      if (AppUtils.validateExcel(venueHeaderRow, venueHeader)) {
        var rowStart = venueInstructions.length + 2;
        for (int i = rowStart; i < venueSheet.maxRows; i++) {
          var row = venueSheet.row(i);
          if(row[0] == null || row[0]!.value == null){
            break;
          }else{
            var venue = VenueModel(
              id: row[0]!.value.toString().hashCode.toString(),
              name: row[0]!.value.toString(),
              capacity: int.parse(row[1]!.value.toString()),
              disabilityAccess: row[2]!.value.toString().toLowerCase() == 'yes',
              isSpecialVenue: row[3]!.value.toString().toLowerCase() == 'yes',
            );
            venues.add(venue);
          
          }
        }
        return Future.value((true, 'Venues imported successfully', venues));

      }else{
        return Future.value((false, 'Invalid excel file', null));
      }
    } catch (e) {
      return Future.value((false, e.toString(), null));
    }
  }

  @override
  Future<(bool, String, VenueModel?)> updateVenue(VenueModel venue) {
    // TODO: implement updateVenue
    throw UnimplementedError();
  }

  @override
  Future<List<VenueModel>> getVenues() async {
    try {
      final Box<VenueModel> venueBox =await Hive.openBox<VenueModel>('venues');
      //check if box is open
      if (!venueBox.isOpen) {
        await Hive.openBox('venues');
      }

      var allVenues = venueBox.values.toList();
      return allVenues;
    } catch (e) {
      return Future.value([]);
    }
  }
}
