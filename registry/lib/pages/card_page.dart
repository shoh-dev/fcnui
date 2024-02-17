import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/default_components.dart';
import 'package:registry/ui/layout/default_layout.dart';

class CardPage extends StatelessWidget {
  final bool isCustom;
  final bool isDecorated;

  const CardPage({
    super.key,
    required this.isCustom,
    required this.isDecorated,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: (controller) {
      return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        controller: controller,
        children: [
          Center(
            child: SingleChildScrollView(
              child: ThemeProvider(
                  builder: (context, vm) => preview(context, vm.theme)),
            ),
          ),
          Center(child: SingleChildScrollView(child: code(context))),
        ],
      );
    });
  }

  Widget preview(BuildContext context, ThemeData theme) {
    if (isCustom) {
      return _customCard(context, theme);
    } else if (isDecorated) {
      return _decoratedCard(theme);
    } else {
      return _defaultCard();
    }
  }

  Widget code(BuildContext context) {
    String code = """
    """;

    if (isCustom) {
      code = """
    DefaultCard(
      custom: CardCustom(
        widget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Notification', style: textTheme.displaySmall),
          Text('You have 3 new notifications', style: textTheme.labelLarge),
          const SizedBox(height: 20),
          DefaultCard(
            custom: CardCustom(
                widget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      size: 32,
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Push Notifications',
                              style: textTheme.labelLarge),
                          Text('Send push notifications to your users',
                              style: textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ).spaced(10)),
          ),
          const SizedBox(height: 20),
          DefaultButton(
              variant: PrimaryButtonVariant(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 48),
            onPressed: () {},
            text: "Mark all as read",
            icon: Icons.check,
          )),
        ]),
      ),
    ),
      """;
    } else if (isDecorated) {
      code = """
    DefaultCard(
      decoration: CardDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: colorScheme.error,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside),
        color: colorScheme.error.withOpacity(0.2),
      ),
      variant: CardVariant(
        title: const CardTitle(title: "Create project"),
        subtitle: const CardSubtitle(
            subtitle: "Deploy your new project in one-click"),
        content: CardContent(
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Project name",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Deadline",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
            ],
          ).spaced(20),
        ),
        footer: CardFooter(
          footer: [
            DefaultButton(
              variant: OutlineButtonVariant(
                onPressed: () {},
                text: "Cancel",
              ),
            ),
            DefaultButton(
              variant: PrimaryButtonVariant(
                onPressed: () {},
                text: "Deploy",
              ),
            ),
          ],
        ),
      ),
    ),
      """;
    } else {
      code = """
    DefaultCard(
      variant: CardVariant(
        title: const CardTitle(title: "Create project"),
        subtitle: const CardSubtitle(
            subtitle: "Deploy your new project in one-click"),
        content: CardContent(
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Project name",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Deadline",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
            ],
          ).spaced(20),
        ),
        footer: CardFooter(
          footer: [
            DefaultButton(
              variant: OutlineButtonVariant(
                onPressed: () {},
                text: "Cancel",
              ),
            ),
            DefaultButton(
              variant: PrimaryButtonVariant(
                onPressed: () {},
                text: "Deploy",
              ),
            ),
          ],
        ),
      ),
    ),
      """;
    }
    return AnySyntaxHighlighter(code,
        hasCopyButton: true, padding: 16, isSelectableText: true);
  }

  Widget _defaultCard() {
    return DefaultCard(
      variant: CardVariant(
        title: const CardTitle(title: "Create project"),
        subtitle: const CardSubtitle(
            subtitle: "Deploy your new project in one-click"),
        content: CardContent(
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Project name",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Deadline",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
            ],
          ).spaced(20),
        ),
        footer: CardFooter(
          footer: [
            DefaultButton(
              variant: OutlineButtonVariant(
                onPressed: () {},
                text: "Cancel",
              ),
            ),
            DefaultButton(
              variant: PrimaryButtonVariant(
                onPressed: () {},
                text: "Deploy",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customCard(BuildContext context, ThemeData theme) {
    final textTheme = theme.textTheme;
    return DefaultCard(
      custom: CardCustom(
        widget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Notification', style: textTheme.displaySmall),
          Text('You have 3 new notifications', style: textTheme.labelLarge),
          const SizedBox(height: 20),
          DefaultCard(
            custom: CardCustom(
                widget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      size: 32,
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Push Notifications',
                              style: textTheme.labelLarge),
                          Text('Send push notifications to your users',
                              style: textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ).spaced(10)),
          ),
          const SizedBox(height: 20),
          DefaultButton(
              variant: PrimaryButtonVariant(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 48),
            onPressed: () {},
            text: "Mark all as read",
            icon: Icons.check,
          )),
        ]),
      ),
    );
  }

  Widget _decoratedCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return DefaultCard(
      decoration: CardDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: colorScheme.error,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside),
        color: colorScheme.error.withOpacity(0.2),
      ),
      variant: CardVariant(
        title: const CardTitle(title: "Create project"),
        subtitle: const CardSubtitle(
            subtitle: "Deploy your new project in one-click"),
        content: CardContent(
          content: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Project name",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Deadline",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
            ],
          ).spaced(20),
        ),
        footer: CardFooter(
          footer: [
            DefaultButton(
              variant: OutlineButtonVariant(
                onPressed: () {},
                text: "Cancel",
              ),
            ),
            DefaultButton(
              variant: PrimaryButtonVariant(
                onPressed: () {},
                text: "Deploy",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
