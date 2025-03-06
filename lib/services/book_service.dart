import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BookService {
  final String baseUrl = 'http://127.0.0.1:8000';
  
  Future<Book?> searchByIsbn(String isbn) async {
    try {
      // Log the request for debugging
      print('Making request to: $baseUrl/random?isbn=$isbn');
      
      final response = await http.get(
        Uri.parse('$baseUrl/random?isbn=$isbn'),
        headers: {
          'Accept': 'application/json',
          // Adding origin headers can help with some CORS issues
          'Origin': 'http://localhost'
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Book.fromJson(data);
      } else {
        print('Failed to load book: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      // More detailed error logging
      if (kIsWeb) {
        print('Error searching by ISBN (likely CORS issue in web): $e');
        print('For web: Ensure your API server has CORS headers enabled.');
      } else {
        print('Error searching by ISBN: $e');
      }
      return null;
    }
  }
  
  Future<List<Book>> searchByTitle(String title) async {
    // For now, we'll keep this as a mock since the API endpoint for title search wasn't specified
    // In a real implementation, this would make an API call too
    await Future.delayed(Duration(milliseconds: 800));
    
    // Mock data
    return [
      Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Book Title containing "$title"',
        author: 'Author Name',
        description: 'A sample description for this book',
        coverUrl: 'https://via.placeholder.com/150',
      ),
    ];
  }
  
  // Method to add a book to the user's collection
  Future<bool> addBookToCollection(Book book, String status) async {
    // In a real app, this would interact with a database
    // For now, we'll just simulate success
    await Future.delayed(Duration(milliseconds: 300));
    return true;
  }
  
  // Helper method to check if CORS might be an issue
  bool isCorsLikelyIssue() {
    // CORS is primarily an issue in web contexts
    return kIsWeb;
  }
  
  // Method to get API health/status for debugging
  Future<bool> checkApiConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      print('API connection check failed: $e');
      return false;
    }
  }
}
