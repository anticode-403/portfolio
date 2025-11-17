import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final int value;
  final Function(int) updater;
  final double min;
  final double max;

  const CustomSlider(this.value, this.updater, this.min, this.max, {super.key});

  @override
  CustomSliderState createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  late final TextEditingController controller;
  late int lastValue;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.toString());
    lastValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                counterText: "",
              ),
              cursorColor: Colors.white,
              textAlign: TextAlign.center,
              maxLength: 1,
              autocorrect: false,
              keyboardType: TextInputType.number,
              controller: controller,
              onChanged: (value) {
                if (value.isEmpty) return;
                double? asDouble = double.tryParse(value);
                if (asDouble == null || widget.min > asDouble || asDouble > widget.max) {
                  controller.value = TextEditingValue(text: lastValue.toString());
                }
                else {
                  setState(() {
                    lastValue = asDouble.round();
                    widget.updater(asDouble.round());
                  });
                }
              },
            ),
          ),
          Expanded(
            child: Slider(
              inactiveColor: Colors.grey,
              activeColor: Colors.white,
              thumbColor: Colors.white,
              min: widget.min,
              max: widget.max,
              value: double.parse(controller.value.text),
              onChanged: (value) {
                setState(() {
                  lastValue = value.round();
                  controller.value = TextEditingValue(text: value.round().toString());
                  widget.updater(value.round());
                });
              }
            ),
          ),
        ],
      ),
    );
  }
}