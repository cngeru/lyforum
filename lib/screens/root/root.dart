import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common.dart';

class Root extends HookWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(authUserProvider).when(
      data: (user) {
        if (user == null) {
          return const Auth();
        } else {
          return const Home();
        }
      },
      loading: () => const _LoadingScaffold(error: '', loading: true),
      error: (err, stack) => _LoadingScaffold(error: err.toString(), loading: false),
    );
  }
}

class _LoadingScaffold extends HookWidget {
  final bool loading;
  final String error;
  final bool isOutage;
  final bool isOutdated;

  const _LoadingScaffold({
    Key? key,
    required this.loading,
    required this.error,
    this.isOutage = false,
    this.isOutdated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            loading ? const CupertinoActivityIndicator() : const SizedBox.shrink(),
            const SizedBox(height: 10),
            error.isNotEmpty
                ? Column(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        error,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
