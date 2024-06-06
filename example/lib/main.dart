import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeService = ZetaThemeServiceBase.def();

  runApp(
    ZetaExample(
      themeService: themeService,
    ),
  );
}

class ZetaExample extends StatelessWidget {
  const ZetaExample({
    super.key,
    required this.themeService,
  });

  final ZetaThemeService themeService;

  @override
  Widget build(BuildContext context) {
    return ZetaProvider(
      themeService: themeService,
      builder: (context, themeData, themeMode) {
        final dark = themeData.colorsDark.toScheme();
        final light = themeData.colorsLight.toScheme();
        return MaterialApp.router(
          routerConfig: router,
          themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: themeData.fontFamily,
            scaffoldBackgroundColor: light.surfaceTertiary,
            colorScheme: light,
            textTheme: zetaTextTheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: themeData.fontFamily,
            scaffoldBackgroundColor: dark.surfaceTertiary,
            colorScheme: dark,
            textTheme: zetaTextTheme,
          ),
        );
      },
    );
  }
}
