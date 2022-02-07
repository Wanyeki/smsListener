import 'package:flutter/material.dart';

class BorderInput extends StatefulWidget {
  const BorderInput(
      {Key? key,
      this.empty = false,
      this.prefix = '',
      this.hint = '',
      required this.name,
      this.validate,
      this.keyboardType = TextInputType.text,
      this.prefixIcon,
      this.controller,
      this.hidden = false})
      : super(key: key);
  final bool empty;
  final TextEditingController? controller;
  final String name;
  final String hint;
  final bool hidden;
  final String prefix;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final dynamic Function(String? value)? validate;
  @override
  _BorderInputState createState() => _BorderInputState();
}

class _BorderInputState extends State<BorderInput> {
  validate(value) {
    if (value.isEmpty && !widget.empty) {
      return widget.name + ' can\'t be empty';
    } else if (widget.validate != null) {
      return widget.validate!(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 340,
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.hidden,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
              prefix: Text(widget.prefix),
              prefixIcon: widget.prefixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              labelText: widget.name,
              hintText: widget.hint,
              labelStyle: const TextStyle(fontSize: 20),
              hintStyle: const TextStyle(fontSize: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    color: Colors.blue, width: 4, style: BorderStyle.solid),
              )),
          validator: (value) {
            return validate(value);
          },
        ),
      ),
    );
  }
}

class FilledButton extends StatefulWidget {
  const FilledButton(
      {Key? key,
      required this.onPressed,
      required this.color,
      required this.text,
      this.iconColor = Colors.white,
      this.disabled = false,
      this.icon})
      : super(key: key);
  final void Function() onPressed;
  final Color color;
  final String text;
  final bool disabled;
  final Color iconColor;
  final dynamic icon;
  @override
  _FilledButtonState createState() => _FilledButtonState();
}

class _FilledButtonState extends State<FilledButton> {
  @override
  Widget build(BuildContext context) {
    bool disabled = widget.disabled;
    return Center(
      child: InkWell(
        onTap: disabled ? () {} : widget.onPressed,
        child: Container(
          width: 250,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: disabled ? Colors.grey[300]! : widget.color),
          child: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 20,
                )
              : Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
        ),
      ),
    );
  }
}
