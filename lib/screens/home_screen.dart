import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 加载书籍数据
    Future.microtask(() => context.read<BookProvider>().loadBooks());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的书单'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '想看'),
            Tab(text: '阅读中'),
            Tab(text: '已读'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookList(bookProvider.toReadBooks),
              _buildBookList(bookProvider.readingBooks),
              _buildBookList(bookProvider.finishedBooks),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: '添加书籍',
      ),
    );
  }

  Widget _buildBookList(List<Book> books) {
    if (books.isEmpty) {
      return Center(child: Text('暂无书籍'));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 60,
            color: Colors.grey[300],
            child: Icon(Icons.book),
          ),
          title: Text(book.title),
          subtitle: Text('${book.author} - ${book.publishedYear}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
          trailing: PopupMenuButton<ReadingStatus>(
            onSelected: (ReadingStatus status) {
              context.read<BookProvider>().changeBookStatus(book, status);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ReadingStatus>>[
              PopupMenuItem<ReadingStatus>(
                value: ReadingStatus.toRead,
                child: Text('想看'),
              ),
              PopupMenuItem<ReadingStatus>(
                value: ReadingStatus.reading,
                child: Text('阅读中'),
              ),
              PopupMenuItem<ReadingStatus>(
                value: ReadingStatus.finished,
                child: Text('已读'),
              ),
              PopupMenuItem<ReadingStatus>(
                value: ReadingStatus.finished,
                child: Text('删除', style: TextStyle(color: Colors.red)),
                enabled: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
