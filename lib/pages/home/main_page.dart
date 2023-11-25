import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:diario_viagens_front/pages/home/home_page.dart';
import 'package:diario_viagens_front/pages/viagem/cadastro/add_viagem_page.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final screens = [HomePage(), AddViagemPage()];

  final iconList = [
    Icons.airplanemode_active,
    Icons.add_a_photo,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: 2,
          tabBuilder: (int index, bool isActive) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  color: isActive
                      ? Color.fromARGB(100, 129, 129, 129)
                      : Colors.transparent),
              child: Column(
                children: [
                  const SizedBox(height: 2),
                  Icon(
                    iconList[index],
                    size: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      index == 0 ? "Viagens" : "Adicionar Viagem",
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            );
          },
          activeIndex: currentIndex,
          leftCornerRadius: 20,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          blurEffect: true,
          rightCornerRadius: 20,
          onTap: (index) => setState(() => currentIndex = index),
          elevation: 16,
          backgroundColor: theme.primaryColor,
          gapLocation: GapLocation.center,
        ),
      ),
    );
  }
}
