import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  final List<String> dropList;
  final String? hintText;
  final String? valueSelected;
  final Function onSelect;
  final Color? bgColor;

  const AppDropdown({
    Key? key,
    required this.dropList,
    this.hintText = 'Select role',
    required this.valueSelected,
    required this.onSelect,
    this.bgColor = const Color(0xffEBE8E7),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hintText!),
          borderRadius: BorderRadius.circular(10),
          underline: null,
          icon: const Icon(CupertinoIcons.chevron_down),
          items: dropList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: valueSelected,
          onChanged: (String? cargo) {
            onSelect(cargo);
          },
        ),
      ),
    );
  }
}
