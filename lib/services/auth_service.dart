import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  String? _token;
  UserModel? _currentUser;
  
  String? get token => _token;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null;
  
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: ApiConfig.headers(),
        body: json.encode({'email': email, 'password': password}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _currentUser = UserModel.fromJson(data['user']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
        headers: ApiConfig.headers(),
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['token'];
        _currentUser = UserModel.fromJson(data['user']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  void logout() {
    _token = null;
    _currentUser = null;
  }
}