//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';

class CardDecoration extends DecorationImpl {
  CardDecoration(
    super.context, {
    required CardChild child,
    CardColor? color,
    CardBorder? border,
    CardSize? size,
  }) {
    super.childTheme = child;
    super.colorTheme = color ?? CardColor(context);
    super.borderTheme = border ?? CardBorder(context);
    super.sizeTheme = size ?? CardSize(context);
  }

  @override
  CardChild get childTheme => super.childTheme as CardChild;

  @override
  CardColor get colorTheme => super.colorTheme as CardColor;

  @override
  CardBorder get borderTheme => super.borderTheme as CardBorder;

  @override
  CardSize get sizeTheme => super.sizeTheme as CardSize;
}

class CardChild extends ChildImpl {
  CardTitle? title;
  CardSubtitle? subtitle;
  CardContent? content;
  CardFooter? footer;

  CardCustom? custom;

  CardChild(super.context,
      {CardTitle? title,
      CardSubtitle? subtitle,
      CardContent? content,
      CardFooter? footer,
      CardCustom? custom})
      :
        //assert if custom is null, then title, content, and footer cannot be null
        assert(
            custom == null
                ? title != null && content != null && footer != null
                : true,
            'CardChild: custom cannot be null if title, content, and footer are null') {
    final bool isCustom = custom != null;
    if (isCustom) {
      this.custom = custom;
    } else {
      this.title = title!.copyWith(
          style: title.style ??
              theme.textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold));

      this.subtitle = subtitle!.copyWith(
          style: subtitle.style ??
              theme.textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: theme.colorScheme.onSurface.withOpacity(0.6)));

      this.content = content;
      this.footer = footer;
    }
  }
}

class CardColor extends ColorImpl {
  CardColor(
    super.context, {
    Color? background,
    List<BoxShadow>? boxShadow,
  }) {
    void setBackground() {
      this.background = background ?? theme.colorScheme.surface;
    }

    void setBoxShadow() {
      this.boxShadow = boxShadow ??
          [
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
    }

    setBackground();
    setBoxShadow();
  }

  Color? background;
  List<BoxShadow>? boxShadow;
}

class CardSize extends SizeImpl {
  EdgeInsetsGeometry? padding;
  CrossAxisAlignment? childrenCrossAxisAlignment;

  CardSize(
    super.context, {
    EdgeInsetsGeometry? padding,
    CrossAxisAlignment? childrenCrossAxisAlignment,
  }) {
    this.padding = padding ?? const EdgeInsets.all(24).w;
    this.childrenCrossAxisAlignment =
        childrenCrossAxisAlignment ?? CrossAxisAlignment.start;
  }
}

class CardBorder extends BorderImpl {
  CardBorder(
    super.context, {
    BorderSide? borderSide,
    BorderRadius? borderRadius,
  }) {
    super.borderSide = borderSide ??
        BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            strokeAlign: BorderSide.strokeAlignInside);
    super.borderRadius =
        borderRadius ?? const BorderRadius.all(Radius.circular(8)).r;
  }
}

class CardTitle {
  final String title;

  /// If [style] is null, it will use the default style
  final TextStyle? style;

  const CardTitle({
    required this.title,
    this.style,
  });

  //copyWith
  CardTitle copyWith({
    String? title,
    TextStyle? style,
  }) {
    return CardTitle(
      title: title ?? this.title,
      style: style ?? this.style,
    );
  }
}

class CardSubtitle {
  final String subtitle;

  /// If [style] is null, it will use the default style
  final TextStyle? style;

  const CardSubtitle({
    required this.subtitle,
    this.style,
  });

  //copyWith
  CardSubtitle copyWith({
    String? subtitle,
    TextStyle? style,
  }) {
    return CardSubtitle(
      subtitle: subtitle ?? this.subtitle,
      style: style ?? this.style,
    );
  }
}

class CardContent {
  final Widget content;

  const CardContent({
    required this.content,
  });

  //copyWith
  CardContent copyWith({
    Widget? content,
  }) {
    return CardContent(
      content: content ?? this.content,
    );
  }
}

class CardFooter {
  final List<Widget> footer;

  final MainAxisAlignment mainAxisAlignment;

  final Axis direction;

  const CardFooter({
    required this.footer,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.direction = Axis.horizontal,
  });

  //copyWith
  CardFooter copyWith({
    List<Widget>? footer,
    MainAxisAlignment? mainAxisAlignment,
    Axis? direction,
  }) {
    return CardFooter(
      footer: footer ?? this.footer,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      direction: direction ?? this.direction,
    );
  }
}

class CardCustom {
  final Widget widget;

  const CardCustom({
    required this.widget,
  });
}

typedef DecorationBuilder = CardDecoration Function(BuildContext context);

class DefaultCard extends StatelessWidget {
  final DecorationBuilder decorationBuilder;

  const DefaultCard({
    super.key,
    required this.decorationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = decorationBuilder(context);
    return getChild(decoration);
  }

  Widget getChild(CardDecoration decoration) {
    return _getCard(decoration);
  }

  Widget _getCard(CardDecoration decoration) {
    return Container(
        decoration: BoxDecoration(
          color: decoration.colorTheme.background,
          borderRadius: decoration.borderTheme.borderRadius,
          boxShadow: decoration.colorTheme.boxShadow,
          border: decoration.borderTheme.borderSide != null
              ? Border.fromBorderSide(decoration.borderTheme.borderSide!)
              : null,
        ),
        padding: decoration.sizeTheme.padding,
        child: decoration.childTheme.custom == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    decoration.sizeTheme.childrenCrossAxisAlignment!,
                children: [
                  _getTitle(decoration),
                  if (decoration.childTheme.subtitle != null)
                    _getSubtitle(decoration),
                  _getContent(decoration),
                  _getFooter(decoration),
                ],
              )
            : Padding(
                padding: decoration.sizeTheme.padding!,
                child: decoration.childTheme.custom!.widget,
              ));
  }

  Widget _getTitle(CardDecoration decoration) {
    final title = decoration.childTheme.title!;
    return Text(title.title, style: decoration.childTheme.title!.style);
  }

  Widget _getSubtitle(CardDecoration decoration) {
    final subtitle = decoration.childTheme.subtitle!;

    Widget widget = Text(subtitle.subtitle, style: subtitle.style);

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: widget,
    );
  }

  Widget _getContent(CardDecoration decoration) {
    final content = decoration.childTheme.content!;

    Widget widget = content.content;

    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: widget,
    );
  }

  Widget _getFooter(CardDecoration decoration) {
    final footer = decoration.childTheme.footer!;

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
