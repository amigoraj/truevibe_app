class ApiConfig {
  static const String baseUrl = 'https://api.truevibe.com';
  static const String apiVersion = 'v1';
  
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String posts = '/posts';
  static const String products = '/products';
  static const String users = '/users';
  static const String matches = '/matches';
  
  static Map<String, String> headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
