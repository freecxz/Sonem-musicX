import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'l10n/app_translations.dart';
import 'screens/home_screen.dart';

void main() => runApp(const FreeczxApp());

class FreeczxApp extends StatefulWidget {
  const FreeczxApp({super.key});

  @override
  State<FreeczxApp> createState() => _FreeczxAppState();
}

class _FreeczxAppState extends State<FreeczxApp> {
  Locale _currentLocale = const Locale('pt');

  void setLocale(Locale locale) {
    setState(() => _currentLocale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freeczx',
      theme: AppTheme.darkTheme,
      locale: _currentLocale,
      supportedLocales: const [Locale('pt'), Locale('en'), Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MainNavigator(setLocale: setLocale),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final Function(Locale) setLocale;
  const MainNavigator({super.key, required this.setLocale});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const Center(child: Text('Busca')),
      const Center(child: Text('Biblioteca')),
      const Center(child: Text('Configurações')),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: AppTranslations.of(context, 'home_tab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            label: AppTranslations.of(context, 'search_tab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_music_outlined),
            label: AppTranslations.of(context, 'library_tab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: AppTranslations.of(context, 'settings_tab'),
          ),
        ],
      ),
    );
  }
}
