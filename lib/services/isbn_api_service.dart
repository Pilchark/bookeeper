import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class IsbnApiService {
  static const String baseUrl = 'https://api2.isbndb.com';
  static const String apiKey = 'YOUR_API_KEY'; // 替换为实际的API密钥

  Future<Book?> getBookByIsbn(String isbn) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/book/$isbn'),
        headers: {
          'Authorization': apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        print('API Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in API call: $e');
      return null;
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$query'),
        headers: {
          'Authorization': apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final books = data['books'] as List;
        return books.map((bookData) => Book.fromJson(bookData)).toList();
      } else {
        print('API Error: ${response.statusCode}, ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception in API call: $e');
      return [];
    }
  }
}
