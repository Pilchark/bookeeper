import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        isbn TEXT NOT NULL,
        published_year INTEGER NOT NULL,
        description TEXT,
        status INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> createBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<Book?> getBook(int id) async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _bookFromMap(maps.first);
    }
    return null;
  }

  Future<List<Book>> getBooksByStatus(ReadingStatus status) async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'status = ?',
      whereArgs: [status.index],
    );

    return List.generate(maps.length, (i) {
      return _bookFromMap(maps[i]);
    });
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final maps = await db.query('books');

    return List.generate(maps.length, (i) {
      return _bookFromMap(maps[i]);
    });
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Book _bookFromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      isbn: map['isbn'],
      publishedYear: map['published_year'],
      description: map['description'],
      status: ReadingStatus.values[map['status']],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
