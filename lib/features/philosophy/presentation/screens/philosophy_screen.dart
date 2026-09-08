import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/widgets/constrained_width.dart';
import 'package:my_portfolio_web_app/features/philosophy/presentation/providers/philosophy_providers.dart';

class PhilosophyScreen extends ConsumerWidget {
  const PhilosophyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final philosophyAsync = ref.watch(philosophyProvider);

    return SafeArea(
      child: ConstrainedWidth(
        maxWidth: 700,
        child: philosophyAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 96),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 96),
            child: Center(child: Text('Failed to load philosophy: $err')),
          ),
          data: (philosophy) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: MarkdownBody(
              data: philosophy.contentMarkdown,
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyLarge,
                h2: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 32),
                blockquoteDecoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.accent, width: 4),
                  ),
                ),
                blockquotePadding: const EdgeInsets.only(
                  left: 16,
                  top: 8,
                  bottom: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
