import 'package:flutter/material.dart';
import 'package:software_task/core/utils/app_syles.dart';

import '../../../../core/utils/app_colors.dart';

class SelectGenderRow extends StatefulWidget {
  const SelectGenderRow({super.key});

  @override
  State<SelectGenderRow> createState() => _SelectGenderRowState();
}

class _SelectGenderRowState extends State<SelectGenderRow> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Gender",
          style: AppStyles.buttonText
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  hoverColor: Colors.transparent,
                  title: const Text("Female"),
                  value: 'female',
                  groupValue: selectedValue,
                  onChanged: (value) {
                    selectedValue = value;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Male"),
                  value: "male",
                  groupValue: selectedValue,
                  onChanged: (value) {
                    selectedValue = value;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
