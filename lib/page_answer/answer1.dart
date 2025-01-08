import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grid Layout'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 100, height: 100, color: Colors.red),
                    Container(width: 100, height: 100, color: Colors.green),
                    Container(width: 100, height: 100, color: Colors.blue)
                  ],
                ),
                const SizedBox(height: 20), //space between row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 100, height: 100, color: Colors.orange),
                    Container(width: 100, height: 100, color: Colors.purple),
                    Container(width: 100, height: 100, color: Colors.yellow)
                  ],
                ),
              ],
            )));
  }
}