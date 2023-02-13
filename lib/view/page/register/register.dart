import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitween/presenter/page/register.dart';
import 'package:fitween/view/page/register/widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: GetBuilder<RegisterP>(
        builder: (controller) {
          controller.setKeyboardVisible(MediaQuery.of(context).viewInsets.bottom != 0);
          return const Scaffold(
            body: CarouselView(),
          );
        }
      ),
    );
  }
}
