import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/database_helper.dart';
import '../services/isbn_api_service.dart';

class BookProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final IsbnApiService _apiService = IsbnApiService();
  
  List<Book> _toReadBooks = [];
  List<Book> _readingBooks = [];
  List<Book> _finishedBooks = [];
  List<Book> _searchResults = [];
  
  List<Book> get toReadBooks => _toReadBooks;
  List<Book> get readingBooks => _readingBooks;
  List<Book> get finishedBooks => _finishedBooks;
  List<Book> get searchResults => _searchResults;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();
    
    _toReadBooks = await _dbHelper.getBooksByStatus(ReadingStatus.toRead);
    _readingBooks = await _dbHelper.getBooksByStatus(ReadingStatus.reading);
    _finishedBooks = await _dbHelper.getBooksByStatus(ReadingStatus.finished);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await _dbHelper.createBook(book);
    await loadBooks();
  }

  Future<void> updateBook(Book book) async {
    await _dbHelper.updateBook(book);
    await loadBooks();
  }

  Future<void> deleteBook(int id) async {
    await _dbHelper.deleteBook(id);
    await loadBooks();
  }

  Future<void> changeBookStatus(Book book, ReadingStatus newStatus) async {
    final updatedBook = book.copyWith(status: newStatus);
    await _dbHelper.updateBook(updatedBook);
    await loadBooks();
  }

  Future<void> searchBooksByIsbn(String isbn) async {
    _isLoading = true;
    notifyListeners();
    
    final book = await _apiService.getBookByIsbn(isbn);
    _searchResults = book != null ? [book] : [];
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchBooksByQuery(String query) async {
    _isLoading = true;
    notifyListeners();
    
    _searchResults = await _apiService.searchBooks(query);
    
    _isLoading = false;
    notifyListeners();
  }
}
