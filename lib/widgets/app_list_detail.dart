import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const routeHome = '/';

class AppLayout extends ChangeNotifier {
  AppLayout(this._singlePanel, this.widgetTwo);

  bool _singlePanel;
  final Widget widgetTwo;

  set singlePanel(v) {
    _singlePanel = v;
    notifyListeners();
  }

  bool get singlePanel => _singlePanel;
}

class AppListDetail extends StatefulWidget {
  const AppListDetail({
    super.key,
    required this.one,
    required this.two,
  });

  final Widget one;
  final Widget two;

  @override
  State<AppListDetail> createState() => _AppListDetail();
}

class _AppListDetail extends State<AppListDetail> {
  final int threshold = 1000;
  int mediaWidth = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    mediaWidth = MediaQuery.of(context).size.width.toInt();

    log('orientation set to $mediaWidth');
  }

  @override
  Widget build(BuildContext context) {
    final AppLayout geometry = AppLayout(mediaWidth < threshold, widget.two);

    return ChangeNotifierProvider<AppLayout>.value(
      value: geometry,
      child: geometry.singlePanel
          ? Navigator(key: _navigatorKey, onGenerateRoute: _onGenerateRoute)
          : Row(
              children: [
                Flexible(
                  flex: threshold,
                  child: widget.one,
                ),
                Flexible(
                  flex: mediaWidth,
                  child: widget.two,
                ),
              ],
            ),
    );
  }

  Route<Widget> _onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      routeHome => widget.one,
      _ => throw StateError('Invalid route: ${settings.name}'),
    };

    log('generate route $settings $_navigatorKey');
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
