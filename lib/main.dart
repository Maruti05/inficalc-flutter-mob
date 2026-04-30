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
  
  // Set edge-to-edge mode for Android to allow content to flow under system bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Lock orientation to portrait only
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

    // Use a more robust SystemUiOverlayStyle definition
    final systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
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
