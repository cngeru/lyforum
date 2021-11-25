import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common.dart';
import '../homevm.dart';
import 'add_comment.dart';
import 'comments.dart';
import 'edit_post.dart';

class PostContainer extends HookWidget {
  final PostModel post;
  const PostContainer({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(currentUser);
    final _showComments = useState(false);
    final _model = useProvider(homeViewModel);

    if (_showComments.value) {
      return CommentSection(showComments: _showComments, post: post);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: post.authorID == _user!.userID ? Theme.of(context).primaryColorLight.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // const Icon(Icons.person, color: CupertinoColors.systemGrey),
                    // const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author,
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.yMMMEd().format(DateTime.fromMillisecondsSinceEpoch(post.timestamp)),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    const Spacer(),
                    post.authorID != _user.userID
                        ? const SizedBox.shrink()
                        : InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                                ),
                                builder: (context) => SizedBox(
                                  height: 140.0,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
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
                                            builder: (context) => GestureDetector(onVerticalDragStart: (_) {}, child: EditPost(post: post)),
                                          );
                                        },
                                        leading: const Icon(CupertinoIcons.pencil_circle, color: CupertinoColors.activeBlue),
                                        title: const Text(
                                          "Edit Post",
                                        ),
                                      ),
                                      ListTile(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                content: Text(
                                                  "Are you sure you want to delete the post ? ",
                                                  style: Theme.of(context).textTheme.bodyText2,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context, false);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ).then((value) async {
                                              if (value == false || value == null) return;
                                              bool res = await _model.deletePost(post.id);
                                              if (res) {
                                                return;
                                              }
                                              showErrorDialog(context, "An error occurred deleting your post");
                                              return;
                                            });
                                          },
                                          leading: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                                          title: const Text("Delete Post"))
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(post.content),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
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
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.plus_bubble, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Add Comment",
                        style: Theme.of(context).textTheme.button!.copyWith(color: Theme.of(context).primaryColorDark),
                      ),
                    ],
                  ),
                ),
                if (post.commentsNumber > 0)
                  GestureDetector(
                    onTap: () {
                      _showComments.value = true;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "View all ${post.commentsNumber} comments",
                        style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
