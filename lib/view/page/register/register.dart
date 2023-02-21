import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/app_bar.dart';
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
        builder: (registerP) {
          registerP.setKeyboardVisible(
            MediaQuery.of(context).viewInsets.bottom != 0,
          );

          return Scaffold(
            backgroundColor: FTheme.white,
            // extendBodyBehindAppBar: registerP.pageIndex > 1,
            appBar: FAppBar(
              title: registerP.pageIndex < 2 ? '정보 입력' : null,
              leading: IconButton(
                onPressed: registerP.backPressed,
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
            body: const CarouselView(),
          );
        }
      ),
    );
  }
}
