import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyforum/common.dart';
import 'package:lyforum/screens/screens.dart';

import 'widgets/widgets.dart';

class Home extends HookWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leadingWidth: 120,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Home",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.refresh(authUserProvider);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
              return;
            },
            icon: Icon(
              CupertinoIcons.person_fill,
              color: Theme.of(context).primaryColor,
              size: 36,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                useProvider(postsProvider).when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const Text("No Posts Yet");
                    }
                    return Expanded(
                      child: ListView(
                        children: List.generate(
                          posts.length,
                          (index) => PostContainer(post: posts[index]),
                        ),
                      ),
                    );
                  },
                  loading: () => const CupertinoActivityIndicator(),
                  error: (e, s) {
                    return const Text("An error occurred loading posts");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
            builder: (context) => GestureDetector(onVerticalDragStart: (_) {}, child: const AddPost()),
          );
        },
        elevation: 0,
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
          size: 36,
        ),
      ),
    );
  }
}
