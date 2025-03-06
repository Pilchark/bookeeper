
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTheme = 'Default';
  final String _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Me'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User Profile'),
            subtitle: Text('Manage your account'),
            onTap: () {
              // Navigate to profile details
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            subtitle: Text(_selectedTheme),
            onTap: () {
              _showThemeOptions();
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version'),
            subtitle: Text(_appVersion),
          ),
        ],
      ),
    );
  }

  void _showThemeOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Default'),
                leading: Radio<String>(
                  value: 'Default',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    _setTheme(value);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Light'),
                leading: Radio<String>(
                  value: 'Light',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    _setTheme(value);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Dark'),
                leading: Radio<String>(
                  value: 'Dark',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    _setTheme(value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setTheme(String? theme) {
    if (theme != null) {
      setState(() {
        _selectedTheme = theme;
      });
      
      // In a real app, this would actually change the app theme
    }
  }
}
