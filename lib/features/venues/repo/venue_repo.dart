import '../data/venue_model.dart';

abstract class VenueRepo{
  Future<(bool,String,List<VenueModel>?)> importVenues();
   Future<(bool, String?)> downloadTemplate();
  Future<(bool,String)> addVenue(VenueModel venue);
  Future<(bool,String, VenueModel?)> deleteVenue(String id);
  Future<(bool,String)> deleteAllVenues();
  Future<(bool,String, VenueModel?)> updateVenue(VenueModel venue);
   Future<List<VenueModel>>  getVenues();

}