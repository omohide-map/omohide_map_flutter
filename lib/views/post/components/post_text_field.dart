import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostTextField extends StatelessWidget {
  const PostTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: viewModel.textController,
            maxLength: 256,
            maxLines: 5,
            onChanged: (_) => viewModel.onTextChanged(),
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
              '文字数: ${viewModel.textController.text.length}/256',
              style: TextStyle(
                fontSize: 12,
                color: viewModel.isTextValid ? Colors.grey : Colors.red,
              ),
            ),
            if (!viewModel.isTextValid)
              const Text(
                '1文字以上256文字以下で入力してください',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
