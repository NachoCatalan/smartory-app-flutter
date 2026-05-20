import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/presentation/providers/repositories/inventory_repository_provider.dart';

class AudioInstructionsState {
  final List<InventoryInstruction>? instructions;

  AudioInstructionsState({this.instructions = const []});

  AudioInstructionsState copyWith({List<InventoryInstruction>? instructions}) {
    return AudioInstructionsState(
      instructions: instructions ?? this.instructions,
    );
  }
}

class AudioInstructionsNotifier extends AsyncNotifier<AudioInstructionsState> {
  @override
  FutureOr<AudioInstructionsState> build() {
    return AudioInstructionsState();
  }

  Future<void> convertAudioToInstructions(String audioPath) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final instructions = await ref
          .read(inventoryRepositoryProvider)
          .convertAudioToInstructions(audioPath);
      return AudioInstructionsState(instructions: instructions);
    });
  }

  void clearInstructions() {
    state = AsyncData(AudioInstructionsState());
  }
}

final audioInstructionsProvider =
    AsyncNotifierProvider<AudioInstructionsNotifier, AudioInstructionsState>(
      AudioInstructionsNotifier.new,
    );
