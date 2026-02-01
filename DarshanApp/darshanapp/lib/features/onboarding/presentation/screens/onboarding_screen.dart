import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';


class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.currentStep == 0 ? 'Select Temples' : 'Daily Routine'),
        leading: state.currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: notifier.previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (state.error != null)
              Container(
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                child: Text(
                  state.error!,
                  style: TextStyle(color: Colors.red.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: IndexedStack(
                index: state.currentStep,
                children: const [
                  _TempleSelectionStep(),
                  _TimingStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (state.currentStep == 0) {
                            notifier.nextStep();
                          } else {
                            notifier.completeOnboarding(context);
                          }
                        },
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : Text(state.currentStep == 0 ? 'Next' : 'Finish Setup'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TempleSelectionStep extends ConsumerWidget {
  const _TempleSelectionStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templesAsync = ref.watch(templesProvider);
    final selectedTemples = ref.watch(onboardingProvider).selectedTemples;
    final notifier = ref.read(onboardingProvider.notifier);

    return templesAsync.when(
      data: (temples) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: temples.length,
          itemBuilder: (context, index) {
            final temple = temples[index];
            final isSelected = selectedTemples.contains(temple.id);
            return Card(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
              shape: RoundedRectangleBorder(
                side: isSelected 
                  ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                  : BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    temple.imageAsset,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.temple_buddhist),
                    ),
                  ),
                ),
                title: Text(temple.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(temple.location),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                    : const Icon(Icons.circle_outlined),
                onTap: () => notifier.toggleTemple(temple.id),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _TimingStep extends ConsumerWidget {
  const _TimingStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Set your daily darshan reminders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ListTile(
            title: const Text('Morning Aarti'),
            trailing: Text(state.morningTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            onTap: () async {
              final time = await showTimePicker(context: context, initialTime: state.morningTime);
              if (time != null) notifier.updateMorningTime(time);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.grey)),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Evening Aarti'),
            trailing: Text(state.eveningTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            onTap: () async {
               final time = await showTimePicker(context: context, initialTime: state.eveningTime);
               if (time != null) notifier.updateEveningTime(time);
            },
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
