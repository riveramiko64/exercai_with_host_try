import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:exercai_with_host_try/utils/constant.dart';
import 'package:exercai_with_host_try/utils/constant.dart';
import '../../utils/constant.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print(peopleBox.get('finalcoloriesburn'));
              peopleBox.put('squat',1090);
            },
            icon: Icon(Icons.abc_rounded)),
      ),
    );
  }
}
