// /* 원형 프로필 이미지 버튼 */
//
// import 'package:fitween/model/user.dart';
// import 'package:fitween/presenter/global.dart';
// import 'package:flutter/material.dart';
//
// class ProfileImageButton extends StatelessWidget {
//   const ProfileImageButton({
//     Key? key,
//     required this.user,
//   }) : super(key: key);
//
//   final PUser user;
//
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(
//         maxWidth: 100.0,
//         maxHeight: 100.0,
//       ),
//       child: InkWell(
//         onTap: GlobalPresenter.profileImagePressed,
//         borderRadius: BorderRadius.circular(50.0),
//         child: ClipOval(
//           child: Image.network(user.imageUrl!,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
