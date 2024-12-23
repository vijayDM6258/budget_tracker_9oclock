import 'package:flutter/material.dart';

class AddIX extends StatelessWidget {
  const AddIX({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          DropdownMenu(
            dropdownMenuEntries: [
              DropdownMenuEntry(value: "1", label: "op1"),
              DropdownMenuEntry(value: "1", label: "op1"),
              DropdownMenuEntry(value: "2", label: "op3"),
            ],
            onSelected: (value) {
              print("value ${value}");
            },
          )
        ],
      ),
    );
  }
}
