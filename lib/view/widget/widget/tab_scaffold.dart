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
            ? FTheme.grey
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
  }) : super(key: key);

  final List<String> tabs;
  final List<Widget> bodies;

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: .0,
          bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 270.0.w,
                padding: const EdgeInsets.only(left: 30.0),
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
                      labelPadding: EdgeInsets.zero,
                      indicatorColor: FTheme.grey,
                      indicatorWeight: 3.0,
                      onTap: (index) => setState(() => _selectedIndex = index),
                      tabs: widget.tabs.map((text) => FTab(text,
                        selected: widget.tabs[_selectedIndex] == text,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: TabBarView(
            children: widget.bodies,
          ),
        ),
        bottomNavigationBar: FBottomNavigationBar(),
      ),
    );
  }
}
