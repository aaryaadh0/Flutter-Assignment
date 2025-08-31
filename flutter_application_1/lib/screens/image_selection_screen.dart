import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_selection_data.dart';

class ImageSelectionScreen extends StatelessWidget {
  const ImageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageSelectionData>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFBFA), // very light cream
              Color(0xFFFFF0EC), // very soft peachy-pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 250,
                      minWidth: 200,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 213, 194, 194),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 122, 122, 122).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: imageProvider.selectedImageUrl != null
                          ? Image.network(
                              imageProvider.selectedImageUrl!,
                              fit: BoxFit.cover,  // image fills container nicely
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Center(
                              child: Text(
                                'No image selected',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 10, 9, 9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,),),),),),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    onPressed: imageProvider.pickImageWeb,
                    icon: const Icon(Icons.photo_library_outlined, size: 28),
                    label: const Text(
                      'Select from Gallery',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 231, 124, 160),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 7,
                      shadowColor: Colors.pink.shade200,),),
                  const SizedBox(height: 18),
                  Text(
                    'Supported formats: JPG, PNG, GIF',
                    style: TextStyle(
                      color: Colors.pink.shade200,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,),)],),),),),),);}}
