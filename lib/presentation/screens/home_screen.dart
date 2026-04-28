import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/presentation/providers/providers.dart';

import 'package:smartory_app/presentation/screens/screens.dart';
import 'package:smartory_app/services/services.dart';

import '../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final productProvider = ref.read(productsProvider.notifier);
    final logout = ref.read(authProvider.notifier).logout;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              productProvider.loadProducts();
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => InventoryScreen()),
              );
            },
            icon: Icon(Icons.inventory_2_sharp),
            color: Colors.indigo,
            iconSize: 35,
          ),
        ],
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ProductCarrousel(screenSize: screenSize)],
            ),
          ),
        ),
      ),

      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 1,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.2, color: Colors.indigo),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Home', style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Inventory', style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () async {
                  await logout();
                },
                child: Text('Cerrar sesión', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MediaActionBar(),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        height: 50,
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(width: 70), // espacio para el botón central
              Expanded(
                child: IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.inventory_2_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaActionBar extends StatefulWidget {
  const MediaActionBar({super.key});

  @override
  State<MediaActionBar> createState() => _MediaActionBarState();
}

class _MediaActionBarState extends State<MediaActionBar> {
  final AudioService audioService = AudioService();
  final AudioPlayerService audioPlayerService = AudioPlayerService();
  final SendAudioService sendAudioService = SendAudioService();

  bool isRecording = false;
  String? audioPath;

  Future<void> startRecording() async {
    await audioService.startRecording();
    setState(() {
      isRecording = true;
      audioPath = null;
    });
  }

  Future<String?> stopRecording() async {
    final path = await audioService.stopRecording();
    setState(() {
      isRecording = false;
      audioPath = path;
    });
    return path;
  }

  Future<void> sendAudio() async {
    await sendAudioService.sendAudio(audioPath!);
  }

  Future<void> deleteAudio() async {
    try {
      File file = File(audioPath!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          audioPath = null;
        });
      }
    } catch (e) {
      throw Exception('Error al eliminar audio');
    }
  }

  @override
  void initState() {
    super.initState();
    audioService.init();
  }

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioMedia();
  }
}
