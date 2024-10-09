// ignore_for_file: unused_element

import 'dart:ffi';

import 'package:flutter/material.dart';

class _KeepAliveWrapper extends StatefulWidget {
  const _KeepAliveWrapper({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant _KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;
}

extension WidgetKeepAlive on Widget {
  Widget get keepAlive {
    return _KeepAliveWrapper(child: this);
  }
}

extension WidgetToggleFocus on Widget {
  Widget get tapUnfocused {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: (){
        final focusManager = WidgetsBinding.instance;
        if (focusManager.focusManager.primaryFocus != null) {
          focusManager.focusManager.primaryFocus!.unfocus();
        }
      },
      child: this,
    );
  }

  Widget tapFocused(BuildContext context, FocusNode focusNode) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        if (!focusNode.hasFocus) {
          // focusNode.requestFocus(focusNode);
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: this,
    );
  }
}

extension WidgetExpanded on Widget {

  Widget unFocusGesture(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      behavior: HitTestBehavior.opaque,
      child: this,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget addPadding({EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return Padding(padding: padding, child: this,);
  }

  Widget padding({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0,}) {
    return Padding(padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom,), child: this,);
  }

  Widget setPadding({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0,}) {
    return Padding(padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom,), child: this,);
  }

  Widget addMargin({EdgeInsetsGeometry margin = const EdgeInsets.all(0)}) {
    return Container(
      margin: margin,
      child: this,
    );
  }

  Widget cornerRadius(double radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.hardEdge,
      child: this,
    );
  }

  Widget borderShadow(double radius) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xff4B3E52).withOpacity(0.15),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff4B3E52).withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: this,
    );
  }

  Widget flexible({
    Key? key,
    FlexFit fit = FlexFit.loose,
    int flex = 1,
  }) {
    return Flexible(
      key: key,
      flex: flex,
      fit: fit,
      child: this,
    );
  }

  Widget fittedBox({
    Key? key,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    Clip clipBehavior = Clip.none,
  }) {
    return FittedBox(
      key: key,
      alignment: alignment,
      clipBehavior: clipBehavior,
      fit: fit,
      child: this,
    );
  }
}

extension WidgetClip on Widget {
  Widget oval({
    Key? key,
    CustomClipper<Rect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      ClipOval(
        key: key,
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: this,
      );
}

extension WidgetCenter on Widget {
  Widget get center => Center(child: this);
}

extension SafeAreaWrapper on Widget {
  Widget safeArea({
    Key? key,
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) =>
      SafeArea(
        key: key,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        minimum: minimum,
        maintainBottomViewPadding: maintainBottomViewPadding,
        child: this,
      );
}

extension CusBadge on Widget {
  Widget badgeWith(
    int count, {
    int maxCount = 99,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor,
  }) {
    if (count <= 0) return this;
    return Badge(
      label: Text(
        count > maxCount ? '$maxCount+' : '$count',
      ),
      textStyle: textStyle,
      textColor: textColor,
      backgroundColor: backgroundColor,
      child: this,
    );
  }
}
