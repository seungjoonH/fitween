import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/widget/bottom_bar.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FTab extends StatelessWidget {
  const FTab(this.text, {
    Key? key,
    this.selected = false,
  }) : super(key: key);

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: FText(
        text,
        style: textTheme(context).titleMedium,
        color: selected
            ? FTheme.darkGrey
            : FTheme.lightGrey,
        bold: true,
      ),
    );
  }
}

class TabScaffold extends StatefulWidget {
  const TabScaffold({
    Key? key,
    required this.tabs,
    required this.bodies,
    this.action,
    this.hasNotifications,
    this.controlNotifications,
    this.presenter,
  }) : super(key: key);

  final List<String> tabs;
  final List<Widget> bodies;
  final Widget? action;
  final List<bool>? hasNotifications;
  final Function(int)? controlNotifications;
  final dynamic presenter;

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> with TickerProviderStateMixin {
  static late TabController tabCont;
  int _selectedIndex = 0;

  @override
  void initState() {
    tabCont = TabController(length: widget.tabs.length, vsync: this);
    if (widget.presenter != null) {
      _selectedIndex = widget.presenter.tabIndex;
      tabCont.index = _selectedIndex;
    }
    tabCont.addListener(() => setState(() {
      _selectedIndex = tabCont.index;
      if (widget.presenter != null) {
        widget.presenter.tabIndex = _selectedIndex;
      }
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: .0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0.h),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 28.0.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 87.0.w * widget.tabs.length,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 3.0.h,
                                  color: FTheme.lightGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TabBar(
                          controller: tabCont,
                          labelPadding: EdgeInsets.zero,
                          indicatorColor: FTheme.darkGrey,
                          indicatorWeight: 3.0.h,
                          onTap: (index) {
                            if (widget.controlNotifications == null) return;
                            widget.controlNotifications!(index);
                            setState(() => _selectedIndex = index);
                          },
                          tabs: List.generate(widget.tabs.length, (index) => Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: FTab(widget.tabs[index],
                                  selected: widget.tabs[_selectedIndex] == widget.tabs[index],
                                ),
                              ),
                              if (widget.hasNotifications?[index] ?? false)
                              Container(
                                width: 8.0, height: 8.0,
                                decoration: const BoxDecoration(
                                  color: FTheme.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                  widget.action ?? Container(),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabCont,
          children: widget.bodies.map((body) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 28.0.w,
              vertical: 28.0.h,
            ),
            child: body,
          )).toList(),
        ),
        bottomNavigationBar: const FBottomNavigationBar(),
      ),
    );
  }
}
