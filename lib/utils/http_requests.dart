import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> searchSongs(String query) async {
  final url = Uri.parse(
    'https://itunes.apple.com/search?term=${Uri.encodeComponent(query)}&entity=song',
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results'];
  } else {
    print('Error: ${response.statusCode}');
    return [];
  }
}
