import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionLayout extends StatefulWidget {
  const ExpansionLayout({
    super.key,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.isExpanded = true,
    bool initiallyExpanded = true,
    Row title = const Row(),
  });

  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;

  final Color? backgroundColor;
  //增加字段控制是否折叠
  final bool isExpanded;

  final Widget? trailing;

  @override
  State<ExpansionLayout> createState() => _ExpansionLayoutState();
}

class _ExpansionLayoutState extends State<ExpansionLayout>
    with SingleTickerProviderStateMixin {
  //折叠展开的动画，主要是控制height
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.isExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = widget.isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleTap();
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return Container(
          color: widget.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: _handleTap,
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: widget.trailing,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: RotationTransition(
                        turns: _controller.drive(_easeInTween),
                        child: const Icon(Icons.expand_more),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRect(
                child: Align(heightFactor: _heightFactor.value, child: child),
              ),
            ],
          ),
        );
      },
      child: closed ? null : Column(children: widget.children),
    );
  }
}
