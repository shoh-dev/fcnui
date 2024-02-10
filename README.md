# shadcn-ui for Flutter

Welcome to the Flutter port of [shadcn-ui](https://ui.shadcn.com/), a component library originally made for React developers. This project aims to bring the power and flexibility of shadcn-ui to Flutter developers, allowing them to easily integrate beautiful and customizable components into their Flutter applications.

![hero](ui/public/cover.png)

## Packages

This project consists of the following packages:

### cli

The `cli` package is a Dart-based CLI tool that streamlines the process of working with fcnui. It contains all the necessary commands to initialize a project, add new components, and manage dependencies efficiently.

### com.shohdev.cli.examplefcnui_base

The `com.shohdev.cli.examplefcnui_base` package is the heart of fcnui. Written in Dart (Flutter), it provides developers with a comprehensive set of dependencies and default components. With this package, integrating stunning UI elements into your Flutter applications becomes seamless.

### registry

The `registry` package is a Flutter application designed for testing fcnui components individually. This app serves as a visual playground where developers can explore and interact with each component in isolation. By including the `com.shohdev.cli.examplefcnui_base`, the registry ensures that components are thoroughly tested and ready for integration into real-world projects.

### ui

The `ui` package is a Next.js application that complements fcnui. It provides an API for all the components in JSON format, enabling seamless integration with the `cli` tool. By offering a user-friendly interface for accessing component information, the `ui` package enhances the development experience for Flutter developers using fcnui.

[//]: # (## Documentation Website)

[//]: # ()
[//]: # (Explore the comprehensive documentation for fcnui on the [FlutterCN Docs website]&#40;https://fluttercn.shoh.dev&#41;. This website serves as a central hub for all documentation related to the project, including installation guides, component usage instructions, API references, and more.)

[//]: # ()
[//]: # (Whether you're a beginner getting started with fcnui or an experienced developer looking for detailed information on specific components, the FlutterCN Docs website has you covered. Dive deep into the world of Flutter development with fcnui and unleash the full potential of your applications.)

[//]: # ()
[//]: # (Visit [fluttercn.shoh.dev]&#40;https://fluttercn.shoh.dev&#41; to access the documentation and accelerate your Flutter development journey!)

## Getting Started

To get started with fcnui, follow these steps:

1. **Install fcnui**:
    - Install `fcnui` as a Dart global dependency by running the following command:

    ```bash
    dart pub global activate fcnui
    ```

   Note: You may need to restart the terminal or open a new one after installation.

2. **Initialize your Flutter project**:
    - Navigate to your Flutter project directory.
    - Run the following command to initialize fcnui:

    ```bash
    fcnui init
    ```

   This command creates a `fcnui.json` file, which is used to manage components, and prompts you to select the components library (default is `/lib/components`).

3. **Add com.shohdev.cli.examplefcnui_base dependency**:
    - Inside your Flutter project, add `com.shohdev.cli.examplefcnui_base` from pub.dev as a dependency. You can do this by running:

    ```bash
    flutter pub add com.shohdev.cli.examplefcnui_base
    ```

4. **Wrap MaterialApp/CupertinoApp with ThemeProvider**:
    - Wrap your `MaterialApp` or `CupertinoApp` with `ThemeProvider` and configure it accordingly:

    ```dart
    ThemeProvider(
      builder: (context, vm) => MaterialApp(
        // Configure theme, dark theme, and theme mode as needed
        title: 'Your App Title',
        home: YourHomePage(),
      ),
    );
    ```

   Optionally, you can use `flutter_cn_theme` as your default theme. If not needed, simply wrap it.

5. **Start adding components**:
    - Begin adding components to your project by running the following command:

    ```bash
    fcnui add [component_name]
    ```

   Replace `[component_name]` with the name of the component you want to add.

That's it! You're now ready to leverage the power of fcnui in your projects. Happy coding!