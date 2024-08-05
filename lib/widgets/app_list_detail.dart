import 'package:flutter/material.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    mediaWidth = MediaQuery.of(context).size.width.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return mediaWidth < threshold
        ? widget.one
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
    );
  }
}
