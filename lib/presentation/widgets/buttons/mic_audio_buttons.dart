import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/presentation/providers/voice_commands/audio_instructions_provider.dart';
import 'package:smartory_app/presentation/providers/inventory/inventory_user_provider.dart';
import 'package:smartory_app/presentation/widgets/modals/action_section.dart';

import '../../../services/services.dart';

class AudioMedia extends ConsumerStatefulWidget {
  const AudioMedia({super.key});

  @override
  ConsumerState<AudioMedia> createState() => _AudioMediaState();
}

class _AudioMediaState extends ConsumerState<AudioMedia> {
  final AudioService audioService = AudioService();
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

  Future<void> sendAudio() async {
    if (audioPath == null) return;

    showDialog(
      context: context,
      animationStyle: AnimationStyle(
        curve: Curves.bounceIn,
        duration: Duration(milliseconds: 300),
      ),
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return Center(
          child: Container(
            padding: EdgeInsets.all(12),
            width: size.width * 0.8,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12),
                const Center(child: CircularProgressIndicator()),
                Text(
                  'Procesando instrucciones...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    try {
      await ref
          .read(audioInstructionsProvider.notifier)
          .convertAudioToInstructions(audioPath!);
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }

    if (!mounted) return;
    final instructions =
        ref.read(audioInstructionsProvider).value?.instructions ?? [];

    final addItems = instructions
        .where((item) => item.action.toString() == 'add')
        .toList();
    final updateItems = instructions
        .where((item) => item.action.toString() == 'update')
        .toList();
    final removeItems = instructions
        .where((item) => item.action.toString() == 'remove')
        .toList();
    showModalBottomSheet(
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  if (addItems.isNotEmpty)
                    ActionSection(
                      title: 'Productos a agregar',
                      icon: Icons.add_circle_outline,
                      items: addItems,
                    ),

                  if (updateItems.isNotEmpty)
                    ActionSection(
                      title: 'Productos a modificar',
                      icon: Icons.edit_outlined,
                      items: updateItems,
                    ),

                  if (removeItems.isNotEmpty)
                    ActionSection(
                      title: 'Productos a eliminar o descontar',
                      icon: Icons.remove_circle_outline,
                      items: removeItems,
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final rootContext = this.context;

                        Navigator.of(context).pop(); // cierra el bottom sheet

                        showDialog(
                          context: rootContext,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final instructions =
                              ref
                                  .read(audioInstructionsProvider)
                                  .value
                                  ?.instructions ??
                              [];
                          await ref
                              .read(inventoryProvider.notifier)
                              .processInstructions(instructions);

                          if (!mounted) return;

                          Navigator.of(rootContext).pop(); // cierra loading

                          ScaffoldMessenger.of(rootContext).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Inventario actualizado correctamente',
                              ),
                            ),
                          );

                          ref
                              .read(audioInstructionsProvider.notifier)
                              .clearInstructions();
                        } catch (e) {
                          if (!mounted) return;

                          Navigator.of(rootContext).pop(); // cierra loading

                          ScaffoldMessenger.of(rootContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al actualizar inventario: $e',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Confirmar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
  Widget build(BuildContext context) {
    return MicButton(
      key: const ValueKey('mic-button'),
      isRecording: isRecording,
      startRecording: startRecording,
      stopRecording: stopRecording,
      sendAudio: sendAudio,
    );
  }
}

class MicButton extends StatelessWidget {
  const MicButton({
    super.key,
    required this.isRecording,
    required this.startRecording,
    required this.stopRecording,
    required this.sendAudio,
  });

  final bool isRecording;
  final Future<void> Function() startRecording;
  final Future<void> Function() sendAudio;
  final Future<String?> Function() stopRecording;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) async {
        await startRecording();
      },
      onLongPressEnd: (_) async {
        await stopRecording();
        await sendAudio();
      },
      child: AnimatedContainer(
        curve: Curves.easeInSine,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isRecording ? Colors.indigo : Colors.indigoAccent,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: isRecording ? 84 : 74,
          height: isRecording ? 84 : 74,
          child: Icon(Icons.mic_sharp, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
