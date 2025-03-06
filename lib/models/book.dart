// import 'package:flutter/foundation.dart';

enum ReadingStatus {
  toRead,
  reading,
  finished
}

class Book {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final String? language;
  final String? publisher;
  final DateTime? publishedDate;
  final String? isbn;
  final String? description;
  final DateTime? createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.language,
    this.publisher,
    this.publishedDate,
    this.isbn,
    this.description,
    this.createdAt,
  });
  
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['isbn'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverUrl: json['coverUrl'],
      language: json['language'],
      publisher: json['publisher'],
      publishedDate: json['published_date'] != null 
          ? DateTime.tryParse(json['published_date'])
          : null,
      isbn: json['isbn'],
      description: json['description'],
      createdAt: DateTime.now(),
    );
  }
}
