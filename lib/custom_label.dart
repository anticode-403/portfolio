import 'package:flutter/material.dart';


class CustomLabel extends StatelessWidget {
  final String label;
  final String tooltip;
  final bool doPadding;

  const CustomLabel(this.label, {super.key, this.tooltip = '', this.doPadding = true});

  @override
  Widget build(context) {
    return Padding(
      padding: doPadding ? const EdgeInsets.only(top: 16) : const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tooltip.isNotEmpty ? [
          IconButton(
            disabledColor: Colors.white,
            tooltip: tooltip,
            icon: const Icon(Icons.info),
            onPressed: null,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ] : [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  } 
}