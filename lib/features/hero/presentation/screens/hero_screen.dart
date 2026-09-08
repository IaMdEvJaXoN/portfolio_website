import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_portfolio_web_app/core/theme/app_colors.dart';
import 'package:my_portfolio_web_app/core/theme/app_typography.dart';
import 'package:my_portfolio_web_app/core/utils/greetings_determiner.dart';
import 'package:my_portfolio_web_app/core/widgets/constrained_width.dart';
import 'package:my_portfolio_web_app/features/hero/domain/entities/hero_profile_entity.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/providers/greetings_provider.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/providers/hero_providers.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/widgets/contact_button_row.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/widgets/typewriter_text.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/widgets/fade_in_text.dart';
import 'package:my_portfolio_web_app/features/hero/presentation/widgets/drop_in_text.dart';

class HeroScreen extends ConsumerWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(heroProfileProvider);

    return SafeArea(
      child: ConstrainedWidth(
        child: profileAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 96),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 96),
            child: Center(child: Text('Failed to load profile: $err')),
          ),
          data: (profile) => LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final left = _LeftColumn(profile: profile);
              final right = const _RightColumn();
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: 16,
                ),
                child: isNarrow
                    ? Column(
                        children: [left, const SizedBox(height: 32), right],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: left),
                          Expanded(child: right),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LeftColumn extends ConsumerStatefulWidget {
  const _LeftColumn({required this.profile});
  final HeroProfileEntity profile;

  @override
  ConsumerState<_LeftColumn> createState() => _LeftColumnState();
}

class _LeftColumnState extends ConsumerState<_LeftColumn> {
  // Beat of stillness between each stage of the sequence.
  static const _gap = Duration(milliseconds: 150);
  static const _nameCharDuration = Duration(milliseconds: 140);
  static const _greetingDuration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    final currentTime = ref.watch(randomGreetingsProvider);
    final greetingText = GreetingsDeterminer.determineGreeting(currentTime);

    final nameDuration = TypewriterText.totalDuration(
      widget.profile.name,
      _nameCharDuration,
      Duration.zero,
    );
    final greetingStart = nameDuration + _gap;
    final greetingTotal = FadeInText.totalDuration(
      _greetingDuration,
      greetingStart,
    );
    final mantraStart = greetingTotal + _gap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 54,
              backgroundColor: AppColors.surface,
              backgroundImage: widget.profile.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.profile.avatarUrl)
                  : null,
              onBackgroundImageError: widget.profile.avatarUrl.isNotEmpty
                  ? (_, _) {}
                  : null,
              child: widget.profile.avatarUrl.isEmpty
                  ? const Icon(
                      Icons.person_outline,
                      color: AppColors.textSecondary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FadeInText(
                text: greetingText,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                duration: _greetingDuration,
                startDelay: greetingStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TypewriterText(
          text: widget.profile.name,
          style: Theme.of(context).textTheme.displayLarge,
          characterDuration: _nameCharDuration,
        ),
        const SizedBox(height: 8),
        Text(
          widget.profile.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        DropInText(
          text: '> ${widget.profile.mantra}',
          style: AppTypography.mono,
          startDelay: mantraStart,
        ),
        const SizedBox(height: 32),
        ContactButtonRow(
          email: widget.profile.email,
          linkedinUrl: widget.profile.linkedinUrl,
          whatsappUrl: widget.profile.whatsappUrl,
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.transparent, Colors.black],
        stops: [0.0, 0.25],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: SvgPicture.asset('assets/svg_images/g2.svg', fit: BoxFit.contain),
    );
  }
}
