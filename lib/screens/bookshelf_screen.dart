import 'package:flutter/material.dart';
import '../widgets/book_list.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          tabs: [
            Tab(text: 'Wanted'),
            Tab(text: 'Reading'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookList(category: 'wanted'),
          BookList(category: 'reading'),
          BookList(category: 'finished'),
        ],
      ),
    );
  }
}
