import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uni_of_madinah/constants.dart';

class JobSearchService {
  static Future<List<dynamic>> searchArabicData(String query, int k,
      {required String endpoint}) async {
    final uri =
        Uri.parse('$baseServerUrl$endpoint'); // Use updated base URL here
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"query": query, "k": k});

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Success! Handle the response
        final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        print(responseJson);
        return responseJson['results'];
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
      return [];
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }
}
