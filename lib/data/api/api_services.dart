import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:qr_scan_ieee/constants.dart';
import 'package:qr_scan_ieee/data/models/api_models.dart';
import 'package:qr_scan_ieee/data/models/user_model.dart';

class ApiServices {
  InternetConnection networkInfo = InternetConnection();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
    ),
  )..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ));

  final String _adminEndPoint = 'admin/events';
  final String _attendeesPath = 'attendees';
  // final String _eventsEndPoint = 'events';
  // final String _registerPath = 'register';
  final String _eventId = '2bb30c71-9f08-4260-b27b-4ff55b4d5771';

  // Future<void> registrationToEvent(List<MemberModel> members) async {
  //   try {
  //     await _dio.post(
  //       '$_eventsEndPoint/$_eventId/$_registerPath',
  //       data: {
  //         'formFields': [
  //           for (var member in members)
  //             {
  //               'fieldId': member.id,
  //               'value': member.name,
  //             },
  //         ],
  //       },
  //     );
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<List<RegistrationFormFieldResponse>> getRegistrationForm() async {
  //   try {
  //     final response = await _dio.get(
  //       '$_eventsEndPoint/$_eventId/$_registerPath',
  //     );
  //     var formFields = response.data['data']['event']['formFields'];
  //     return (formFields as List)
  //         .map((e) => RegistrationFormFieldResponse.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }

  Future<List<MemberResponse>> getAttendedMembers() async {
    try {
      final response =
          await _dio.get('$_adminEndPoint/$_eventId/$_attendeesPath');
      var absentUsers = response.data['data']['presentUsers'];

      return (absentUsers as List)
          .map((e) => MemberResponse.fromJson(e))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<MemberResponse>> getAbsentMembers() async {
    try {
      final response =
          await _dio.get('$_adminEndPoint/$_eventId/$_attendeesPath');
      var absentUsers = response.data['data']['absentUsers'];

      return (absentUsers as List)
          .map((e) => MemberResponse.fromJson(e))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> markMemberAsAttended(String id) async {
    if (await networkInfo.hasInternetAccess) {
      try {
        var response = await _dio.post(
          '$_adminEndPoint/$_eventId/$_attendeesPath',
          data: {
            'userId': id,
          },
        );
        if (response.statusCode == 200) {
          var box = Hive.box<UserModel>(user);
          box.add(UserModel(
            id: id,
            name: response.data['data']['user']['name'].toString(),
            email: response.data['data']['user']['email'].toString(),
            date: DateFormat('HH:mm dd MMM').format(DateTime.now()),
          ));
          return 'User checked in successfully';
        } else if (response.statusCode == 400) {
          return 'User already checked in';
        } else {
          return 'User not Found';
        }
      } on DioException catch (e) {
         if (e.type == DioExceptionType.badResponse) {
          return 'User already checked in';
        }
        return "Can't register, check your internet connection";}
    } else {
      return "Can't register, check your internet connection";
    }
  }

  // Future<List<RegistrationFormFieldResponse>> getEventRegisters() async {
  //   try {
  //     final response =
  //         await _dio.get('$_adminEndPoint/$_eventId/$_registerPath');
  //     var registrations = response.data['data']['event']['registrations'];
  //     return (registrations as List)
  //         .map((e) => RegistrationFormFieldResponse.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }
}

// import 'package:dio/dio.dart';


// class ApiService {
//  final String eventId = "6f182c87-901a-4a26-8310-7812b531ab7f";
//   Dio dio = Dio(
//     BaseOptions(
//       baseUrl: "https://api.ieee-bub.org",
//       connectTimeout: const Duration(seconds: 5),
//       receiveTimeout: const Duration(seconds: 5),
//     ),
//   );

//   Future<Map<dynamic, dynamic>> getAll() async {
//     try {
//       final responce = await dio.get('/api/admin/events/$eventId/attendees');
//       return responce.data;
//     } catch (e) {
//       return {};
//     }
//   }

//   Future<String> register(String? userId) async {
//     if (userId == null || userId == "") {
//       return "No ID";
//     }
//     try {
//       final data = await getAll();
//       List<dynamic> presentUsers = data["data"]["presentUsers"];
//       bool isPresent = presentUsers.any((user) => user["id"] == userId);
//       if (isPresent) {
//         return "User registered before";
//       }
//     } catch (e) {
//       return "Can't fetch data, check your internet connection";
//     }

//     try {
//       final responce = await dio.post(
//         '/api/admin/events/$eventId/attendees',
//         data: {"userId": userId},
//       );

//       if (responce.data["status"] == "success") {
//         return "Registered successfully";
//       } else {
//         return "dummy"; //Any text just to prevent errors (The body might complete normally, causing 'null' to be returned)
//       }
//     } on DioException catch (e) {
//       if (e.type == DioExceptionType.connectionTimeout ||
//           e.type == DioExceptionType.receiveTimeout ||
//           e.type == DioExceptionType.unknown) {
//         return "Can't register, check your internet connection";
//       } else {
//         return "User is not registered for this event";
//       }
//     }
//   }


// }


/*
{
    "status": "success",
    "message": "User checked in successfully",
    "data": {
        "user": {
            "id": "6e9eb5ce-7044-4047-92e2-5aa8246b06f8",
            "name": "Abdelrahman karam",
            "email": "abdelrahman.karam@ieee.org",
            "phone": ""
        }
    }
}

 */