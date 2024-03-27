import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animestream/ui/pages/search_page.dart';
import 'package:animestream/ui/pages/settings_page.dart';
import 'package:animestream/ui/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var index = 0;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack(
        index: index,
        children: [
          HomePage(),
          const SearchPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Theme.of(context).colorScheme.surface,
          height: 70,
          indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(milliseconds: 1200),
          selectedIndex: index,
          onDestinationSelected: (value) => index == value ? null : setState(() => index = value),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              label: "Cerca",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              label: "Impostazioni",
            ),
          ],
        ),
      ),
    );
  }
}
