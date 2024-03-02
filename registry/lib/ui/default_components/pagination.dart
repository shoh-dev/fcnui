//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'fcnui_theme.dart';
import 'button.dart';

class PaginationDecoration extends DecorationImpl {
  PaginationDecoration(
    super.themeVm, {
    required PaginationAction action,
    required PaginationValue value,
    PaginationColor? color,
    PaginationBorder? border,
    PaginationSize? size,
  }) {
    super.action = action;
    super.value = value;
    super.color = color ?? PaginationColor(themeVm);
    super.border = border ?? PaginationBorder(themeVm);
    super.size = size ?? PaginationSize(themeVm);
  }

  @override
  PaginationAction get action => super.action as PaginationAction;

  @override
  PaginationValue get value => super.value as PaginationValue;

  @override
  PaginationColor get color => super.color as PaginationColor;

  @override
  PaginationBorder get border => super.border as PaginationBorder;

  @override
  PaginationSize get size => super.size as PaginationSize;
}

class PaginationValue extends ValueImpl {
  final int totalPages;
  final int limit;
  final int currentPage;

  /// The number of page buttons to show
  ///
  /// Default is 7
  PaginationValue(
    super.themeVm, {
    required this.totalPages,
    this.limit = 7,
    this.currentPage = 1,
  });
}

class PaginationAction extends ActionImpl<int> {
  PaginationAction(super.themeVm, {required ValueChanged<int> onPageChanged})
      : super(onValueChanged: onPageChanged);
}

class PaginationSize extends SizeImpl {
  PaginationSize(
    super.themeVm, {
    EdgeInsets? padding,
    Size? buttonMinSize,
  }) {
    this.padding = padding ?? const EdgeInsets.all(8).w;
    this.buttonMinSize = buttonMinSize ?? const Size(50, 50);
  }

  EdgeInsets? padding;
  Size? buttonMinSize;
}

class PaginationColor extends ColorImpl {
  PaginationColor(
    super.themeVm, {
    Color? backgroundColor,
    ButtonType? selectedButtonType,
    ButtonType? unselectedButtonType,
    ButtonType? arrowButtonType,
    IconData? nextButtonIcon,
    IconData? previousButtonIcon,
  }) {
    this.backgroundColor =
        backgroundColor ?? theme.dividerColor.withOpacity(.4);
    this.selectedButtonType = selectedButtonType ?? ButtonType.primary;
    this.unselectedButtonType = unselectedButtonType ?? ButtonType.ghost;
    this.arrowButtonType = arrowButtonType ?? ButtonType.icon;
    this.nextButtonIcon = nextButtonIcon ?? Icons.arrow_forward_ios;
    this.previousButtonIcon = previousButtonIcon ?? Icons.arrow_back_ios;
  }

  Color? backgroundColor;
  ButtonType? selectedButtonType;
  ButtonType? unselectedButtonType;
  ButtonType? arrowButtonType;
  IconData? nextButtonIcon;
  IconData? previousButtonIcon;
}

class PaginationBorder extends BorderImpl {
  PaginationBorder(
    super.themeVm, {
    BorderRadius? borderRadius,
  }) {
    super.borderRadius =
        borderRadius ?? BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r;
  }
}

typedef PaginationDecorationBuilder = PaginationDecoration Function(
    ThemeVm themeVm);

class DefaultPagination extends StatelessWidget {
  final PaginationDecorationBuilder decorationBuilder;

  const DefaultPagination({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      // If list of numbers are more than 8, then show 3 dots in the middle;
      // If list of numbers are less than 8, then show all numbers;

      final PaginationDecoration decoration = decorationBuilder(themeVm);

      final currentPage = decoration.value.currentPage;
      final totalPages = decoration.value.totalPages;

      final bool isFirstPage = currentPage == 1;
      final bool isLastPage = currentPage == totalPages;
      return Container(
        padding: decoration.size.padding,
        decoration: BoxDecoration(
          color: decoration.color.backgroundColor,
          borderRadius: decoration.border.borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _PreviousNextButton(
                decoration: decoration,
                onTap: totalPages == 1
                    ? null
                    : (isFirstPage ? null : () => _onPreviousPage(decoration))),
            const SizedBox(width: 7.0).w,
            ..._builder(decoration),
            const SizedBox(width: 7.0).w,
            _PreviousNextButton(
                decoration: decoration,
                isNext: true,
                onTap: totalPages == 1
                    ? null
                    : (isLastPage ? null : () => _onNextPage(decoration))),
          ],
        ).spaced(2),
      );
    });
  }

  List<Widget> _builder(PaginationDecoration decoration) {
    final tp = decoration.value.totalPages;
    final cp = decoration.value.currentPage;
    final int lim = decoration.value.limit;
    final int currentPage = decoration.value.currentPage;
    List<Widget> pages = [];

    if (tp > lim) {
      if (cp == 1 || cp == 2) {
        // 1 2 ... 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(1, decoration));
        }
        if (2 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(2, decoration));
        }
        if (3 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(3, decoration));
        }
        if (4 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(4, decoration));
        }
        if (5 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(5, decoration));
        }
        pages.add(_dots());
        if (tp == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp, decoration));
        }
      } else if (cp > 2 && cp < tp - 1) {
        // 1 ... 3 ... 8
        if (currentPage == 1) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(1, decoration));
        }
        if (cp == 4 && cp + 2 != currentPage) {
          pages.add(_isUnSelectedBtn(cp - 2, decoration));
        }
        if (cp > 4) pages.add(_dots());
        if (cp + 2 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        }
        if (cp == (tp - 2)) {
          pages.add(_isUnSelectedBtn(cp - 2, decoration)); //adds 6
        }
        if (cp - 1 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(cp - 1, decoration));
        }
        if (cp == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(cp, decoration));
        }
        if (cp + 1 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(cp + 1, decoration));
        }
        if (cp == 3 && cp + 2 != currentPage) {
          pages.add(_isUnSelectedBtn(cp + 2, decoration));
        }

        if (cp < tp - 3) pages.add(_dots());

        if (cp == tp - 3) {
          pages.add(_isUnSelectedBtn(cp + 2, decoration));
        }

        if (tp == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp, decoration));
        }
      } else if (cp == tp - 1 || cp == tp) {
        // 1 ... 7 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(1, decoration));
        }
        pages.add(_dots());
        if (tp - 4 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp - 4, decoration));
        }
        if (tp - 3 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp - 3, decoration));
        }
        if (tp - 2 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp - 2, decoration));
        }
        if (tp - 1 == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp - 1, decoration));
        }
        if (tp == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(tp, decoration));
        }
      }
    } else {
      for (int i = 1; i <= tp; i++) {
        if (i == currentPage) {
          pages.add(_isSelectedBtn(decoration));
        } else {
          pages.add(_isUnSelectedBtn(i, decoration));
        }
      }
    }

    return pages;
  }

  Widget _dots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 21.5).w,
        const Text("..."),
        const SizedBox(width: 21.5).w,
      ],
    );
  }

  Widget _isSelectedBtn(PaginationDecoration decoration) {
    final currentPage = decoration.value.currentPage;
    return DefaultButton(
      type: decoration.color.selectedButtonType!,
      decorationBuilder: (context, type) {
        return ButtonDecoration(
          context,
          type: type,
          size: ButtonSize(context, type,
              minimumSize: decoration.size.buttonMinSize),
          child: ButtonChild(context, text: currentPage.toString()),
          action: ButtonAction(context, onPressed: () {}),
        );
      },
    );
  }

  Widget _isUnSelectedBtn(int i, PaginationDecoration decoration) {
    return DefaultButton(
      type: decoration.color.unselectedButtonType!,
      decorationBuilder: (context, type) {
        return ButtonDecoration(
          context,
          type: type,
          size: ButtonSize(context, type,
              minimumSize: decoration.size.buttonMinSize),
          child: ButtonChild(context, text: i.toString()),
          action: ButtonAction(context,
              onPressed: () => _onNumberTap(i, decoration)),
        );
      },
    );
  }

  void _onNumberTap(int i, PaginationDecoration decoration) {
    decoration.action.onValueChanged!(i);
  }

  void _onPreviousPage(PaginationDecoration decoration) {
    final int currentPage = decoration.value.currentPage;
    //If currentPage is 1, then do nothing;
    //If currentPage is > 1, then set currentPage to currentPage - 1;
    if (currentPage == 1) {
      return;
    }
    decoration.action.onValueChanged!(currentPage - 1);
  }

  void _onNextPage(PaginationDecoration decoration) {
    final int currentPage = decoration.value.currentPage;
    final int totalPages = decoration.value.totalPages;
    final int lastPage = totalPages;

    //If currentPage is lastPage, then do nothing;
    //If currentPage is < lastPage, then set currentPage to currentPage + 1;

    if (currentPage == lastPage) {
      return;
    }
    decoration.action.onValueChanged!(currentPage + 1);
  }
}

class _PreviousNextButton extends StatelessWidget {
  final bool isNext;
  final VoidCallback? onTap;
  final PaginationDecoration decoration;

  const _PreviousNextButton(
      {this.isNext = false, this.onTap, required this.decoration});

  @override
  Widget build(BuildContext context) {
    if (isNext) {
      return DefaultButton(
        type: decoration.color.arrowButtonType!,
        decorationBuilder: (context, type) {
          return ButtonDecoration(
            context,
            type: type,
            size: ButtonSize(context, type,
                minimumSize: decoration.size.buttonMinSize),
            child: ButtonChild(context, icon: decoration.color.nextButtonIcon!),
            action: ButtonAction(context, onPressed: onTap),
          );
        },
      );
    }
    return DefaultButton(
      type: decoration.color.arrowButtonType!,
      decorationBuilder: (context, type) {
        return ButtonDecoration(
          context,
          type: type,
          size: ButtonSize(context, type,
              minimumSize: decoration.size.buttonMinSize),
          child:
              ButtonChild(context, icon: decoration.color.previousButtonIcon!),
          action: ButtonAction(context, onPressed: onTap),
        );
      },
    );
  }
}
