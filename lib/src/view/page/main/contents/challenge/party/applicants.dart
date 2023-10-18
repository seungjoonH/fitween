import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/page.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PartyApplicantsPage extends FPage {
  const PartyApplicantsPage({super.key});

  @override
  FPageState<PartyApplicantsPage> createState() => _PartyApplicantsPageState();
}

class _PartyApplicantsPageState extends FPageState<PartyApplicantsPage> {

  @override
  PartyApplicantsPageCont get cont => PartyApplicantsPageCont.to;

  Widget _buildHeaderWidget(BuildContext context, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FText(text, style: FTheme.commentStyle, color: FTheme.bar, bold: true),
        Divider(thickness: .5, color: FTheme.comment),
      ],
    );
  }

  Widget _buildIndividualApplicantWidget(BuildContext context, FUser applicant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FProfileWidget(user: applicant),
        Row(
          children: [
            FButton(
              text: cont.acceptButtonText,
              shrinkWrap: true,
              onPressed: () => cont.acceptButtonPressed(applicant),
            ),
            SizedBox(width: 10.0.w),
            FButton(
              text: cont.rejectButtonText,
              shrinkWrap: true,
              backgroundColor: FTheme.error,
              onPressed: () => cont.rejectButtonPressed(applicant),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApplicantListWidget(BuildContext context) {
    if (cont.applicants.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: FTheme.bar, width: 1.0.r),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        padding: EdgeInsets.all(30.0.r),
        margin: EdgeInsets.only(top: 10.0.h),
        alignment: Alignment.center,
        child: FText(
          cont.noApplicantsText,
          color: FTheme.bar,
          style: FTheme.titleMedium,
        ),
      );
    }

    return Column(
      children: cont.applicants.values
          .map((applicant) => _buildIndividualApplicantWidget(context, applicant))
          .separateH(height: 10.0.h),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (cont.party == null) return Container();
      return SingleChildScrollView(
        child: Column(
          children: [
            PartyListTile(
              party: cont.party,
              showPercent: true,
            ),
            SizedBox(height: 20.0.h),
            Column(
              children: [
                _buildHeaderWidget(context, cont.listHeaderText),
                _buildApplicantListWidget(context),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FScaffold(
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }

}
