import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common.dart';
import 'authvm.dart';

class Auth extends HookWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailController = useTextEditingController.fromValue(TextEditingValue.empty);
    final _emailListenable = useValueListenable(_emailController);
    final _nameController = useTextEditingController.fromValue(TextEditingValue.empty);
    final _nameListenable = useValueListenable(_nameController);
    final _passController = useTextEditingController.fromValue(TextEditingValue.empty);
    final _passListenable = useValueListenable(_passController);
    final _model = useProvider(authViewModel);
    final _groupValue = useState(0);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: CupertinoColors.systemGrey6,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        CupertinoIcons.chat_bubble_2_fill,
                        color: Theme.of(context).primaryColor,
                        size: 44,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: CupertinoSlidingSegmentedControl<int>(
                      backgroundColor: CupertinoColors.white,
                      thumbColor: Theme.of(context).primaryColorLight,
                      padding: const EdgeInsets.all(8),
                      groupValue: _groupValue.value,
                      children: {
                        0: buildSegment("Login", context),
                        1: buildSegment("Register", context),
                      },
                      onValueChanged: (value) {
                        if (_model.isBusy) return;
                        if (value == null) return;
                        _groupValue.value = value;
                      },
                    ),
                  ),
                  const Align(alignment: Alignment.centerLeft, child: Text("Email")),
                  const SizedBox(height: 6),
                  FilledTextField(hintText: "Enter email address ...", controller: _emailController),
                  const SizedBox(height: 12),
                  if (_groupValue.value == 1) const Align(alignment: Alignment.centerLeft, child: Text("Name")),
                  if (_groupValue.value == 1) const SizedBox(height: 12),
                  if (_groupValue.value == 1) FilledTextField(hintText: "Enter name ...", controller: _nameController),
                  const SizedBox(height: 6),
                  const Align(alignment: Alignment.centerLeft, child: Text("Password")),
                  const SizedBox(height: 12),
                  PasswordInput(hintText: "Enter Password", controller: _passController),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              width: MediaQuery.of(context).size.width * 0.75,
              child: _groupValue.value == 1
                  ? ElevatedButton(
                      onPressed: _emailListenable.text.trim().isEmpty ||
                              !_emailListenable.text.trim().contains("@") ||
                              _passListenable.text.trim().isEmpty ||
                              _nameListenable.text.trim().isEmpty ||
                              _model.isBusy
                          ? null
                          : () async {
                              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);
                              if (!emailValid) {
                                showErrorSnackBar(context, "Enter a valid email address");
                                return;
                              }
                              String res = await _model.register(_emailController.text, _nameController.text, _passController.text);
                              if (res != "success") {
                                showErrorSnackBar(context, res);
                                return;
                              } else {
                                return;
                              }
                            },
                      style: ElevatedButton.styleFrom(elevation: 0),
                      child: _model.isBusy
                          ? const CupertinoActivityIndicator()
                          : Text("REGISTER", style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
                    )
                  : ElevatedButton(
                      onPressed: _emailListenable.text.trim().isEmpty ||
                              !_emailListenable.text.trim().contains("@") ||
                              _passListenable.text.trim().isEmpty ||
                              _model.isBusy
                          ? null
                          : () async {
                              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);
                              if (!emailValid) {
                                showErrorSnackBar(context, "Enter a valid email address");
                                return;
                              }
                              String res = await _model.login(_emailController.text, _passController.text);
                              if (res != "success") {
                                showErrorSnackBar(context, res);
                                return;
                              } else {
                                return;
                              }
                            },
                      style: ElevatedButton.styleFrom(elevation: 0),
                      child: _model.isBusy
                          ? const CupertinoActivityIndicator()
                          : Text("LOGIN", style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
                    ),
            ),
          ],
        )
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _nameListenable.text.trim().isEmpty || _nameListenable.text.trim().length < 5 || _nameListenable.text.trim().length > 12
        //       ? null
        //       : () async {
        //           bool res = await _model.register(_usernameController.text.trim());
        //           if (res) {
        //             Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute<void>(
        //                 builder: (BuildContext context) => const Home(),
        //               ),
        //             );
        //             return;
        //           }
        //           showErrorSnackBar(context, "Error setting your username");
        //           return;
        //         },
        //   backgroundColor: _nameListenable.text.trim().isEmpty || _nameListenable.text.trim().length < 5 || _nameListenable.text.trim().length > 12
        //       ? Colors.grey.withOpacity(0.5)
        //       : Theme.of(context).primaryColor,
        //   elevation: 0,
        //   child: _model.isBusy ? const CupertinoActivityIndicator() : const Icon(Icons.east),
        // ),
        );
  }

  Widget buildSegment(String text, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
