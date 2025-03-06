import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_details_screen.dart';

class BookList extends StatelessWidget {
  final String category;

  BookList({required this.category});

  @override
  Widget build(BuildContext context) {
    // In a real app, this would fetch books from a database or API
    List<Book> books = _getMockBooks();
    
    return books.isEmpty
        ? Center(child: Text('No books in your $category list'))
        : ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: books[index].coverUrl != null
                    ? Image.network(
                        books[index].coverUrl!,
                        width: 40,
                        errorBuilder: (_, __, ___) => Icon(Icons.book),
                      )
                    : Icon(Icons.book),
                title: Text(books[index].title),
                subtitle: Text(books[index].author),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsScreen(
                        book: books[index],
                        currentStatus: category,
                      ),
                    ),
                  ).then((newStatus) {
                    if (newStatus != null) {
                      // Handle status change in a real app
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book moved to $newStatus list')),
                      );
                    }
                  });
                },
              );
            },
          );
  }

  List<Book> _getMockBooks() {
    // This would be replaced by actual data in the real app
    if (category == 'reading') {
      return [
        Book(id: '1', title: 'Clean Code', author: 'Robert C. Martin', isbn: '9780132350884', description: "test description"),
        Book(id: '2', title: 'Design Patterns', author: 'Gang of Four', isbn: '9780201633610', description:  "test description"),
      ];
    } else if (category == 'done') {
      return [
        Book(id: '3', title: 'The Pragmatic Programmer', author: 'Andrew Hunt'),
      ];
    } else {
      return [
        Book(id: '4', title: 'Refactoring', author: 'Martin Fowler'),
      ];
    }
  }
}
