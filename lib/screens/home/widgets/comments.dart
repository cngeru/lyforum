import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common.dart';
import 'add_comment.dart';

class CommentSection extends HookWidget {
  const CommentSection({
    Key? key,
    required ValueNotifier<bool> showComments,
    required this.post,
  })  : _showComments = showComments,
        super(key: key);

  final ValueNotifier<bool> _showComments;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 2),
              leading: GestureDetector(
                onTap: () {
                  _showComments.value = false;
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.keyboard_arrow_left_sharp, size: 36, color: Colors.black),
                ),
              ),
              title: Center(
                child: Text(
                  "Comments",
                  style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              trailing: IconButton(
                splashRadius: 20,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    isDismissible: false,
                    isScrollControlled: true,
                    builder: (context) => GestureDetector(onVerticalDragStart: (_) {}, child: AddComment(post: post)),
                  );
                },
                icon: Icon(CupertinoIcons.plus_bubble, color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 12),
            useProvider(commentsProvider(post.id)).when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("No Comments Yet"),
                    ),
                  );
                }
                return Column(
                  children: List.generate(
                    comments.length,
                    (index) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          dense: true,
                          title: Text(comments[index].author, style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comments[index].content, style: Theme.of(context).textTheme.bodyText1),
                              Text(
                                DateFormat.yMMMEd().format(DateTime.fromMillisecondsSinceEpoch(post.timestamp)),
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, s) {
                return const Center(child: Text("An error occurred loading comments"));
              },
            )
          ],
        ),
      ),
    );
  }
}
