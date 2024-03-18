import 'package:flutter/material.dart';

class textFeild extends StatefulWidget {
  const textFeild({
    Key? key,
    required this.Controller,
    required this.labeltext,
    required this.hinttext,
    required this.icon,
    required this.password,
  }) : super(key: key);

  final TextEditingController Controller;
  final String labeltext;
  final String hinttext;
  final IconData icon;
  final bool password;

  @override
  State<textFeild> createState() => _textFeildState();
}

class _textFeildState extends State<textFeild> {
  late bool pass = widget.password;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.Controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey,
        labelText: widget.labeltext,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        hintText: widget.hinttext,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        suffixIcon: widget.password
            ? IconButton(
                onPressed: () {
                  setState(() {
                    pass = !pass;
                  });
                },
                icon: Icon(
                  pass ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              )
            : // If it's not a password field, don't show the icon
            IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.Controller.clear();
                },
              ),
      ),
      obscureText: pass,
    );
  }
}
