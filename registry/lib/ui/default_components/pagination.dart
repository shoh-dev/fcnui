import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class DefaultPagination extends StatelessWidget {
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int currentPage;

  /// The number of page buttons to show
  ///
  /// Default is 7
  final int limit;

  const DefaultPagination(
      {super.key,
      required this.totalPages,
      this.limit = 7,
      required this.onPageChanged,
      required this.currentPage});

  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == totalPages;

  @override
  Widget build(BuildContext context) {
    // If list of numbers are more than 8, then show 3 dots in the middle;
    // If list of numbers are less than 8, then show all numbers;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PreviousNextButton(
              onTap: totalPages == 1
                  ? null
                  : (isFirstPage ? null : _onPreviousPage)),
          const SizedBox(width: 7.0).w,
          ..._builder(),
          const SizedBox(width: 7.0).w,
          _PreviousNextButton(
              isNext: true,
              onTap:
                  totalPages == 1 ? null : (isLastPage ? null : _onNextPage)),
        ],
      ).spaced(2),
    );
  }

  List<Widget> _builder() {
    final tp = totalPages;
    final cp = currentPage;
    final int lim = limit;
    List<Widget> pages = [];

    if (tp > lim) {
      if (cp == 1 || cp == 2) {
        // 1 2 ... 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(1));
        }
        if (2 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(2));
        }
        if (3 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(3));
        }
        if (4 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(4));
        }
        if (5 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(5));
        }
        pages.add(_dots());
        if (tp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp));
        }
      } else if (cp > 2 && cp < tp - 1) {
        // 1 ... 3 ... 8
        if (currentPage == 1) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(1));
        }
        if (cp == 4 && cp + 2 != currentPage) {
          pages.add(_isUnSelectedBtn(cp - 2));
        }
        if (cp > 4) pages.add(_dots());
        if (cp + 2 == currentPage) {
          pages.add(_isSelectedBtn());
        }
        if (cp == (tp - 2)) {
          pages.add(_isUnSelectedBtn(cp - 2)); //adds 6
        }
        if (cp - 1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(cp - 1));
        }
        if (cp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(cp));
        }
        if (cp + 1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(cp + 1));
        }
        if (cp == 3 && cp + 2 != currentPage) {
          pages.add(_isUnSelectedBtn(cp + 2));
        }

        if (cp < tp - 3) pages.add(_dots());

        if (cp == tp - 3) {
          pages.add(_isUnSelectedBtn(cp + 2));
        }

        if (tp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp));
        }
      } else if (cp == tp - 1 || cp == tp) {
        // 1 ... 7 8
        if (1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(1));
        }
        pages.add(_dots());
        if (tp - 4 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 4));
        }
        if (tp - 3 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 3));
        }
        if (tp - 2 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 2));
        }
        if (tp - 1 == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp - 1));
        }
        if (tp == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(tp));
        }
      }
    } else {
      for (int i = 1; i <= tp; i++) {
        if (i == currentPage) {
          pages.add(_isSelectedBtn());
        } else {
          pages.add(_isUnSelectedBtn(i));
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

  Widget _isSelectedBtn() {
    return DefaultButton(
      variant: PrimaryButtonVariant(
        text: currentPage.toString(),
        onPressed: () {},
      ),
    );
  }

  Widget _isUnSelectedBtn(int i) {
    return DefaultButton(
      variant: GhostButtonVariant(
        text: i.toString(),
        onPressed: () => _onNumberTap(i),
      ),
    );
  }

  void _onNumberTap(int i) {
    onPageChanged(i);
  }

  void _onPreviousPage() {
    //If currentPage is 1, then do nothing;
    //If currentPage is > 1, then set currentPage to currentPage - 1;
    if (currentPage == 1) {
      return;
    }
    onPageChanged(currentPage - 1);
  }

  void _onNextPage() {
    final int lastPage = totalPages;

    //If currentPage is lastPage, then do nothing;
    //If currentPage is < lastPage, then set currentPage to currentPage + 1;

    if (currentPage == lastPage) {
      return;
    }
    onPageChanged(currentPage + 1);
  }
}

class _PreviousNextButton extends StatelessWidget {
  final bool isNext;
  final VoidCallback? onTap;

  const _PreviousNextButton({this.isNext = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (isNext) {
      return DefaultButton(
        variant: IconButtonVariant(
          iconSize: 12,
          icon: Icons.arrow_forward_ios,
          onPressed: onTap,
        ),
      );
    }
    return DefaultButton(
      variant: IconButtonVariant(
        iconSize: 12,
        icon: Icons.arrow_back_ios,
        onPressed: onTap,
      ),
    );
  }
}
