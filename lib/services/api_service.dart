import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  String? _token;
  
  void setToken(String token) {
    _token = token;
  }
  
  Future<List<dynamic>> fetchPosts(String feedType) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.posts}?type=$feedType'),
        headers: ApiConfig.headers(token: _token),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load posts');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}'),
        headers: ApiConfig.headers(token: _token),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}