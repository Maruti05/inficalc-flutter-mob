import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/converter_provider.dart';
import 'providers/science_provider.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_entry_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait only to preserve 'Cosmic Precision' layout
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConverterProvider()),
        ChangeNotifierProvider(create: (_) => ScienceProvider()),
      ],
      child: const InfiCalcApp(),
    ),
  );
}

class InfiCalcApp extends StatelessWidget {
  const InfiCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InfiCalc',
        theme: CosmicTheme.getTheme(isDark, themeProvider.palette),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/main': (context) => const MainEntryScreen(),
        },
      ),
    );
  }
}
