import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_web_app/core/widgets/constrained_width.dart';
import 'package:my_portfolio_web_app/features/domains/presentation/providers/domains_providers.dart';
import 'package:my_portfolio_web_app/features/domains/presentation/widgets/domain_carousel_card.dart';

class DomainsCarouselScreen extends ConsumerStatefulWidget {
  const DomainsCarouselScreen({super.key});

  @override
  ConsumerState<DomainsCarouselScreen> createState() =>
      _DomainsCarouselScreenState();
}

class _DomainsCarouselScreenState extends ConsumerState<DomainsCarouselScreen> {
  late final PageController _controller = PageController(
    viewportFraction: 0.55,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final domainsAsync = ref.watch(domainsListProvider);

    return SafeArea(
      child: ConstrainedWidth(
        child: domainsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Failed to load domains: $err',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          data: (domains) {
            if (domains.isEmpty) {
              return const Center(child: Text('No domains yet.'));
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight * 0.7,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: domains.length,
                    itemBuilder: (context, index) {
                      // Handles both the initial-frame fix (forces one
                      // rebuild once layout has dimensions) and ongoing
                      // scroll-driven updates (via AnimatedBuilder).
                      return _ScaledParallaxItem(
                        controller: _controller,
                        index: index,
                        builder: (context, scale, parallax) {
                          return Center(
                            child: Transform.scale(
                              scale: scale,
                              child: DomainCarouselCard(
                                domain: domains[index],
                                parallax: parallax,
                                onTap: () => context.go(
                                  '/projects/${domains[index].id}',
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//Computes this item's scale/parallax from [controller]'s current page
//position and hands both to [builder]. Two things make this correct on
//the very first frame, not just after the user scrolls:
//1. [AnimatedBuilder] keeps it reactive to real scroll events, same as
//before.
//2. The [addPostFrameCallback] in [initState] forces exactly one extra
//rebuild right after this item's first layout pass — at which point
//`controller.position.haveDimensions` has flipped to true. Without
//this, the item renders once at the `haveDimensions == false`
//fallback (scale 1.0, no parallax) and never rebuilds again until a
//scroll notification arrives, which is the bug being fixed.
class _ScaledParallaxItem extends StatefulWidget {
  const _ScaledParallaxItem({
    required this.controller,
    required this.index,
    required this.builder,
  });

  final PageController controller;
  final int index;
  final Widget Function(BuildContext context, double scale, double parallax)
  builder;

  @override
  State<_ScaledParallaxItem> createState() => _ScaledParallaxItemState();
}

class _ScaledParallaxItemState extends State<_ScaledParallaxItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        double scale = 1.0;
        double delta = 0.0;
        if (widget.controller.position.haveDimensions) {
          final page = widget.controller.page ?? widget.index.toDouble();
          delta = (page - widget.index).clamp(-1.0, 1.0);
          scale = (1 - delta.abs() * 0.35).clamp(0.65, 1.0);
        }
        return widget.builder(context, scale, delta);
      },
    );
  }
}
