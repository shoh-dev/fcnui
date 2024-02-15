---
sidebar_position: 1
---

# About

Welcome to the Flutter port of [shadcn-ui](https://ui.shadcn.com/), a component library originally made for React developers. This project aims to bring the power and flexibility of shadcn-ui to Flutter developers, allowing them to easily integrate beautiful and customizable components into their Flutter applications.

![hero](https://github.com/shoh-dev/fcnui/blob/main/ui/public/cover.png?raw=true)

## Packages

This project consists of the following packages:

### cli

The `cli` package is a Dart-based CLI tool that streamlines the process of working with `fcnui`. It contains all the necessary commands to initialize a project, add new components.

### fcnui_base

The `fcnui_base` package is the heart of `fcnui`. Written in Dart (Flutter), it provides developers with a comprehensive set of dependencies.

### registry

The `registry` package is a Flutter application designed for testing `fcnui` components individually. This app serves as a visual playground where developers can explore and interact with each component in isolation. By including the `fcnui_base`, the registry ensures that components are thoroughly tested and ready for integration into real-world projects.

### ui

The `ui` package is a `Next.js` application that complements `fcnui`. It provides an `API` for all the components in `JSON` format, enabling seamless integration with the `cli` tool.