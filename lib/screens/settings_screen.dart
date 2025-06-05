import 'package:flutter/material.dart';
import 'package:letzrentnew/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, value, Widget? child) => Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SwitchListTile(
              value: value.isDark!,
              onChanged: (val) => value.toggleTheme(),
              title: Text('Dark mode(Beta)'),
            )
          ],
        ),
      ),
    );
  }
}