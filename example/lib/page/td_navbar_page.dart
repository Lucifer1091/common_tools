import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../base/example_widget.dart';

class MyNavBarPage extends StatefulWidget {
  const MyNavBarPage({super.key});

  @override
  State<MyNavBarPage> createState() => _MyNavBarPageState();
}

class _MyNavBarPageState extends State<MyNavBarPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      exampleCodeGroup: 'navbar',
      desc: 'A widget that displays a bar with navigation buttons and labels.',
      bottomNavigationBar: MyNavBar(
        currentIndex: _currentIndex,
        bottombarAlignment: MainAxisAlignment.spaceEvenly,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          MyNavBarItem(
            icon: Icon(LucideIcons.house),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),
          MyNavBarItem(
            icon: Icon(LucideIcons.heart),
            title: Text("Likes"),
            selectedColor: Colors.pink,
          ),
          MyNavBarItem(
            icon: Icon(LucideIcons.search),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),
          MyNavBarItem(
            icon: Icon(LucideIcons.user),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      children: [
        ExampleModule(
          title: 'Basic Usage',
          children: [
            ExampleItem(
              desc: 'My Lazy Indexed Stack',
              builder: (context) {
                return MyIndexedStack(
                  index: _currentIndex,
                  animate: false,
                  children: List.generate(4, (index) {
                    return Container(
                      height: 500,
                      width: 500,
                      color: MyColors.pick(index),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
