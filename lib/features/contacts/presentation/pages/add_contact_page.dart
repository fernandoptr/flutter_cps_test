import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/services.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/entities.dart';
import '../blocs/blocs.dart';

class AddContactPage extends StatelessWidget {
  final List<City> cities;

  const AddContactPage({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddContactBloc>(),
      child: AddContactView(cities: cities),
    );
  }
}

class AddContactView extends StatefulWidget {
  final List<City> cities;
  const AddContactView({super.key, required this.cities});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _name = "";

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateNameValue);
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _updateNameValue() {
    setState(() => _name = _nameController.text.trim());
  }

  void _disposeAllControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddContactBloc, AddContactState>(
      listener: (context, state) {
        if (state.status != AddContactStatus.initial) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AddContactStateDialog(state: state);
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Contact')),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: InitialsAvatar(initial: _name, size: 124.0)),
                  const SizedBox(height: 32.0),
                  _buildInputFields(),
                  const SizedBox(height: 64.0),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }

  Column _buildInputFields() {
    const spacer = SizedBox(height: 16.0);

    return Column(
      children: [
        AppTextFormField(
          controller: _nameController,
          label: 'Name',
          hint: 'Enter your name',
          prefixIcon: const Icon(Icons.person),
          validator: (value) => Validator.empty(value, field: 'name'),
        ),
        spacer,
        AppTextFormField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          prefixIcon: const Icon(Icons.email),
          validator: Validator.email,
        ),
        spacer,
        AppTextFormField(
          controller: _phoneNumberController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          prefixIcon: const Icon(Icons.phone),
          validator: (value) => Validator.empty(value, field: 'phone number'),
        ),
        spacer,
        GestureDetector(
          onTap: _showCityPicker,
          child: AbsorbPointer(
            child: AppTextFormField(
              controller: _cityController,
              label: 'City',
              hint: 'Select your city',
              readOnly: true,
              prefixIcon: const Icon(Icons.location_city),
              validator: (value) => Validator.empty(value, field: 'city'),
            ),
          ),
        ),
        spacer,
        AppTextFormField(
          controller: _addressController,
          label: 'Address',
          hint: 'Enter your address',
          prefixIcon: const Icon(Icons.location_on),
          validator: (value) => Validator.empty(value, field: 'address'),
        ),
      ],
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300.0,
          child: CupertinoPicker(
            useMagnifier: true,
            itemExtent: 40.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _cityController.text = widget.cities[index].name;
              });
            },
            children: widget.cities.map((City city) {
              return Center(child: Text(city.name));
            }).toList(),
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AddContactBloc>().add(
            AddContactSubmitted(
              name: _name,
              email: _emailController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim(),
              city: _cityController.text,
              address: _addressController.text.trim(),
            ),
          );
    }
  }
}

class AddContactStateDialog extends StatelessWidget {
  final AddContactState state;

  const AddContactStateDialog({
    super.key,
    required this.state,
  });

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
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            if (state.status == AddContactStatus.success) {
              Navigator.of(context).pop();
            }
          },
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
