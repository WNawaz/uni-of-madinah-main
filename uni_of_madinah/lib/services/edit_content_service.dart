import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EditContentService {
  // static String localHostUrl = 'http://192.168.100.136:8000';
  static String baseUrl = '';

  static void updateBaseUrl(String newUrl) {
    baseUrl = newUrl;
  }

  Future<List<dynamic>> getArabicDataForPage(int page) async {
    const String endPoint = 'getArabicData';
    final uri = Uri.parse('$baseUrl/$endPoint?page=$page');
    final headers = {"Content-Type": "application/json"};

    try {
      DateTime startTime = DateTime.now();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Success! Handle the response
        final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        print(responseJson);

        // print the type of the responseJson
        print(responseJson.runtimeType);

        // the responseJson is currently a "string" however this should be a map
        final Map<String, dynamic> responseJsonMap = jsonDecode(responseJson);

        // convert each "index" inside the responseJson to a int
        List<dynamic> results = responseJsonMap['results'];
        print(results);

        // Calculate the time taken
        DateTime endTime = DateTime.now();
        Duration timeTaken = endTime.difference(startTime);
        print('Request took: ${timeTaken.inMilliseconds} milliseconds');

        return results;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  Future<List<dynamic>> getEnglishDataForPage(int page) async {
    const String endPoint = 'getEnglishData';
    final uri = Uri.parse('$baseUrl/$endPoint?page=$page');
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Success! Handle the response
        final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        print(responseJson);

        // print the type of the responseJson

        print(responseJson.runtimeType);

        // the responseJson is currently a "string" however this should be a map

        final Map<String, dynamic> responseJsonMap = jsonDecode(responseJson);

        // convert each "index" inside the responseJson to a int

        List<dynamic> results = responseJsonMap['results'];
        print(results);
        return results;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  static Future<List<dynamic>> editApi(
      String title, String content, String id, String language) async {
    const String endPoint = 'updateContent';
    final uri = Uri.parse('$baseUrl/$endPoint'); // Use updated base URL here
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'id': id,
      'editedTitle': title,
      'editedContent': content,
      'language': language
    });

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

  static Future<List<dynamic>> ediTitleApi(
      String title, String id, String language) async {
    const String endPoint = 'updateContentTitle';

    final uri = Uri.parse('$baseUrl/$endPoint'); // Use updated base URL here
    final headers = {"Content-Type": "application/json"};
    final body =
        jsonEncode({'id': id, 'editedTitle': title, 'language': language});

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

  static Future<List<dynamic>> ediContentApi(
      String content, String id, String language) async {
    const String endPoint = 'updateContentDescription';

    final uri = Uri.parse('$baseUrl/$endPoint'); // Use updated base URL here
    final headers = {"Content-Type": "application/json"};
    final body =
        jsonEncode({'id': id, 'editedContent': content, 'language': language});

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
