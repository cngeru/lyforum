import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lyforum/common.dart';
import 'package:lyforum/screens/profile/profilevm.dart';

class Profile extends HookWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(currentUser);
    if (_user == null) return const Scaffold();
    final _username = _user.displayName!.contains(" ") ? _user.displayName!.split(" ")[0] : _user.displayName!;
    final _auth = useProvider(authenticationServiceProvider);
    final _model = useProvider(profileViewModel);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $_username",
                style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Theme.of(context).primaryColor,
                      size: 56,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Drafts", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      final box = HiveService.getDrafts();
                      box.clear();
                    },
                    child: const Text("Clear All"),
                  ),
                ],
              ),
              ValueListenableBuilder<Box<PostModel>>(
                valueListenable: HiveService.getDrafts().listenable(),
                builder: (context, box, widget) {
                  final drafts = box.values.toList().cast<PostModel>();
                  if (drafts.isEmpty) {
                    return const Center(child: Text("No Drafts Saved Yet"));
                  }
                  return Expanded(
                    child: ListView(
                      children: List.generate(
                        drafts.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                    content: Text(
                                      "Are you sure you want to delete this draft ? ",
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
                                  final box = HiveService.getDrafts();
                                  box.delete(drafts[index].hiveKey);
                                  return;
                                });
                              },
                              title: Text(
                                drafts[index].content,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              subtitle: Text(
                                DateFormat.yMMMEd().format(DateTime.fromMillisecondsSinceEpoch(drafts[index].timestamp)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              trailing: GestureDetector(
                                onTap: _model.isBusy
                                    ? null
                                    : () async {
                                        bool res = await _model.uploadDraft(drafts[index]);
                                        if (res) {
                                          // Delete Draft after uploading
                                          final box = HiveService.getDrafts();
                                          box.delete(drafts[index].hiveKey);
                                          return;
                                        }
                                        showErrorDialog(context, "An error occurred creating your post");
                                        return;
                                      },
                                child: _model.isBusy
                                    ? const CupertinoActivityIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(CupertinoIcons.square_arrow_up_fill, color: Theme.of(context).primaryColor),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await _auth.signOut().then((value) => Navigator.pop(context));
                    return;
                  },
                  child: const Text("Logout"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
