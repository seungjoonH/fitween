import 'package:fitween/global/theme.dart';
import 'package:fitween/view/page/friend/friend.dart';
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
        style: textTheme.titleLarge,
        color: selected
            ? FTheme.darkGrey
            : FTheme.lightGrey,
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
  }) : super(key: key);

  final List<String> tabs;
  final List<Widget> bodies;
  final Widget? action;

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> with TickerProviderStateMixin {
  late TabController _tabCont;
  int _selectedIndex = 0;

  @override
  void initState() {
    _tabCont = TabController(length: widget.tabs.length, vsync: this);
    _tabCont.addListener(() => setState(() => _selectedIndex = _tabCont.index));
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
            preferredSize: const Size.fromHeight(15.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 90.0.w * widget.tabs.length,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 3.0,
                                  color: FTheme.lightGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TabBar(
                          controller: _tabCont,
                          labelPadding: EdgeInsets.zero,
                          indicatorColor: FTheme.darkGrey,
                          indicatorWeight: 3.0,
                          onTap: (index) => setState(() => _selectedIndex = index),
                          tabs: widget.tabs.map((text) => FTab(text,
                            selected: widget.tabs[_selectedIndex] == text,
                          )).toList(),
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
          controller: _tabCont,
          children: widget.bodies.map((body) => Padding(
            padding: const EdgeInsets.all(30.0),
            child: body,
          )).toList(),
        ),
        bottomNavigationBar: const FBottomNavigationBar(),
      ),
    );
  }
}
