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


## release notes

### 0.0.1

Solution for BookKeeper App
- Update the Book model to include a status field
- Enhance BookService to use SharedPreferences for storing books
- Update the SearchScreen to show a status selection dialog
- Modify BookList to read from local storage instead of mock data

## Deployment Guide

### Deploying on Vercel

#### Prerequisites
- Node.js and npm installed
- Vercel CLI: `npm i -g vercel`
- Flutter SDK

#### Build the Flutter Web App
1. Make sure your Flutter is set up for web:
   ```bash
   flutter config --enable-web
   ```

2. Build the web version:
   ```bash
   flutter build web --release
   ```

#### Deploy to Vercel
1. Initialize a Vercel project in the build directory:
   ```bash
   cd build/web
   vercel login
   vercel
   ```

2. Follow the interactive prompts:
   - Set up and deploy: `Y`
   - Select your account
   - Link to existing project: `N`
   - Project name: `bookeeper-app` (or your preferred name)
   - Framework preset: `Other`
   - Override settings: `N`

3. Your app will be deployed and a URL will be provided.

#### Configuration
1. For custom domains, go to the Vercel dashboard > your project > Settings > Domains
2. For environment variables, go to Settings > Environment Variables

#### Production API Update
The app is configured to use the production API at: `https://vercial-test.vercel.app/random`

#### Continuous Deployment
For automatic deployments when you push to GitHub:
1. Connect your GitHub repo to Vercel in the dashboard
2. Configure build settings:
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
   - Install Command: Leave empty
