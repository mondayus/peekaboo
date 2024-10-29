import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peekaboo/common/cli_common.dart';
import 'package:flutter/services.dart';
import 'package:peekaboo/screen/main/tab/tab_item.dart';
import 'package:peekaboo/screen/main/tab/tab_navigator.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'fab/w_floating_upload_button.dart';
import 'w_menu_drawer.dart';

final currentTabProvider = StateProvider((ref) => TabItem.home);

class MainScreen extends ConsumerStatefulWidget {
  final TabItem firstTab;

  const MainScreen({
    super.key,
    this.firstTab = TabItem.home,
  });

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> with SingleTickerProviderStateMixin {
  final tabs = TabItem.values;
  late final List<GlobalKey<NavigatorState>> navigatorKeys =
  TabItem.values.map((e) => GlobalKey<NavigatorState>()).toList();

  TabItem get _currentTab => ref.watch(currentTabProvider);

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey => navigatorKeys[_currentIndex];

  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 30.0;
  static const bottomNavigationBarHeight = 60.0;

  bool isFabExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    if (oldWidget.firstTab != widget.firstTab) {
      delay(() {
        ref.read(currentTabProvider.notifier).state = widget.firstTab;
      }, 0.ms);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: _handleBackPressed,
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              extendBody: extendBody,
              //bottomNavigationBar 아래 영역 까지 그림
              drawer: const MenuDrawer(),
              drawerEnableOpenDragGesture: !Platform.isIOS,
              body: Container(
                padding:
                EdgeInsets.only(bottom: extendBody ? 60 - bottomNavigationBarBorderRadius : 0),
                child: SafeArea(
                  bottom: !extendBody,
                  child: pages,
                ),
              ),
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: _buildBottomNavigationBar(context),
            ),
            AnimatedOpacity(
              opacity: _currentTab != TabItem.search ? 1 : 0,
              duration: 300.ms,
              child: FloatingUploadButton(),
            )
          ],
        ),
      ),
    );
  }

  IndexedStack get pages => IndexedStack(
      index: _currentIndex,
      children: tabs
          .mapIndexed((tab, index) => Offstage(
        offstage: _currentTab != tab,
        child: TabNavigator(
          navigatorKey: navigatorKeys[index],
          tabItem: tab,
        ),
      ))
          .toList());

  void _handleBackPressed(bool didPop, Object? result) async {
    if (didPop) {
      return;
    }
    final bool shouldPop = await _showDialog() ?? false;
    if (shouldPop) {
      // Since this is the root route, quit the app where possible by
      // invoking the SystemNavigator. If this wasn't the root route,
      // then Navigator.maybePop could be used instead.
      // See https://github.com/flutter/flutter/issues/11490
      SystemNavigator.pop();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: bottomNavigationBarHeight + context.viewPaddingBottom,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomNavigationBarBorderRadius),
          topRight: Radius.circular(bottomNavigationBarBorderRadius),
        ),
        child: BottomNavigationBar(
          items: navigationBarItems(context),
          currentIndex: _currentIndex,
          selectedItemColor: context.appColors.text,
          unselectedItemColor: context.appColors.iconButtonInactivate,
          onTap: _handleOnTapNavigationBarItem,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) => tab.toNavigationBarItem(
        context,
        isActivated: _currentIndex == index,
      ),
    )
        .toList();
  }

  void _changeTab(int index) {
    ref.read(currentTabProvider.notifier).state = tabs[index];
  }

  BottomNavigationBarItem bottomItem(
      bool activate, IconData iconData, IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }
  /// Shows a dialog and resolves to true when the user has indicated that they
  /// want to pop.
  ///
  /// A return value of null indicates a desire not to pop, such as when the
  /// user has dismissed the modal without tapping a button.
  Future<bool?> _showDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Any unsaved changes will be lost!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes, discard my changes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No, continue editing'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

}
