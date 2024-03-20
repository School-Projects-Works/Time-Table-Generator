import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';
import 'package:aamusted_timetable_generator/features/venues/repo/venue_repo.dart';
import 'package:hive/hive.dart';


class VenueUseCase extends VenueRepo{
  @override
  Future<(bool, String)> addVenue(VenueModel venue) {
    // TODO: implement addVenue
    throw UnimplementedError();
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
  Future<(bool, String?)> downloadTemplate() {
    // TODO: implement downloadTemplate
    throw UnimplementedError();
  }

  @override
  Future<(bool, String, List<VenueModel>?)> importVenues() {
    // TODO: implement importVenues
    throw UnimplementedError();
  }

  @override
  Future<(bool, String, VenueModel?)> updateVenue(VenueModel venue) {
    // TODO: implement updateVenue
    throw UnimplementedError();
  }
  
  @override
  Future<List<VenueModel>> getVenues() async{
   try{
     final Box<VenueModel> venueBox = Hive.box<VenueModel>('venues');
     //check if box is open
      if (!venueBox.isOpen) {
        await Hive.openBox('venues');
      }
      
      var allVenues = venueBox.values.toList();
      return allVenues;

   }catch(e){
     return Future.value([]);
   }
  }

}