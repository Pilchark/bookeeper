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
  final String status; // New field for tracking reading status

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
    this.status = 'wanted', // Default status is 'wanted'
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
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'])
          : DateTime.now(),
      status: json['status'] ?? 'wanted',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
      'language': language,
      'publisher': publisher,
      'published_date': publishedDate?.toIso8601String(),
      'isbn': isbn,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
    };
  }
}
