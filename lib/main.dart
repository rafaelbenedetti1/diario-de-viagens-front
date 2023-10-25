import 'package:diario_viagens_front/pages/home/main_page.dart';
import 'package:diario_viagens_front/pages/home/mesma.dart';
import 'package:diario_viagens_front/pages/login/login_page.dart';
import 'package:diario_viagens_front/services/auth_service.dart';
import 'package:diario_viagens_front/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBzqsjXBLDRDwZL-Nop8-9_Bi0jJKbl-lI',
          appId: 'diario-viagens-front',
          messagingSenderId: '1090703901751',
          projectId: 'diario-viagens-front'));
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        home: Consumer<AuthService>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const CircularProgressIndicator();
            } else if (provider.user == null) {
              return LoginPage();
            } else {
              return MainPage();
            }
          },
        ));
  }
}
