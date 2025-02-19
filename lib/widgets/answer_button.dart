import 'package:flutter/material.dart';

import 'custom_text_widgets.dart';

class AnswerButton extends StatefulWidget {
  final String letter;
  final String answer;
  final void Function() onTap;
  final bool isSelected;
  final Color color;

  const AnswerButton(
      {required this.letter,
      required this.answer,
      required this.onTap,
      required this.isSelected,
      required this.color,
      super.key});

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.isSelected ? widget.color : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.65,
          height: 80,
          child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  foregroundColor: Colors.white,
                  backgroundColor: widget.color),
              child: interText(widget.answer,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
