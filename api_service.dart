import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({this.baseUrl = 'http://10.0.2.2:8000'});
  final String baseUrl;

  Future<dynamic> get(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path'));
    if (response.statusCode >= 400) throw Exception('Unable to load market data');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> stock(String symbol) async => Map<String, dynamic>.from(await get('/api/stocks/$symbol'));
  Future<Map<String, dynamic>> analysis(String symbol) async => Map<String, dynamic>.from(await get('/api/stocks/$symbol/ai-analysis'));
  Future<Map<String, dynamic>> overview() async => Map<String, dynamic>.from(await get('/api/market/overview'));
  Future<Map<String, dynamic>> portfolio() async => Map<String, dynamic>.from(await get('/api/portfolio'));
  Future<Map<String, dynamic>> health() async => Map<String, dynamic>.from(await get('/api/ai/portfolio-health'));
  Future<List<dynamic>> search(String query) async => (await get('/api/stocks/search?q=$query'))['results'] as List<dynamic>;
}
