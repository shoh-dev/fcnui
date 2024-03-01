Full changelog of the project.

## Information
- [CLI](https://www.pub.dev/packages/fcnui) - Command Line Interface for `fcnui` package.
- Homepage - Current website for `fcnui`.
- Playground - Playground for `fcnui` package which is used to display widgets in docs.
- Registry - All components `.dart` is located in.
- Base - `fcnui_base` package which is the core of `fcnui` package.
- API - `fcnui` package API documentation which provides `json` format components.

## 28.02.2024

- Changed the way to create and update components' view models.
  - There are several abstract classes which will be extended to create view models.
  - `DecorationImpl`, `ColorImpl`, `BorderImpl`, `SizeImpl`, `StateImpl`, `ActionImpl`, `ChildImpl`
- Update `button` view model with new way.
- Update `card` view model with new way.
- 

## 28.02.2024

- [Registry] Add `switch` component;
- [Homepage] Add `switch` component;

## 23.02.2024

- [Base] Add `pluto_grid` package.

## 22.02.2024

- [Registry] Add `switch` component.
- [Homepage] Add `switch` documentation.
- [Registry] Add `radio` component.
- [Homepage] Add `radio` documentation.

## 21.02.2024

- [Registry] Add `dropdown` component.
- [Homepage] Add `dropdown` documentation.

## 20.02.2024

- Add TextEditingController parameter for `Input` component.

## 19.02.2024

- [CLI] Remove `get_it` and `equatable` dependencies.
- [CLI] Added some tests. (Not complete).
- [Base] Add new dependencies to README.md.
- [Registry] Add `Checkbox` component.
- [Playground] Add `checkbox` page.
- [Registry] Add `PageImpl` that makes pages for Playground.
- [Homepage] Add `checkbox` documentation.

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