import 'package:cloud_firestore/cloud_firestore.dart';

class Util {
  static String uid = "";
  static String email = "";
  static String gender = "";
}

class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance.collection('users').where('searchKey', isEqualTo: searchField.substring(0, 1).toUpperCase()).get();
  }
}

class Schedule {
  static String date = "";
  static DateTime datecreated;
  static String endtime = "";
  static String starttime = "";
  static String endtimeFormatted = "";
  static String starttimeFormatted = "";
  static String notes = "";
  static String missionname = "";
  static String kind = "";
  static String location = "";
  static String spotter = "";
  static String teamlead = "";
  static String spokesperson = "";
  static String status = "";
  static String createdby = "";
  static String collectionid = "";
  static String editedtime = "";
  static List<String> blockteam = [];
  static List<String> investteam = [];
  static List<String> searchteam = [];
  static List<String> secuteam = [];
  static List<String> blockteamname = [];
  static List<String> investteamname = [];
  static List<String> searchteamname = [];
  static List<String> secuteamname = [];
  static List<String> vehicle = [];
  static List<String> memberuid = [];
  static String flaggedvehicles = '';
  static String lastflag = '';
  static String scannedvehicles = '';
  static String lastscan = '';
  // static List<double> latloc = [];
  // static List<double> lngloc = [];
  static double latloc = 0;
  static double lngloc = 0;
}

class UserSched {
  static List<String> collectid = [];
  static String badge = '';
  static String badgename = '';
  static String date = "";
  static DateTime datecreated;
  static String endtime = "";
  static String starttime = "";
  static String endtimeFormatted = "";
  static String starttimeFormatted = "";
  static String notes = "";
  static String missionname = "";
  static String kind = "";
  static String location = "";
  static String spotter = "";
  static String teamlead = "";
  static String spokesperson = "";
  static String status = "";
  static String createdby = "";
  static String collectionid = "";
  static String editedtime = "";
  static List<String> blockteam = [];
  static List<String> investteam = [];
  static List<String> searchteam = [];
  static List<String> secuteam = [];
  static List<String> blockteamname = [];
  static List<String> investteamname = [];
  static List<String> searchteamname = [];
  static List<String> secuteamname = [];

  static List<String> vehicle = [];
}

class UserLog {
  static String ppUrl;
  static String rank;
  static String fullName;
}

class PastSchedule {
  static String missionname = '';
  static String purpose = '';
  static String starttime = '';
  static String endtime = '';
  static String date = '';
  static List<String> flaggedvehicles = [];
  static List<String> scannedvehicles = [];
  static List<String> vehicles = [];
  static String missionid = '';
}
