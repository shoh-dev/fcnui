//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

class CardVariant extends Equatable {
  final CardTitle title;

  final CardSubtitle? subtitle;

  final CardContent content;

  final CardFooter footer;

  const CardVariant({
    required this.title,
    this.subtitle,
    required this.content,
    required this.footer,
  });

  @override
  List<Object?> get props => [title, content, footer, subtitle];
}

class CardDecoration extends Equatable {
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final CrossAxisAlignment childrenCrossAxisAlignment;

  const CardDecoration({
    this.padding,
    this.border,
    this.boxShadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color,
    this.childrenCrossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  List<Object?> get props => [padding, border, borderRadius, color];
}

class CardTitle extends Equatable {
  final String title;

  /// If [style] is null, it will use the default style
  final TextStyle? style;

  const CardTitle({
    required this.title,
    this.style,
  });

  @override
  List<Object?> get props => [title, style];
}

class CardSubtitle extends Equatable {
  final String subtitle;

  /// If [style] is null, it will use the default style
  final TextStyle? style;

  const CardSubtitle({
    required this.subtitle,
    this.style,
  });

  @override
  List<Object?> get props => [subtitle, style];
}

class CardContent extends Equatable {
  final Widget content;

  const CardContent({
    required this.content,
  });

  @override
  List<Object?> get props => [content];
}

class CardFooter extends Equatable {
  final List<Widget> footer;

  final MainAxisAlignment mainAxisAlignment;

  final Axis direction;

  const CardFooter({
    required this.footer,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.direction = Axis.horizontal,
  });

  @override
  List<Object?> get props => [footer, mainAxisAlignment, direction];
}

class CardCustom extends Equatable {
  final Widget widget;

  const CardCustom({
    required this.widget,
  });

  @override
  List<Object?> get props => [widget];
}

class DefaultCard extends StatelessWidget {
  final CardVariant? variant;
  final CardCustom? custom;
  final CardDecoration decoration;

  const DefaultCard({
    super.key,
    this.variant,
    this.custom,
    this.decoration = const CardDecoration(),
  })
  //Assert 1 of them is not null
  : assert(variant != null || custom != null,
            'DefaultCard: variant and custom cannot be null at the same time');

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) {
        return getChild(vm);
      },
    );
  }

  Widget getChild(ThemeVm vm) {
    return _getCard(vm.theme);
  }

  Widget _getCard(ThemeData theme) {
    final EdgeInsets defaultPadding = const EdgeInsets.all(24).w;
    final List<BoxShadow> cardShadow = [
      BoxShadow(
        offset: const Offset(0, 2).w,
        blurRadius: 4.r,
        spreadRadius: 0,
        color: Colors.black.withOpacity(0.08),
      ),
      BoxShadow(
        offset: const Offset(0, 3).w,
        blurRadius: 10.r,
        spreadRadius: 0,
        color: Colors.black.withOpacity(0.1),
      )
    ];

    final border = Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            strokeAlign: BorderSide.strokeAlignInside)
        .w;

    final color = decoration.color ?? theme.colorScheme.surface;

    return DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: decoration.borderRadius,
          boxShadow: decoration.boxShadow ?? cardShadow,
          border: decoration.border ?? border,
        ),
        child: custom == null
            ? Padding(
                padding: decoration.padding?.w ?? defaultPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: decoration.childrenCrossAxisAlignment,
                  children: [
                    _getTitle(theme),
                    if (variant!.subtitle != null) _getSubtitle(theme),
                    _getContent(theme),
                    _getFooter(theme),
                  ],
                ),
              )
            : Padding(
                padding: decoration.padding ?? defaultPadding,
                child: custom!.widget,
              ));
  }

  Widget _getTitle(ThemeData theme) {
    final title = variant!.title;
    return Text(
      title.title,
      style: (title.style ??
              theme.textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold))
          .sp,
    );
  }

  Widget _getSubtitle(ThemeData theme) {
    final subtitle = variant!.subtitle!;

    Widget widget = Text(
      subtitle.subtitle,
      style: (subtitle.style ??
              theme.textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: theme.colorScheme.onSurface.withOpacity(0.6)))
          .sp,
    );

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: widget,
    );
  }

  Widget _getContent(ThemeData theme) {
    final content = variant!.content;

    Widget widget = content.content;

    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: widget,
    );
  }

  Widget _getFooter(ThemeData theme) {
    final footer = variant!.footer;

    Widget widget = Row(
      mainAxisAlignment: footer.mainAxisAlignment,
      children: footer.footer.length == 1
          ? [Expanded(child: footer.footer.first)]
          : footer.footer,
    );

    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: widget,
    );
  }
}
