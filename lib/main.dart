import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mmh/blocs/autocomplete/autocomplete_bloc.dart';
import 'package:flutter_mmh/screens/auth/auth_page.dart';
import 'package:flutter_mmh/screens/auth/places_repository.dart';
import 'package:flutter_mmh/services/themes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<PlacesRepository>(
              create: (_) => PlacesRepository(),
            ),
          ],
          child: MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) => AutoCompleteBloc(
                        placesRepository: context.read<PlacesRepository>())
                      ..add(LoadAutoComplete()))
              ],
              child: MaterialApp(
                theme: ThemeData(
                  primaryColor: Colors.white,
                  backgroundColor: Colors.grey[200],
                  fontFamily: 'SourceSansPro-Regular',
                ),
                themeMode: themeProvider.themeMode,
                darkTheme: MyThemes.darkTheme,
                debugShowCheckedModeBanner: false,
                home: AuthPage(),
              )),
        );
      });
}
