import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common.dart';
import '../homevm.dart';

class AddComment extends HookWidget {
  final PostModel post;
  const AddComment({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = useTextEditingController.fromValue(TextEditingValue.empty);
    final _textListenable = useValueListenable(_textController);
    final _model = useProvider(homeViewModel);
    final _user = useProvider(currentUser);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "New Comment",
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
            hintText: "Add comment",
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
                              bool res = await _model.createComment(post.id, _textController.text, _user!.displayName!, _user.userID);
                              if (res) {
                                Navigator.pop(context);
                                return;
                              }
                              showErrorDialog(context, "An error occurred creating your post");
                              return;
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        "COMMENT",
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
