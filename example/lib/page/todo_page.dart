import 'package:flutter/material.dart';
import 'package:common_tools/index.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          trackVisibility: WidgetStateProperty.all(true),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(16),
                child: const MyText(
                  'Welcome to TDesign! This component is currently in the planning stages. Please stay tuned for the latest updates on the TDesign project.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
