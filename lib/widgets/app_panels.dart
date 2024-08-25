import 'dart:developer';

import 'package:flutter/material.dart';

class AppLayout extends ChangeNotifier {
  AppLayout(this._singlePanel);

  bool _singlePanel;

  set singlePanel(v) {
    _singlePanel = v;
    notifyListeners();
  }

  bool get singlePanel => _singlePanel;
}

class AppPanels extends StatefulWidget {
  const AppPanels({
    super.key,
    required this.singleLayout,
    required this.doubleLayoutLeft,
    required this.doubleLayoutRight,
  });

  final Widget singleLayout;
  final Widget doubleLayoutLeft;
  final Widget doubleLayoutRight;

  @override
  State<AppPanels> createState() => _AppListDetail();
}

class _AppListDetail extends State<AppPanels> {
  final int threshold = 1000;
  int mediaWidth = 0;
  late final AppLayout geometry = AppLayout(mediaWidth < threshold);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    mediaWidth = MediaQuery.of(context).size.width.toInt();

    log('orientation set to $mediaWidth');
  }

  @override
  Widget build(BuildContext context) => geometry.singlePanel
      ? widget.singleLayout
      : Row(
          children: [
            Flexible(
              flex: threshold,
              child: widget.doubleLayoutLeft,
            ),
            Flexible(
              flex: mediaWidth,
              child: widget.doubleLayoutRight,
            ),
          ],
        );
}
