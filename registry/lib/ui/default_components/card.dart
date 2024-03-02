//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';

class CardDecoration extends DecorationImpl {
  CardDecoration(
    super.themeVm, {
    required CardChild child,
    CardColor? color,
    CardBorder? border,
    CardSize? size,
  }) {
    super.child = child;
    super.color = color ?? CardColor(themeVm);
    super.border = border ?? CardBorder(themeVm);
    super.size = size ?? CardSize(themeVm);
  }

  @override
  CardChild get child => super.child as CardChild;

  @override
  CardColor get color => super.color as CardColor;

  @override
  CardBorder get border => super.border as CardBorder;

  @override
  CardSize get size => super.size as CardSize;
}

class CardChild extends ChildImpl {
  CardTitle? title;
  CardSubtitle? subtitle;
  CardContent? content;
  CardFooter? footer;

  CardCustom? custom;

  CardChild(super.themeVm,
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
    super.themeVm, {
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
    super.themeVm, {
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
    super.themeVm, {
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

typedef CardDecorationBuilder = CardDecoration Function(ThemeVm themeVm);

class DefaultCard extends StatelessWidget {
  final CardDecorationBuilder decorationBuilder;

  const DefaultCard({
    super.key,
    required this.decorationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final decoration = decorationBuilder(themeVm);
      return getChild(decoration);
    });
  }

  Widget getChild(CardDecoration decoration) {
    return _getCard(decoration);
  }

  Widget _getCard(CardDecoration decoration) {
    return Container(
        decoration: BoxDecoration(
          color: decoration.color.background,
          borderRadius: decoration.border.borderRadius,
          boxShadow: decoration.color.boxShadow,
          border: decoration.border.borderSide != null
              ? Border.fromBorderSide(decoration.border.borderSide!)
              : null,
        ),
        padding: decoration.size.padding,
        child: decoration.child.custom == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: decoration.size.childrenCrossAxisAlignment!,
                children: [
                  _getTitle(decoration),
                  if (decoration.child.subtitle != null)
                    _getSubtitle(decoration),
                  _getContent(decoration),
                  _getFooter(decoration),
                ],
              )
            : Padding(
                padding: decoration.size.padding!,
                child: decoration.child.custom!.widget,
              ));
  }

  Widget _getTitle(CardDecoration decoration) {
    final title = decoration.child.title!;
    return Text(title.title, style: decoration.child.title!.style);
  }

  Widget _getSubtitle(CardDecoration decoration) {
    final subtitle = decoration.child.subtitle!;

    Widget widget = Text(subtitle.subtitle, style: subtitle.style);

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: widget,
    );
  }

  Widget _getContent(CardDecoration decoration) {
    final content = decoration.child.content!;

    Widget widget = content.content;

    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: widget,
    );
  }

  Widget _getFooter(CardDecoration decoration) {
    final footer = decoration.child.footer!;

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
