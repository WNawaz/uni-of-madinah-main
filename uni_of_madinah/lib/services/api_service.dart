import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart' as http;

import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';

class QueryModel {
  final String query;
  final int k;

  QueryModel({required this.query, required this.k});

  Map<String, dynamic> toJson() {
    return {
      "query": query,
      "k": k,
    };
  }
}

class EditTitleQueryModel {
  final String id;
  final String editedTitle;
  final String language;

  EditTitleQueryModel({
    required this.id,
    required this.editedTitle,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "editedTitle": editedTitle,
      "language": language,
    };
  }
}

class EditDescriptionQueryModel {
  final String id;
  final String editedContent;
  final String language;

  EditDescriptionQueryModel({
    required this.id,
    required this.editedContent,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "editedContent": editedContent,
      "language": language,
    };
  }
}

class UpdateContentQueryModel {
  final String id;
  final String newTitle;
  final String newDescription;
  final String language;

  UpdateContentQueryModel({
    required this.id,
    required this.newTitle,
    required this.newDescription,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "newTitle": newTitle,
      "newDescription": newDescription,
      "language": language,
    };
  }
}

class ApiService {
  final String tag = 'ApiService';

  final FirebaseRemoteConfig _remoteConfig;

  ApiService(this._remoteConfig);

  String get serverBaseUrl => _remoteConfig.getString('server_base_url');
  //final String serverBaseUrl = "https://8937-119-156-232-132.ngrok-free.app";
  // final String serverBaseUrl = "http://192.168.100.136:7000";

  final String arabicContentEndpoint = "/search-arabic-data/";
  final String englishContentEndpoint = "/search-english-data/";
  final String updateContentEndpoint = "/updateContent";
  final String updateTitleContentEndpoint = "/updateContentTitle";
  final String updateDescriptionContentEndpoint = "/updateContentDescription";
  final String getArabicContentEndpoint = "/getArabicContent";
  final String getEnglishContentEndpoint = "/getEnglishContent";
  final String getExploreArabicContentEndpoint = "/getExploreArabicContent";
  final String getExploreEnglishContentEndpoint = "/getExploreEnglishContent";
  final String summariseArabicContentEndpoint = "/summarizeArabic";
  final String summariseEnglishContentEndpoint = "/summarizeEnglish";
  final String deleteContentEndpoint = "/deleteContent";
  final String edittedarabicContentEndpoint = "/search-edited-arabic-data/";
  final String edittedenglishContentEndpoint = "/search-edited-english-data/";
  final String getEditedExploreEnglishContentEndpoint =
      "/getEditedExploreEnglishContent";
  final String getEditedExploreArabicContentEndpoint =
      "/getEditedExploreArabicContent";
  final String englishAuthorsAndLinks = "/englishAuthorsAndLinks";
  final String arabicAuthorsAndLinks = "/arabicAuthorsAndLinks";

  Future<List<IslamicContent>?> queryEditedArabicContent(String query,
      List<String> selectedAuthors, List<String> selectedLinks) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + edittedarabicContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode({
          'query': query,
          'selectedAuthors': selectedAuthors,
          'selectedLinks': selectedLinks,
          'k': 50
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(
            response.bodyBytes,
          ),
        );

        final List<dynamic> content = data['results'];

        return content.map((dynamic job) {
          return IslamicContent(
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            index: job['index'],
            isRTL: true,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to query Arabic content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IslamicContent>?> queryArabicContent(String query,
      List<String> selectedAuthors, List<String> selectedLinks) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + arabicContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode({
          'query': query,
          'selectedAuthors': selectedAuthors,
          'selectedLinks': selectedLinks,
          'k': 50
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(
            response.bodyBytes,
          ),
        );

        final List<dynamic> content = data['results'];

        return content.map((dynamic job) {
          return IslamicContent(
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            index: job['index'],
            isRTL: true,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to query Arabic content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IslamicContent>?> queryEditedEnglishContent(String query,
      List<String> selectedAuthors, List<String> selectedLinks) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + edittedenglishContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode({
          'query': query,
          'selectedAuthors': selectedAuthors,
          'selectedLinks': selectedLinks,
          'k': 50
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");

        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> content = data['results'];

        return content.map((dynamic job) {
          return IslamicContent(
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            index: job['index'],
            isRTL: false,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to query English content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IslamicContent>?> queryEnglishContent(String query,
      List<String> selectedAuthors, List<String> selectedLinks) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + englishContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode({
          'query': query,
          'selectedAuthors': selectedAuthors,
          'selectedLinks': selectedLinks,
          'k': 50
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");

        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> content = data['results'];

        return content.map((dynamic job) {
          return IslamicContent(
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            index: job['index'],
            isRTL: false,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to query English content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteContent(int id) async {
    final String url = '$serverBaseUrl$deleteContentEndpoint/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete content: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("An error occurred while deleting content: $e");
      return false;
    }
  }

//********************* */
  Future<void> updateExploreTitleContent(
    String id,
    String newContent,
    String language,
  ) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + updateTitleContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode(EditTitleQueryModel(
          id: id,
          editedTitle: newContent,
          language: language,
        ).toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            "$tag | Failed to update content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> deleteContent(String id) async {
  //   try {
  //     final Uri uri = Uri.parse(serverBaseUrl + deleteContentEndpoint);

  //     final response = await http.post(
  //       uri,
  //       body: jsonEncode({
  //         "id": id,
  //       }),
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception(
  //           "$tag | Failed to delete content: ${response.statusCode} ${response.body}");
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> updateExploreDescriptionContent(
    String id,
    String newContent,
    String language,
  ) async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + updateDescriptionContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode(EditDescriptionQueryModel(
          id: id,
          editedContent: newContent,
          language: language,
        ).toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            "$tag | Failed to update content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateExploreBothTitleAndDescription(
    String id,
    String newTitle,
    String newDescription,
    String language,
  ) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + updateContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode(UpdateContentQueryModel(
          id: id,
          newTitle: newTitle,
          newDescription: newDescription,
          language: language,
        ).toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            "$tag | Failed to update content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

/************************** */
  Future<void> updateTitleContent(
    String id,
    String newContent,
    String language,
  ) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + updateTitleContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode(EditTitleQueryModel(
          id: id,
          editedTitle: newContent,
          language: language,
        ).toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            "$tag | Failed to update content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

// Method to get English authors and links
  Future<Map<String, List<String>>?> getEnglishAuthorsAndLinks(
      bool isAdminsOrVolunteers) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + englishAuthorsAndLinks).replace(
          queryParameters: {
            'isAdminsOrVolunteers': isAdminsOrVolunteers.toString()
          }); // Add query parameter
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          "authors": List<String>.from(data['authors']),
          "links": List<String>.from(data['links'])
        };
      } else {
        throw Exception(
            "$tag | Failed to get English authors and links: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

// Method to get Arabic authors and links
  Future<Map<String, List<String>>?> getArabicAuthorsAndLinks(
      bool isAdminsOrVolunteers) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + arabicAuthorsAndLinks).replace(
          queryParameters: {
            'isAdminsOrVolunteers': isAdminsOrVolunteers.toString()
          }); // Add query parameter
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {
          "authors": List<String>.from(data['authors']),
          "links": List<String>.from(data['links'])
        };
      } else {
        throw Exception(
            "$tag | Failed to get Arabic authors and links: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDescriptionContent(
    String id,
    String newContent,
    String language,
  ) async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + updateDescriptionContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode(EditDescriptionQueryModel(
          id: id,
          editedContent: newContent,
          language: language,
        ).toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            "$tag | Failed to update content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBothTitleAndDescription(
    String id,
    String newTitle,
    String newDescription,
    String language,
  ) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + updateContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode(UpdateContentQueryModel(
          id: id,
          newTitle: newTitle,
          newDescription: newDescription,
          language: language,
        ).toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            "$tag | Failed to update content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<String> getEnglishContentSummary(
  //     String content, String languageCode) async {
  //   try {
  //     print("Content is $content");

  //     final Uri uri =
  //         Uri.parse(serverBaseUrl + summariseEnglishContentEndpoint);
  //     final response = await http.post(
  //       uri.replace(queryParameters: {"data": content}),
  //     );

  //     print("Response status code: ${response.statusCode}");
  //     print("Response body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
  //       if (responseJson.containsKey('summary')) {
  //         print(responseJson);
  //         return responseJson['summary'];
  //       } else {
  //         print('Summary not found in response.');
  //       }
  //     } else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //     return "";
  //   } catch (e) {
  //     print("Error during request: $e");
  //     return "";
  //   }
  // }

  Future<String?> getEnglishContentSummary(
    String content,
  ) async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + summariseEnglishContentEndpoint);

      final response = await http.post(
        uri,
        body: jsonEncode({"data": content}),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return data['summary'];
      } else {
        throw Exception(
          "$tag | Failed to get English content summary: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getArabicContentSummary(
    String content,
  ) async {
    try {
      final Uri uri = Uri.parse(serverBaseUrl + summariseArabicContentEndpoint);

      // Log the request details
      print('Making request to: $uri');
      print('Request headers: ${{
        "Content-Type": "application/json; charset=UTF-8",
      }}');
      print('Request body: ${jsonEncode({"data": content})}');

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"data": content}),
      );

      // Log the full response
      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body using UTF-8
        final decodedResponseBody = utf8.decode(response.bodyBytes);
        print('Decoded response body: $decodedResponseBody');

        // Ensure the response body is a valid JSON
        try {
          final Map<String, dynamic> data = jsonDecode(decodedResponseBody);
          return data['summary'];
        } catch (e) {
          print('$tag | JSON decode error: $e');
          throw Exception(
              '$tag | Failed to parse response body: $decodedResponseBody');
        }
      } else {
        throw Exception(
            "$tag | Failed to get Arabic content summary: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print('$tag | Error: $e');
      rethrow;
    }
  }

  Future<List<IslamicContent>>? getEditedExploreContentEnglish() async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + getEditedExploreEnglishContentEndpoint);

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Decoded data: $data");

        // print the data type
        print("Data type: ${data.runtimeType}");

        final decodedData = jsonDecode(data);

        print("Decoded data: $decodedData");

        // print the decodedData type
        print("Decoded data type: ${decodedData.runtimeType}");

        final List<dynamic> content = decodedData['results'];

        print("Content: $content");

        return content.map((dynamic job) {
          // print the job and the "index" datatype
          print("job: $job");
          print("index: ${job['index'].runtimeType}");

          return IslamicContent(
            index: int.parse(job['index'].toString()),
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            isRTL: false,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to get explore content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IslamicContent>>? getExploreContentEnglish() async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + getExploreEnglishContentEndpoint);

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Decoded data: $data");

        // print the data type
        print("Data type: ${data.runtimeType}");

        final decodedData = jsonDecode(data);

        print("Decoded data: $decodedData");

        // print the decodedData type
        print("Decoded data type: ${decodedData.runtimeType}");

        final List<dynamic> content = decodedData['results'];

        print("Content: $content");

        return content.map((dynamic job) {
          // print the job and the "index" datatype
          print("job: $job");
          print("index: ${job['index'].runtimeType}");

          return IslamicContent(
            index: int.parse(job['index'].toString()),
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            isRTL: false,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to get explore content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IslamicContent>>? getExploreContentArabic() async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + getExploreArabicContentEndpoint);

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Decoded data: $data");

        // print the data type
        print(
            "Data type: ${data.runtimeType}"); // Data type: _InternalLinkedHashMap<String, dynamic>

        final decodedData = jsonDecode(data);

        print("Decoded data: $decodedData");

        // print the decodedData type
        print(
            "Decoded data type: ${decodedData.runtimeType}"); // Decoded data type: _InternalLinkedHashMap<String, dynamic>

        final List<dynamic> content = decodedData['results'];

        print("Content: $content");

        return content.map((dynamic job) {
          // print the job and the "index" datatype
          print("job: $job");
          print("index: ${job['index'].runtimeType}");

          return IslamicContent(
            index: int.parse(job['index'].toString()),
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            isRTL: false,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to get explore content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IslamicContent>>? getEditedExploreContentArabic() async {
    try {
      final Uri uri =
          Uri.parse(serverBaseUrl + getEditedExploreArabicContentEndpoint);

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Decoded data: $data");

        // print the data type
        print(
            "Data type: ${data.runtimeType}"); // Data type: _InternalLinkedHashMap<String, dynamic>

        final decodedData = jsonDecode(data);

        print("Decoded data: $decodedData");

        // print the decodedData type
        print(
            "Decoded data type: ${decodedData.runtimeType}"); // Decoded data type: _InternalLinkedHashMap<String, dynamic>

        final List<dynamic> content = decodedData['results'];

        print("Content: $content");

        return content.map((dynamic job) {
          // print the job and the "index" datatype
          print("job: $job");
          print("index: ${job['index'].runtimeType}");

          return IslamicContent(
            index: int.parse(job['index'].toString()),
            title: job['title'] ?? '',
            content: job['content'] ?? '',
            isRTL: false,
            author: job['author'] ?? '',
            referenceLink: job['link'] ?? '',
          );
        }).toList();
      } else {
        throw Exception(
            "$tag | Failed to get explore content: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
