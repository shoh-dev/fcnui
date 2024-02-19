Full changelog of the project.

## Information
- [CLI](https://www.pub.dev/packages/fcnui) - Command Line Interface for `fcnui` package.
- Homepage - Current website for `fcnui`.
- Playground - Playground for `fcnui` package which is used to display widgets in docs.
- Registry - All components `.dart` is located in.
- Base - `fcnui_base` package which is the core of `fcnui` package.
- API - `fcnui` package API documentation which provides `json` format components.

## 18.02.2024

- [CLI] Change `print` method to custom `logger` method. Will format prints using `logger`.
- [Homepage] Add `input` and `form` documentation.
- [Homepage] Add CHANGELOG page inside docs.
- [Root] CHANGELOG from root and to Homepage. 


## 17.02.2024

- [Homepage] Add `card` documentation.
- [Playground] Add `card`, `input` page.
- [Playground] Update `Card` with new `Input` component.
- [Registry] Add [DefaultDisabled] component. Wrap any widget with this component to disable it.
- [Base] Fix `textTheme` issue when not used `fcnui` theme.
- [API] Add `card`, `disabled`, `input`, `form`, `label`, `with_label`, `save_button` in `json` schema.
- [CLI] Rename `ComponentData` to `RegistryComponentData`.
- [CLI] Add `remove` command. Removes component dart file and unregisters from `jcnui.json`.

## 16.02.2024

- [fcnui_base] Min Dart SDK downgraded to 3.0.0 from 3.2.6
- [fcnui_base] Actions are checked before being executed for same value. Unnecessary rebuilds are prevented.
- [fcnui_base] Fix issue where `ThemeVm.theme` was not inheriting `textTheme`.
- [fcnui_base] (Feature). Add screen util state and extensions.
- [fcnui_base] (Feature). Add `spaced_layout` helper. `Row` and `Column` has extension method for spaced. Adds space between children. Simply add `spaced` as extension to `Row` or `Column` widgets.

## before 16.02.2024

- [CLI] Min Dart SDK downgraded to 3.0.0 from 3.2.6
- [API] Remove `registry` folder from `public` folder
- [Registry] Add `Card` component
- [Registry] `Button` border color changed
- [Registry] Add screen util extensions to components (Button and Card)
- [Registry] Remove widgets folder
- [Root] Add components list to README.md