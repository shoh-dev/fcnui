---
sidebar_position: 2
---

# Getting Started

Let's discover **fcnui** 🚀🚀🚀

### Prerequisites

- [Dart 3.x.x](https://https://dart.dev/)
- [Flutter 3.x.x](https://flutter.dev/)

### Installation

1. Install `fcnui` by running the following command (view on [pub.dev](https://pub.dev/packages/fcnui)):

    ```bash
    dart pub global activate fcnui
    ```
   > Note: You may need to restart the terminal or open a new one after installation.

2. Verify that `fcnui` is installed correctly by running the following command:

    ```bash
    fcnui version
    ```
   > Note: You should see the version of `fcnui` you have installed.

3. Initialize your Flutter project
    * Navigate to your Flutter project directory.
    * Run the following command to initialize `fcnui` in your project:
    ```bash
    fcnui init
    ```
   > Note: This command creates a `fcnui.json` file, which is used to manage components, and prompts you to select the components library (**default is /lib/components**).

4. Add `fcnui_base` dependency by running the following command or manually inside `pubspec.yaml` file (view on [pub.dev](https://pub.dev/packages/fcnui_base)):

    ```bash
    flutter pub add fcnui_base
    ```
    * or manually inside `pubspec.yaml` file:

    ```yaml
    dependencies:
      fcnui_base: latest_version
    ```

5. Wrap **MaterialApp/CupertinoApp** with **DefaultStoreProvider**:

    ```dart
    DefaultStoreProvider(
      // Optionally pass actions need to be activated on app start.
      // ex: ChangeFlexSchemeAction(usePlatformTheme: true)
      //initActions: [],
      child: MaterialApp(
        title: 'Your App Title',
        home: YourHomePage(),
      ),
    );
    ```
   > Optionally, you can use fcnui as your default theme. If not needed, simply wrap it. If needed, then wrap your MaterialApp with ThemeProvider and use vm.

6. Start adding components to your project by running the following command:

    ```bash
    fcnui add [component_name]
    ```
    * Replace [**component_name**] with the name of the component you want to add.
    * Optionally, can pass a list of components to add at once by separating them with a comma.

   That's it! You're now ready to leverage the power of fcnui in your projects. Happy coding! 🚀