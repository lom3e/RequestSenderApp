import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RequestSenderAPP',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _customTextController = TextEditingController();
  String baseUrl = '';

  Future<void> sendCommand(String keys) async {
    if (baseUrl.isEmpty) {
      print('URL is empty');
      return;
    }
    final url = '$baseUrl/command?$keys';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Keys sent successfully: $keys');
      } else {
        print('Failed to send keys: $keys');
      }
    } catch (e) {
      print('Error sending keys: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RequestSenderAPP'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.keyboard),
              title: const Text('Keyboard Simulator'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KeyboardSimulatorPage(sendCommand: sendCommand)),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Enter URL',
            ),
            onChanged: (value) {
              setState(() {
                baseUrl = value;
              });
            },
          ),
          const SizedBox(height: 20),
          const Text('Combinazioni di tasti', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton.icon(
                onPressed: () => sendCommand('GUI+R'),
                icon: const Icon(Icons.launch),
                label: const Text('WIN+R'),
              ),
              ElevatedButton.icon(
                onPressed: () => sendCommand('CTRL+SHIFT+ENTER'),
                icon: const Icon(Icons.launch),
                label: const Text('CTRL+SHIFT+ENTER'),
              ),
              ElevatedButton.icon(
                onPressed: () => sendCommand('ALT+F4'),
                icon: const Icon(Icons.launch),
                label: const Text('ALT+F4'),
              ),
              ElevatedButton.icon(
                onPressed: () => sendCommand('CTRL+SHIFT+ESC'),
                icon: const Icon(Icons.launch),
                label: const Text('CTRL+SHIFT+ESC'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Scrittura di testo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton(
                onPressed: () => sendCommand('writeText=Hello'),
                child: const Text('Hello'),
              ),
              ElevatedButton(
                onPressed: () => sendCommand('writeText=world'),
                child: const Text('world'),
              ),
              ElevatedButton(
                onPressed: () => sendCommand('writeText=\b'),
                child: const Text('Backspace'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _customTextController,
            decoration: const InputDecoration(
              labelText: 'Enter custom text',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final customText = _customTextController.text;
              sendCommand('writeText=$customText');
            },
            child: const Text('Send Custom Text'),
          ),
          const SizedBox(height: 20),
          const Text('Esecuzione preimpostata', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton(
                onPressed: () => sendCommand('runCommand=cmd'),
                child: const Text('Apri CMD'),
              ),
              ElevatedButton(
                onPressed: () => sendCommand('runCommand=powershell'),
                child: const Text('Apri PowerShell'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KeyboardSimulatorPage extends StatelessWidget {
  final Future<void> Function(String) sendCommand;

  const KeyboardSimulatorPage({super.key, required this.sendCommand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Simulator'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Invia sequenze di tasti', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton(
                onPressed: () => sendCommand('writeText=\b'),
                child: const Text('Backspace'),
              ),
              ElevatedButton(
                onPressed: () => sendCommand('writeText=Hello\b\b\b'),
                child: const Text('Hello\b\b\b'),
              ),
              // Aggiungi altri pulsanti qui per altre sequenze di tasti
            ],
          ),
        ],
      ),
    );
  }
}
