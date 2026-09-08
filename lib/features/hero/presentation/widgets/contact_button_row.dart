import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio_web_app/core/widgets/outlined_action_button.dart';

class ContactButtonRow extends StatelessWidget {
  const ContactButtonRow({
    super.key,
    required this.email,
    required this.linkedinUrl,
    required this.whatsappUrl,
  });

  final String email;
  final String linkedinUrl;
  final String whatsappUrl;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedActionButton(
          label: 'Email',
          icon: Icons.email_outlined,
          onTap: () => launchUrl(Uri.parse('mailto:$email')),
        ),
        OutlinedActionButton(
          label: 'LinkedIn',
          icon: Icons.link,
          onTap: () => launchUrl(Uri.parse(linkedinUrl)),
        ),
        OutlinedActionButton(
          label: 'WhatsApp',
          icon: Icons.chat_bubble_outline,
          onTap: () => launchUrl(Uri.parse(whatsappUrl)),
        ),
      ],
    );
  }
}
