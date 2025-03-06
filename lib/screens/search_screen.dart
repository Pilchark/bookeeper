import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BookService _bookService = BookService();
  bool _isSearching = false;
  Book? _foundBook;
  String? _errorMessage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for books...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) {
                      _performSearch(value);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    _showScanOptions();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)));
    } else if (_foundBook != null) {
      return _buildBookResult(_foundBook!);
    } else {
      return Center(child: Text('Enter a book name or ISBN to search'));
    }
  }
  
  Widget _buildBookResult(Book book) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: book.coverUrl != null
            ? Image.network(
                book.coverUrl!,
                width: 50,
                errorBuilder: (_, __, ___) => Icon(Icons.book, size: 50),
              )
            : Icon(Icons.book, size: 50),
        title: Text(book.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author),
            if (book.publisher != null) Text('Publisher: ${book.publisher}'),
            if (book.isbn != null) Text('ISBN: ${book.isbn}'),
          ],
        ),
        isThreeLine: true,
        trailing: ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            _addBookToWanted(book);
          },
        ),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _foundBook = null;
    });
    
    _bookService.searchByTitle(query).then((books) {
      setState(() {
        _isSearching = false;
        if (books.isNotEmpty) {
          _foundBook = books.first;
        } else {
          _errorMessage = 'No books found for "$query"';
        }
      });
    }).catchError((error) {
      setState(() {
        _isSearching = false;
        _errorMessage = 'Error searching: $error';
      });
    });
  }

  void _searchByIsbn(String isbn) {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _foundBook = null;
    });
    
    _bookService.searchByIsbn(isbn).then((book) {
      setState(() {
        _isSearching = false;
        if (book != null) {
          _foundBook = book;
        } else {
          _errorMessage = 'No book found with ISBN "$isbn"';
        }
      });
    }).catchError((error) {
      setState(() {
        _isSearching = false;
        _errorMessage = 'Error searching: $error';
      });
    });
  }
  
  void _addBookToWanted(Book book) {
    _bookService.addBookToCollection(book, 'wanted').then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} added to your "Want to Read" list')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add book'), backgroundColor: Colors.red),
        );
      }
    });
  }

  void _showScanOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Scan ISBN with camera'),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, this would open the camera scanner
                },
              ),
              ListTile(
                leading: Icon(Icons.keyboard),
                title: Text('Enter ISBN manually'),
                onTap: () {
                  Navigator.pop(context);
                  _showIsbnInputDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIsbnInputDialog() {
    final TextEditingController isbnController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter ISBN'),
          content: TextField(
            controller: isbnController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'ISBN number'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isbnController.text.isNotEmpty) {
                  _searchByIsbn(isbnController.text);
                }
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
