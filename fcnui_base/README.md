### `fcnui_base` Package for Flutter

The `fcnui_base` package for Flutter is a comprehensive collection of dependencies.

### Pub Dev Link

<a target="_blank" href="https://pub.dev/packages/fcnui_base">Open pub.dev</a>


### Getting Started

<a target="_blank" href="https://github.com/shoh-dev/fcnui/wiki">Full Documentation</a>

#### Dependencies:

| Dependency        | Version |
|-------------------|---------|
| redux             | 5.0.0   |
| flutter_redux     | 0.10.0  |
| flex_color_scheme | 7.3.1   |
| equatable         | 2.0.5   |
| get_it            | 7.6.7   |

#### Features:

- **Redux Store**: Includes a Redux store with states and actions to manage application themes.
- **ThemeState**: Manages theme-related states such as theme mode, flex scheme, and platform theme usage.
- **Actions**:
    - **ChangeThemeModeAction**: Accepts a string representing the theme mode (e.g., `ThemeMode.light.name`). Default: `system`.
    - **ChangeFlexSchemeAction**: Accepts a string representing the flex scheme (e.g., FlexScheme.red.name). Default: `greyLaw`.
    - **ChangeUsePlatformThemeAction**: Accepts a boolean value to indicate whether to use the platform's theme from `Theme.of(context)` for installed components. Default: `false`.
- **Providers**:
    - **DefaultStoreProvider**: Wrapper used to encompass `MaterialApp` or `CupertinoApp`. Important for the proper functioning of components.
    - **ThemeProvider**: Offers all required `ThemeState` data and actions to toggle theme mode and change themes.
    - **DefaultStoreConnector\<T\>**: Provides a `T` type of state for Redux store connection.

### How to use:
  - To call a specific action use:
    - `fcnGetIt.get<Store<AppState>>().dispatch(ChangeThemeModeAction(ThemeMode.light.name));`
  - Or can use `DefaultStoreConnector<YourVm>` and create your `ViewModel` to dispatch actions. For reference, see `ThemeProvider`. 
