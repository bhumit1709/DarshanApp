import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../darshan/domain/entities/temple.dart';
import 'package:go_router/go_router.dart';

// State
class OnboardingState {
  final int currentStep;
  final List<String> selectedTemples;
  final TimeOfDay morningTime;
  final TimeOfDay eveningTime;
  final bool isLoading;
  final String? error;
  
  const OnboardingState({
    this.currentStep = 0,
    this.selectedTemples = const [],
    this.morningTime = const TimeOfDay(hour: 7, minute: 0),
    this.eveningTime = const TimeOfDay(hour: 19, minute: 0),
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    int? currentStep,
    List<String>? selectedTemples,
    TimeOfDay? morningTime,
    TimeOfDay? eveningTime,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedTemples: selectedTemples ?? this.selectedTemples,
      morningTime: morningTime ?? this.morningTime,
      eveningTime: eveningTime ?? this.eveningTime,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingNotifier(this.ref) : super(const OnboardingState());

  void nextStep() {
     if (state.currentStep == 0 && state.selectedTemples.isEmpty) {
       state = state.copyWith(error: "Please select at least one temple");
       return;
     }
     state = state.copyWith(currentStep: state.currentStep + 1, error: null);
  }
  
  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1, error: null);
    }
  }

  void toggleTemple(String templeId) {
    if (state.selectedTemples.contains(templeId)) {
      state = state.copyWith(
        selectedTemples: List.from(state.selectedTemples)..remove(templeId),
        error: null,
      );
    } else {

      state = state.copyWith(
        selectedTemples: List.from(state.selectedTemples)..add(templeId),
        error: null,
      );
    }
  }

  void updateMorningTime(TimeOfDay time) {
    state = state.copyWith(morningTime: time);
  }

  void updateEveningTime(TimeOfDay time) {
    state = state.copyWith(eveningTime: time);
  }

  Future<void> completeOnboarding(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      final userPrefs = ref.read(userPreferencesServiceProvider);
      final notificationService = ref.read(notificationServiceProvider);

      await userPrefs.setSelectedTemples(state.selectedTemples);
      // await userPrefs.setNotificationTimes(...) // Missing in service currently
      await userPrefs.setOnboardingCompleted(true);
      await userPrefs.setNotificationsEnabled(true);

      // Schedule notifications
      await notificationService.scheduleDailyNotification(
        id: 1, 
        title: "Morning Darshan", 
        body: "Start your day with blessings 🙏", 
        time: state.morningTime
      );
       await notificationService.scheduleDailyNotification(
        id: 2, 
        title: "Evening Darshan", 
        body: "Time for evening prayers 🪔", 
        time: state.eveningTime
      );

      if (context.mounted) {
        context.go('/home');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

final templesProvider = FutureProvider<List<Temple>>((ref) async {
  final repo = ref.read(templeRepositoryProvider);
  return repo.getTemples();
});
