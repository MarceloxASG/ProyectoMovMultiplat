import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://6677b6bc0bd45250561c4e88.mockapi.io/players"; //URL del API

  Future<List<dynamic>> fetchPlayers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load players');
    }
  }

  Future<void> addPlayer(Map<String, String> player) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(player),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add player');
    }
  }

  Future<void> updatePlayer(String id, Map<String, String> player) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(player),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update player');
    }
  }

  Future<void> deletePlayer(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete player');
    }
  }
}
