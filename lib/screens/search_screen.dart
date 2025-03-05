import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isIsbnSearch = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索书籍'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: _isIsbnSearch ? 'ISBN搜索' : '书名搜索',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                SwitchListTile(
                  title: Text('使用ISBN搜索'),
                  value: _isIsbnSearch,
                  onChanged: (value) {
                    setState(() {
                      _isIsbnSearch = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                if (bookProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (bookProvider.searchResults.isEmpty) {
                  return Center(child: Text('无搜索结果'));
                }
                
                return ListView.builder(
                  itemCount: bookProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.searchResults[index];
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text('${book.author} - ${book.publishedYear}'),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _addBook(book),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(book.title),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('作者: ${book.author}'),
                                  Text('ISBN: ${book.isbn}'),
                                  Text('出版年: ${book.publishedYear}'),
                                  SizedBox(height: 8),
                                  Text('简介: ${book.description}'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('关闭'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text('添加到书单'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _addBook(book);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    if (_isIsbnSearch) {
      context.read<BookProvider>().searchBooksByIsbn(query);
    } else {
      context.read<BookProvider>().searchBooksByQuery(query);
    }
  }

  void _addBook(Book book) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('选择阅读状态'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('想看'),
              onTap: () {
                context.read<BookProvider>().addBook(
                  book.copyWith(status: ReadingStatus.toRead),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已添加到想看列表')),
                );
              },
            ),
            ListTile(
              title: Text('阅读中'),
              onTap: () {
                context.read<BookProvider>().addBook(
                  book.copyWith(status: ReadingStatus.reading),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已添加到阅读中列表')),
                );
              },
            ),
            ListTile(
              title: Text('已读'),
              onTap: () {
                context.read<BookProvider>().addBook(
                  book.copyWith(status: ReadingStatus.finished),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已添加到已读列表')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
