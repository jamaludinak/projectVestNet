import '../screen/SplashScreen.dart';
import '../store/AppStore.dart';
import '../utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/Constant.dart';

AppStore appStore = AppStore();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());
  appStore.toggleDarkMode(value: getBoolAsync('isDarkModeOnPref'));
  defaultRadius = 10;
  defaultToastGravityGlobal = ToastGravity.BOTTOM;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Observer(
      
      builder: (_) => MaterialApp(
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('hi', 'IN'),
          const Locale('ar', 'AR'),
          const Locale('fr', 'FR'),
          const Locale('id', 'ID'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'VESTNET${!isMobile ? ' ${platformName()}' : ''}',
        home: SplashScreen(),
        theme: appStore.isDarkModeOn ? AppThemeData.darkTheme : AppThemeData.lightTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
