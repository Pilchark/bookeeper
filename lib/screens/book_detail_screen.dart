import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 220,
                color: Colors.grey[300],
                child: Icon(Icons.book, size: 50),
              ),
            ),
            SizedBox(height: 16),
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              '作者: ${book.author}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text('ISBN: ${book.isbn}'),
            Text('出版年份: ${book.publishedYear}'),
            SizedBox(height: 16),
            Text(
              '阅读状态',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            _buildStatusDropdown(context),
            SizedBox(height: 16),
            Text(
              '简介',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(book.description),
            SizedBox(height: 16),
            Text('添加日期: ${_formatDate(book.createdAt)}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return DropdownButton<ReadingStatus>(
      value: book.status,
      isExpanded: true,
      onChanged: (ReadingStatus? newStatus) {
        if (newStatus != null) {
          context.read<BookProvider>().changeBookStatus(book, newStatus);
        }
      },
      items: [
        DropdownMenuItem(
          value: ReadingStatus.toRead,
          child: Text('想看'),
        ),
        DropdownMenuItem(
          value: ReadingStatus.reading,
          child: Text('阅读中'),
        ),
        DropdownMenuItem(
          value: ReadingStatus.finished,
          child: Text('已读'),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除'),
        content: Text('您确定要从书单中删除《${book.title}》吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              context.read<BookProvider>().deleteBook(book.id!);
              Navigator.pop(context); // 返回上一页
            },
            child: Text('删除'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
