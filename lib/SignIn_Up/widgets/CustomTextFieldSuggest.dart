// ignore_for_file: file_names

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import

import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTextFieldSuggest extends StatefulWidget {
  const CustomTextFieldSuggest({
    Key? key,
    this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.hintTextColor,
    this.labelTextColor,
    this.iconColor,
    this.width,
    this.keyboardType,
    required this.onSuggestionSelected,
    required this.getSuggestions,
  }) : super(key: key);

  final String? hintText;
  final Color? hintTextColor;
  final Color? iconColor;
  final String labelText;
  final Color? labelTextColor;
  final Icon prefixIcon;
  final double? width;
  final TextInputType? keyboardType;
  final Function(dynamic) onSuggestionSelected;
  final Future<List<dynamic>> Function(String) getSuggestions;

  @override
  State<CustomTextFieldSuggest> createState() => _CustomTextFieldSuggestState();
}

class _CustomTextFieldSuggestState extends State<CustomTextFieldSuggest> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF20236C).withOpacity(0.12),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: SizedBox(
            width: widget.width,
            height: 50.0,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                keyboardType: widget.keyboardType ?? TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: widget.hintTextColor),
                  labelText: widget.labelText,
                  labelStyle: TextStyle(color: widget.labelTextColor),
                  prefixIcon: widget.prefixIcon,
                  prefixIconColor: widget.iconColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              suggestionsCallback: widget.getSuggestions,
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.description),
                );
              },
              onSuggestionSelected: widget.onSuggestionSelected,
            ),
          ),
        ),
      ),
    );
  }
}
