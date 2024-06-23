import 'package:flutter/material.dart';

class PlayerForm extends StatefulWidget {
  final Function(String name, String position, String country) onSubmit;
  final String? initialName;
  final String? initialPosition;
  final String? initialCountry;

  PlayerForm({required this.onSubmit, this.initialName, this.initialPosition, this.initialCountry});

  @override
  _PlayerFormState createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _position;
  late String _country;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName ?? '';
    _position = widget.initialPosition ?? '';
    _country = widget.initialCountry ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: _name,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            initialValue: _position,
            decoration: InputDecoration(labelText: 'Position'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a position';
              }
              return null;
            },
            onSaved: (value) {
              _position = value!;
            },
          ),
          TextFormField(
            initialValue: _country,
            decoration: InputDecoration(labelText: 'Country'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a country';
              }
              return null;
            },
            onSaved: (value) {
              _country = value!;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_name, _position, _country);
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
