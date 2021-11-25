import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common.dart';
import '../homevm.dart';

class EditPost extends HookWidget {
  final PostModel post;
  const EditPost({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = useTextEditingController(text: post.content);
    final _textListenable = useValueListenable(_textController);
    final _model = useProvider(homeViewModel);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Edit Post",
                style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _model.isBusy
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledTextField(
            hintText: "Edit post",
            controller: _textController,
            textLength: 300,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          _model.isBusy
              ? const Center(child: CupertinoActivityIndicator())
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: ElevatedButton(
                      onPressed: _textListenable.text.trim().isEmpty
                          ? null
                          : () async {
                              bool res = await _model.editPost(post.id, _textController.text);
                              if (res) {
                                Navigator.pop(context);
                                return;
                              }
                              showErrorDialog(context, "An error occurred editing your post");
                              return;
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        "Edit",
                        style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
