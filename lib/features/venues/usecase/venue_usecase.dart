import 'dart:io';
import 'package:aamusted_timetable_generator/core/data/constants/excel_headings.dart';
import 'package:aamusted_timetable_generator/core/functions/excel_settings.dart';
import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';
import 'package:aamusted_timetable_generator/features/venues/repo/venue_repo.dart';
import 'package:excel/excel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/data/constants/instructions.dart';
import '../../../utils/app_utils.dart';

class VenueUseCase extends VenueRepo {
  final Db db;

  VenueUseCase({required this.db});
  @override
  Future<(bool, String)> addVenues(List<VenueModel> venues) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      //check if venue already exists
      //if it exists, update it
      //if it doesn't exist, add it
      for (var venue in venues) {
        var existingVenue =
            await db.collection('venues').findOne({'id': venue.id});
        if (existingVenue != null) {
          await db.collection('venues').update(existingVenue, venue.toMap());
        } else {
          await db.collection('venues').insert(venue.toMap());
        }
      }
      return Future.value((true, 'Venues added successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String)> deleteAllVenues() async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      await db.collection('venues').drop();
      return Future.value((true, 'Venues deleted successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String)> deleteVenue(String id) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      await db.collection('venues').remove({'id': id});
      return Future.value((true, 'Venue deleted successfully'));
    } catch (e) {
      return Future.value((false, e.toString()));
    }
  }

  @override
  Future<(bool, String?)> downloadTemplate() async {
    try {
      var workbook = ExcelSettings.generateVenueTem();

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
          if (row[0] == null || row[0]!.value == null) {
            break;
          } else {
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
      } else {
        return Future.value((false, 'Invalid excel file', null));
      }
    } catch (e) {
      return Future.value((false, e.toString(), null));
    }
  }

  @override
  Future<(bool, String, VenueModel?)> updateVenue(VenueModel venue) async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      await db.collection('venues').update(
          await db.collection('venues').findOne({'id': venue.id}),
          venue.toMap(),
          upsert: true);
      return Future.value((true, 'Venue updated successfully', venue));
    } catch (e) {
      return Future.value((false, e.toString(), null));
    }
  }

  @override
  Future<List<VenueModel>> getVenues() async {
    try {
      if (db.state != State.open) {
        await db.open();
      }
      var venueBox = await db.collection('venues').find().toList();
      if (venueBox.isEmpty) {
        return Future.value([]);
      }
      var data = venueBox.map((e) => VenueModel.fromMap(e)).toList();

      return Future.value(data);
    } catch (e) {
      return Future.value([]);
    }
  }
}
