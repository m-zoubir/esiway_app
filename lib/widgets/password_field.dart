import 'package:flutter/material.dart';

import 'constant.dart';
import 'icons_ESIWay.dart';

class MyPasswordField extends StatefulWidget {
  final TextEditingController controller;

  MyPasswordField({
    super.key,
    required this.controller,
    this.error,
    this.bottomheigh,
    required this.validate,
    required this.title,
    this.hinttext,
  });
  bool yban = true;

  double? bottomheigh;
  String? error;
  bool validate;
  String title;
  String? hinttext;

  @override
  State<MyPasswordField> createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: widget.validate ? bleu_bg : Colors.red,
            fontSize: 13.0,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(blurRadius: 18, color: Color.fromRGBO(32, 35, 108, 0.15))
          ]),
          child: Container(
            height: MediaQuery.of(context).size.height < 700
                ? MediaQuery.of(context).size.height * 0.07
                : null,
            child: TextField(
              controller: widget.controller,
              obscureText: widget.yban,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: bleu_bg,
                fontFamily: "Montserrat",
                fontSize: MediaQuery.of(context).size.height < 700
                    ? MediaQuery.of(context).size.height * 0.021
                    : 12.5,
              ),
              decoration: InputDecoration(
                  prefixIcon: Container(
                    child: Transform.scale(
                      scale: 0.5,
                      child:
                          Icons_ESIWay(icon: "lock", largeur: 24, hauteur: 24),
                    ),
                  ),
                  hintText: widget.hinttext == null
                      ? 'Enter your Password'
                      : widget.hinttext,
                  hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
                  disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
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
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.yban = !widget.yban;
                      });
                    },
                    child: Container(
                      child: widget.yban
                          ? const Icon(Icons.visibility_off,
                              color: Color(0xff72D2C2))
                          : const Icon(Icons.visibility,
                              color: Color(0xff72D2C2)),
                    ),
                  )),
            ),
          ),
        ),
        widget.validate
            ? SizedBox(
                height: widget.bottomheigh != null
                    ? widget.bottomheigh
                    : MediaQuery.of(context).size.height * 0.01,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.008,
                  ),
                  Text(
                    widget.error!,
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
                  SizedBox(
                    height: widget.bottomheigh != null
                        ? widget.bottomheigh
                        : MediaQuery.of(context).size.height * 0.01,
                  )
                ],
              )
      ],
    );
  }
}
