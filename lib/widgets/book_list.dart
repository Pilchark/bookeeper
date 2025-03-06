import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_details_screen.dart';
import '../services/book_service.dart';

class BookList extends StatefulWidget {
  final String category;

  BookList({required this.category});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final BookService _bookService = BookService();
  List<Book>? _books;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }
  
  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });
    
    final books = await _bookService.getBooksByStatus(widget.category);
    
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_books == null || _books!.isEmpty) {
      return Center(child: Text('No books in your ${widget.category} list'));
    }
    
    return RefreshIndicator(
      onRefresh: _loadBooks,
      child: ListView.builder(
        itemCount: _books!.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: _books![index].coverUrl != null
                ? Image.network(
                    _books![index].coverUrl!,
                    width: 40,
                    errorBuilder: (_, __, ___) => Icon(Icons.book),
                  )
                : Icon(Icons.book),
            title: Text(_books![index].title),
            subtitle: Text(_books![index].author),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(
                    book: _books![index],
                    currentStatus: widget.category,
                  ),
                ),
              ).then((newStatus) {
                if (newStatus != null) {
                  // Handle status change
                  _bookService.addBookToCollection(_books![index], newStatus.toString())
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Book moved to $newStatus list')),
                    );
                    // Reload the list to show updated data
                    _loadBooks();
                  });
                }
              });
            },
          );
        },
      ),
    );
  }
}
