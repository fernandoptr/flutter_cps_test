import 'package:flutter/material.dart';
import '../blocs/blocs.dart';

class AddContactStateDialog extends StatelessWidget {
  final AddContactState state;

  const AddContactStateDialog({
    super.key,
    required this.state,
  });

  void _onDialogActionPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    if (state.status == AddContactStatus.success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  Widget? _buildTitle() {
    if (state.status == AddContactStatus.loading) {
      return const Text('Submitting Contact');
    } else if (state.status == AddContactStatus.success) {
      return const Text('Contact Added');
    } else if (state.status == AddContactStatus.failure) {
      return const Text('Submission Failed');
    } else {
      return null;
    }
  }

  Widget? _buildContent() {
    if (state.status == AddContactStatus.loading) {
      return const LinearProgressIndicator();
    } else if (state.status == AddContactStatus.success) {
      return Text(
        '${state.submittedContact?.name} has been added to your contacts',
      );
    } else if (state.status == AddContactStatus.failure) {
      return Text(state.errorMessage ?? 'Something went wrong');
    } else {
      return null;
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    if (state.status != AddContactStatus.loading) {
      return [
        TextButton(
          onPressed: () => _onDialogActionPressed(context),
          child: Text(
            state.status == AddContactStatus.success ? 'OK' : 'Try Again',
          ),
        ),
      ];
    } else {
      return [];
    }
  }
}
