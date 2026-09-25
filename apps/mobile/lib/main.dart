import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shilpsetu/core/firebase/firebase_options.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/router/app_router.dart';
import 'package:shilpsetu/core/theme/app_theme.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('🔥 Firebase initialized successfully for project: ${app.options.projectId}');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization status: $e');
  }
  runApp(const ProviderScope(child: ShilpsetuApp()));
}

class ShilpsetuApp extends ConsumerWidget {
  const ShilpsetuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final langState = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Shilpsetu',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      locale: langState.selectedLanguage.locale,
      supportedLocales: SupportedLocales.phase1,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
