import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_web_app/core/widgets/accent_border_chip.dart';
import 'package:my_portfolio_web_app/core/widgets/constrained_width.dart';
import 'package:my_portfolio_web_app/features/skills/presentation/providers/skills_providers.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(skillCategoriesProvider);

    return SafeArea(
      child: ConstrainedWidth(
        maxWidth: 900,
        child: categoriesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 96),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 96),
            child: Center(child: Text('Failed to load skills: $err')),
          ),
          data: (categories) => SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: category.skills
                            .map((skill) => AccentBorderChip(label: skill))
                            .toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
