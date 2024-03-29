import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/extensions.dart';
import '../../domain/entities/entities.dart';
import '../../../../shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailSheet extends StatelessWidget {
  final Contact contact;

  const ContactDetailSheet({super.key, required this.contact});

  void _onCallPressed(BuildContext context) async {
    final Uri telLaunchUri = Uri(
      scheme: 'tel',
      path: contact.phoneNumber,
    );
    if (!await launchUrl(telLaunchUri)) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not launch the URL. Please try again.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return ListView(
          padding: const EdgeInsets.all(16),
          controller: scrollController,
          children: [
            _buildHandler(),
            const SizedBox(height: 16),
            _buildBody(context),
            const SizedBox(height: 32),
            CupertinoButton(
              onPressed: () => _onCallPressed(context),
              child: const Text('Call'),
            ),
          ],
        );
      },
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InitialsAvatar(initial: contact.name),
            const SizedBox(width: 16),
            Text(
              contact.name,
              style: context.textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          contact.email,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(
          contact.phoneNumber,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(
          contact.city,
          style: context.textTheme.titleMedium,
        ),
      ],
    );
  }

  Center _buildHandler() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
