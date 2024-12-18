import 'package:flutter/material.dart';

class ExpandAnimation extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Duration? duration;
  final Axis axis;
  final ValueNotifier<bool>? disableNotifier;
  final bool disable;

  ExpandAnimation(
      {super.key,
      this.expand = false,
      this.disableNotifier,
      required this.child,
      this.axis = Axis.vertical,
      this.duration,
      this.disable = false});

  @override
  _ExpandAnimationState createState() => _ExpandAnimationState();
}

class _ExpandAnimationState extends State<ExpandAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  late bool completlyDisapear;

  @override
  void initState() {
    completlyDisapear = !widget.expand;
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: widget.duration ?? Duration(milliseconds: 500));
    expandController.addListener(() {
      setState(() {
        completlyDisapear = expandController.value == 0;
      });
    });
    animation =
        CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.disable ||
            (widget.disableNotifier != null && widget.disableNotifier!.value)
        ? widget.expand
            ? widget.child
            : SizedBox()
        : completlyDisapear
            ? SizedBox()
            : SizeTransition(
                axis: widget.axis,
                axisAlignment: 0.0,
                sizeFactor: animation,
                child: widget.child);
  }
}
