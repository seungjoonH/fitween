import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/view/page/page.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InventoryPage extends FPage {
  const InventoryPage({super.key});

  @override
  FPageState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends FPageState<InventoryPage> {
  @override
  InventoryPageCont get cont => InventoryPageCont.to;
  InventoryCont get inventoryCont => InventoryCont.to;

  int get _rowCount => 8;
  int get _columnCount => 4;

  double get _size {
    return 20 * (PageCont.size.width - 56.0.w) / (21 * _columnCount + 1).r;
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: ItemInventoryWidget(
        itemList: inventoryCont.inventory,
        rowCount: _rowCount,
        columnCount: _columnCount,
        size: _size,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cont.initState(reload: true);
  }

  @override
  Widget buildPage(BuildContext context) {
    return FRefreshScaffold(
      refreshController: RefreshController(),
      onRefresh: cont.onRefresh,
      appBar: FAppBar(text: cont.appBarTitle),
      body: _buildBody(context),
    );
  }

}
