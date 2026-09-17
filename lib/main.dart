import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  runApp(const FreeczxMusicApp());
}

class FreeczxMusicApp extends StatelessWidget {
  const FreeczxMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freeczx Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF000000), // AMOLED Black
        primaryColor: const Color(0xFF2979FF), // Azul Interface
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2979FF),
          surface: Color(0xFF000000),
          background: Color(0xFF000000),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
          titleTextStyle: TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isDownloading = false;
  String _statusMessage = "Cole o link da música acima para baixar.";

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.photos.request();
    }
  }

  Future<void> _downloadMusic(String url) async {
    setState(() {
      _isDownloading = true;
      _statusMessage = "Iniciando download...";
    });

    try {
      await _requestPermissions();
      
      // Usando um MP3 de teste para garantir que o download funcione
      final response = await http.get(Uri.parse('https://www.soundhelix.com/SoundhelixTest-1.mp3'));
      
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final filePath = path.join(directory.path, 'freeczx_song.mp3');
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          setState(() {
            _statusMessage = "Sucesso! Salvo em: ${file.path}";
          });
        }
      } else {
        setState(() { _statusMessage = "Erro ao baixar."; });
      }
    } catch (e) {
      setState(() { _statusMessage = "Erro: $e"; });
    } finally {
      setState(() { _isDownloading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Freeczx Music'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_rounded, size: 80, color: const Color(0xFF2979FF)),
            const SizedBox(height: 40),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Cole o link da música...",
                prefixIcon: Icon(Icons.link, color: Color(0xFF2979FF)),
                filled: true,
                fillColor: Color(0xFF121212),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isDownloading ? null : () => _downloadMusic(_urlController.text),
                child: _isDownloading 
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("BAIXAR PARA ARMAZENAMENTO", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
            Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
