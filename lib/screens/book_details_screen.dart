import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  final String currentStatus;

  const BookDetailsScreen({
    Key? key,
    required this.book,
    required this.currentStatus,
  }) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool _expandedDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book title in H1 size
            Text(
              widget.book.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16.0),
            
            // Author in bold
            Text(
              widget.book.author,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            
            // ISBN with copy button
            if (widget.book.isbn != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ISBN: ${widget.book.isbn}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    tooltip: 'Copy ISBN',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.book.isbn ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ISBN copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            
            // Description with expand/collapse functionality
            if (widget.book.description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedDescription = !_expandedDescription;
                      });
                    },
                    child: Text(
                      widget.book.description ?? '',
                      maxLines: _expandedDescription ? null : 3,
                      overflow: _expandedDescription ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.book.description != null && 
                      widget.book.description!.length > 100)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _expandedDescription = !_expandedDescription;
                        });
                      },
                      child: Text(_expandedDescription ? 'Show less' : 'Show more'),
                    ),
                ],
              ),
            SizedBox(height: 24.0),
            
            // Status selection buttons
            Text(
              'Reading Status:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusButton('wanted', 'Want to Read'),
                _buildStatusButton('reading', 'Reading'),
                _buildStatusButton('done', 'Finished'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status, String label) {
    bool isCurrentStatus = widget.currentStatus == status;
    
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isCurrentStatus ? Theme.of(context).primaryColor : Colors.grey[300],
        foregroundColor: isCurrentStatus ? Colors.white : Colors.black87,
      ),
      onPressed: isCurrentStatus ? null : () => _confirmStatusChange(status),
      child: Text(label),
    );
  }

  void _confirmStatusChange(String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Book Status'),
        content: Text('Do you want to move "${widget.book.title}" to your $newStatus list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Here would be the code to update the book's status
              // For now, just close the dialog and go back
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, newStatus); // Return to previous screen with new status
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
