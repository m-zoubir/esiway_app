import 'package:flutter/material.dart';
import 'constant.dart';

class Text_Field extends StatefulWidget {
  Text_Field(
      {Key? key,
      required this.hinttext,
      this.suffix,
      this.suffixicon,
      this.prefixicon,
      this.error,
      this.length,
      this.type,
      this.bottomheigh,
      this.prefix,
      this.subtitle,
      required this.validate,
      required this.title,
      required this.textfieldcontroller})
      : super(key: key);

  String hinttext;
  String? subtitle;
  String title;
  Icon? prefixicon;
  TextEditingController textfieldcontroller;
  Icon? suffixicon;
  Widget? suffix;
  Widget? prefix;
  String? error;
  bool validate;
  int? length;
  double? bottomheigh;
  TextInputType? type;
  @override
  State<Text_Field> createState() => _Text_FieldState();
}

class _Text_FieldState extends State<Text_Field> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: widget.validate ? bleu_bg : Colors.red,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        widget.subtitle == null
            ? SizedBox(
                height: 10.0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      color: widget.validate ? bleu_bg : Colors.red,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: widget.validate
                    ? Color.fromRGBO(32, 35, 108, 0.15)
                    : Colors.red.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 18,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            maxLength: widget.length,
            keyboardType:
                widget.type == null ? TextInputType.text : widget.type,
            controller: widget.textfieldcontroller,
            style: TextStyle(
              color: bleu_bg,
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: widget.hinttext,
              hintStyle: TextStyle(
                fontSize: 12.0,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              suffix: widget.suffix != null ? widget.suffix : null,
              prefix: widget.prefix != null ? widget.prefix : null,
              suffixIcon: widget.suffixicon != null ? widget.suffixicon : null,
              prefixIcon: widget.prefixicon != null ? widget.prefixicon : null,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: widget.validate
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
              focusedBorder: widget.validate
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: vert,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
        ),
        widget.validate
            ? SizedBox(
                height: widget.bottomheigh != null ? widget.bottomheigh : 14.0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.error!,
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                  SizedBox(
                    height:
                        widget.bottomheigh != null ? widget.bottomheigh : 14.0,
                  )
                ],
              )
      ],
    );
  }
}
