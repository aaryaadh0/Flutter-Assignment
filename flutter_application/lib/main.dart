import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/image_selection_data.dart';
import 'screens/image_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageSelectionData(),
      child: MaterialApp(
        title: 'Image Picker Web Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.deepPurpleAccent,
            secondary: Colors.tealAccent,
            surface: Colors.grey[850]!,
            background: Colors.grey[900]!,
          ),
        ),
        home: const ImageSelectionScreen(),
      ),
    );
  }
}
