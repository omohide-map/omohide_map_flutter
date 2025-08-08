import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextSection extends HookWidget {
  const TextSection({
    super.key,
    required this.textController,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: textController,
            maxLength: 256,
            maxLines: 5,
            onChanged: (_) {
              textController.text = textController.text;
            },
            decoration: const InputDecoration(
              hintText: '今何をしていますか？',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '文字数: ${textController.text.length}/256',
              style: TextStyle(
                fontSize: 12,
                color: textController.text.trim().isNotEmpty &&
                        textController.text.length <= 256
                    ? Colors.grey
                    : Colors.red,
              ),
            ),
            if (!textController.text.trim().isNotEmpty &&
                textController.text.length <= 256)
              const Text(
                '1文字以上256文字以下で入力してください',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
