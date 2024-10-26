// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:uni_of_madinah/constants.dart';

// class ContentSummaryService {
//   Future<String> getContentSummaries(
//       String content, String languageCode) async {
//     try {
//       print("Content is $content");

//       String endpoint = languageCode == 'arabic'
//           ? summariseArabicEndpoint
//           : summariseEnglishEndpoint;

//       final Uri uri = Uri.parse('$baseServerUrl/$endpoint?content=$content');
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         // Success! Handle the response
//         final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
//         print(responseJson);
//         return responseJson['summary'];
//       } else {
//         print('Request failed with status: ${response.statusCode}.');
//       }
//       return "";
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
