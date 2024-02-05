### flutter_cn_ui Package for Flutter

The flutter_cn_ui package for Flutter is a comprehensive collection of dependencies and default components, carefully crafted to empower developers in building stunning user interfaces for their Flutter applications. This package leverages a range of essential dependencies, ensuring seamless integration and optimal performance in your projects.

#### Dependencies:

| Dependency       | Version |
|------------------|---------|
| redux            | 5.0.0   |
| flutter_redux    | 0.10.0  |
| flex_color_scheme| 7.3.1   |
| equatable       | 2.0.5   |
| get_it           | 7.6.7   |

#### Features:

- **Redux Store**: Includes a Redux store with states and actions to manage application themes.
- **ThemeState**: Manages theme-related states such as theme mode, flex scheme, and platform theme usage.
- **Actions**:
    - **ChangeThemeModeAction**: Accepts a string representing the theme mode (e.g., ThemeMode.light.name). Default: system.
    - **ChangeFlexSchemeAction**: Accepts a string representing the flex scheme (e.g., FlexScheme.red.name). Default: greyLaw.
    - **ChangeUsePlatformThemeAction**: Accepts a boolean value to indicate whether to use the platform's theme from Theme.of(context) for installed components. Default: false.
- **Providers**:
    - **DefaultStoreConnector\<T\>**: Provides a T type of state for Redux store connection.
    - **DefaultStoreProvider**: Wrapper used to encompass MaterialApp or CupertinoApp. Important for the proper functioning of components.
    - **ThemeProvider**: Offers all required ThemeState data and actions to toggle theme mode and change themes.