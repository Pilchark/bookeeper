// import 'package:flutter/foundation.dart';

enum ReadingStatus {
  toRead,
  reading,
  finished
}

class Book {
  final int? id; // 本地数据库ID
  final String title;
  final String author;
  final String isbn;
  final int publishedYear;
  final String description;
  final ReadingStatus status;
  final DateTime createdAt;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publishedYear,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      author: json['author_data']?[0]?['name'] ?? '',
      isbn: json['isbn'] ?? '',
      publishedYear: int.tryParse(json['date_published']?.substring(0, 4) ?? '0') ?? 0,
      description: json['overview'] ?? '',
      status: ReadingStatus.toRead,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'published_year': publishedYear,
      'description': description,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? isbn,
    int? publishedYear,
    String? description,
    ReadingStatus? status,
    DateTime? createdAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      publishedYear: publishedYear ?? this.publishedYear,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
