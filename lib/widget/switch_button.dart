import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Switch.adaptive(
        value: _lights,
        onChanged: (bool value) {
          setState(() {
            _lights = value;
          });
        },
      ),
    );
  }
}
