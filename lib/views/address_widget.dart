import 'package:flutter/material.dart';
import 'package:flutter_offline_data/models/add_customer_request_model.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({
    Key? key,
    required this.initialValue,
    required this.index,
    required this.onChange,
  }) : super(key: key);

  final int index;
  final Address initialValue;
  final void Function(Address) onChange;

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  late final TextEditingController _streetCont;
  late final TextEditingController _stateCont;
  late final TextEditingController _pincodeCont;

  @override
  void initState() {
    _streetCont = TextEditingController(text: widget.initialValue.street);
    _stateCont = TextEditingController(text: widget.initialValue.state);
    _pincodeCont = TextEditingController(text: widget.initialValue.pincode);
    super.initState();
  }

  @override
  void dispose() {
    _stateCont.dispose();
    _streetCont.dispose();
    _pincodeCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _streetCont,
          onChanged: (value) {
            final street = value;
            final state = _stateCont.text;
            final pin = _pincodeCont.text;
            widget.onChange(
              Address(
                street: street,
                state: state,
                pincode: pin,
              ),
            );
          },
          decoration: const InputDecoration(hintText: "Enter your street name"),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter something';
            return null;
          },
        ),
        TextFormField(
          controller: _stateCont,
          onChanged: (value) {
            final street = _streetCont.text;
            final state = value;
            final pin = _pincodeCont.text;
            widget.onChange(
              Address(
                street: street,
                state: state,
                pincode: pin,
              ),
            );
          },
          decoration: const InputDecoration(hintText: "Enter your state name"),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter something';
            return null;
          },
        ),
        TextFormField(
          controller: _pincodeCont,
          onChanged: (value) {
            final street = _streetCont.text;
            final state = _stateCont.text;
            final pin = value;
            widget.onChange(
              Address(
                street: street,
                state: state,
                pincode: pin,
              ),
            );
          },
          decoration: const InputDecoration(hintText: "Enter your pincode"),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter something';
            return null;
          },
        )
      ],
    );
  }
}
