import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class SenderDataWidget extends StatelessWidget {
  final SenderDataWidgets senderDataWidgets;
  const SenderDataWidget({
    super.key,
    required this.senderDataWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        senderDataWidgets.$1,
        const SizedBox(width: 5),
        senderDataWidgets.$2,
      ],
    );
  }
}
