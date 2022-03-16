import 'package:flutter/material.dart';

typedef StringCallback<T> = String? Function(String?);
class BoxTextField extends StatefulWidget {
  final bool? readOnly;
  final StringCallback? validator;
  final String? hintText;
  final bool? obscureText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final AutovalidateMode? autovalidateMode;
  BoxTextField({
    this.validator, this.hintText, this.obscureText, this.onTap, this.controller, this.readOnly, this.textInputAction = TextInputAction.done, this.textInputType, this.autovalidateMode,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<BoxTextField> {

  late bool hide;
  @override
  void initState() {
    super.initState();
    hide = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      onTap: widget.onTap,
      obscureText: hide,
      validator: widget.validator,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: (widget.obscureText ?? false) ? IconButton(
          onPressed: (){
            setState(() => hide = !hide);
          },
          icon: !hide ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        ) : null,
        filled: true,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: Colors.white,
      ),
    );
  }
}
