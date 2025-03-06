import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  final String baseUrl = 'http://127.0.0.1:8000';
  static const String BOOKS_STORAGE_KEY = 'bookeeper_books';
  
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
  
  // Method to add a book to the user's collection with specific status
  Future<bool> addBookToCollection(Book book, String status) async {
    try {
      // Create a new book instance with the updated status
      final bookWithStatus = Book(
        id: book.id,
        title: book.title,
        author: book.author,
        coverUrl: book.coverUrl,
        language: book.language,
        publisher: book.publisher,
        publishedDate: book.publishedDate,
        isbn: book.isbn,
        description: book.description,
        createdAt: book.createdAt,
        status: status,
      );
      
      // Get existing books from local storage
      final prefs = await SharedPreferences.getInstance();
      final List<String> booksJson = prefs.getStringList(BOOKS_STORAGE_KEY) ?? [];
      
      // Convert existing books to objects
      List<Book> books = booksJson.map((json) => Book.fromJson(jsonDecode(json))).toList();
      
      // Remove the book if it already exists (to avoid duplicates)
      books.removeWhere((existingBook) => existingBook.id == book.id);
      
      // Add the new book with status
      books.add(bookWithStatus);
      
      // Convert books back to JSON strings
      final updatedBooksJson = books.map((b) => jsonEncode(b.toJson())).toList();
      
      // Save back to SharedPreferences
      final success = await prefs.setStringList(BOOKS_STORAGE_KEY, updatedBooksJson);
      
      return success;
    } catch (e) {
      print('Error saving book: $e');
      return false;
    }
  }
  
  // Get all books from local storage
  Future<List<Book>> getAllBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> booksJson = prefs.getStringList(BOOKS_STORAGE_KEY) ?? [];
      
      return booksJson.map((json) => Book.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      print('Error getting all books: $e');
      return [];
    }
  }
  
  // Get books filtered by status
  Future<List<Book>> getBooksByStatus(String status) async {
    try {
      final allBooks = await getAllBooks();
      return allBooks.where((book) => book.status == status).toList();
    } catch (e) {
      print('Error getting books by status: $e');
      return [];
    }
  }
  
  // Remove a book from storage
  Future<bool> removeBook(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> booksJson = prefs.getStringList(BOOKS_STORAGE_KEY) ?? [];
      
      // Convert to objects and filter out the book to remove
      List<Book> books = booksJson
          .map((json) => Book.fromJson(jsonDecode(json)))
          .where((book) => book.id != bookId)
          .toList();
      
      // Convert back to JSON strings
      final updatedBooksJson = books.map((b) => jsonEncode(b.toJson())).toList();
      
      // Save back to SharedPreferences
      return await prefs.setStringList(BOOKS_STORAGE_KEY, updatedBooksJson);
    } catch (e) {
      print('Error removing book: $e');
      return false;
    }
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
