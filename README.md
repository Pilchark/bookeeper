# Bookeeper

> Personal Bookshelf Management App Design Document

## Overview
A mobile application for managing personal reading lists with remote book search capabilities and local storage.

## Technical Stack
- Language: Dart
- Framework: Flutter
- Database: SQLite (local storage)
- API: ISBN DB API (https://isbndb.com/book)

## Main Features

### 1. Navigation Structure
- Bottom Navigation Bar with 3 tabs:
  - Bookshelf (Book icon)
  - Search (Magnifying glass icon)
  - Me (Profile icon)

### 2. Bookshelf Screen
- Top Tab Navigation with 3 categories:
  - Reading
  - Read
  - Want to Read
- Each tab displays a list of books in respective status
- Book card displays:
  - Cover image
  - Title
  - Author
  - Published year

### 3. Search Screen
- Search bar with text input
- ISBN scanning feature
  - Camera scanner for ISBN
  - Manual ISBN input option
- Search results display
- Add to library functionality

### 4. Profile Screen
- Theme settings
  - Default
  - Light
  - Dark
- App version information
- User preferences

## Data Model

```dart
class Book {
  final String title;
  final String author;
  final String isbn;
  final int publishedYear;
  final String description;
  final String status; // "reading", "read", "want_to_read"
  final DateTime createdAt;
}
```

## Database Schema

```sql
CREATE TABLE books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  isbn TEXT UNIQUE,
  published_year INTEGER,
  description TEXT,
  status TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## API Integration
- ISBN DB API for book search and metadata
- Endpoints:
  - Book search by title
  - Book search by ISBN
  - Book metadata retrieval

## UI/UX Flow
1. Bookshelf (Main Screen)
   - Display books in respective status tabs
   - Swipe actions for status change
   
2. Search
   - Text search
   - ISBN scan/input
   - Results display with add option

3. Profile
   - Theme selection
   - Version info display

## Future Considerations
- Book reading progress tracking
- Reading statistics
- Social sharing features
- Cloud sync
- Reading notes/highlights

This design provides a foundation for a functional book management application while maintaining simplicity and essential features.
