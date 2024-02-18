## 18.02.2024

- [CLI] Change `print` method to custom `logger` method. Will format prints using `logger`.


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

### `fcnui_base`

- Min Dart SDK downgraded to 3.0.0 from 3.2.6
- Actions are checked before being executed for same value. Unnecessary rebuilds are prevented.
- [Fix] Issue where `ThemeVm.theme` was not inheriting `textTheme`.
- [Feature] Add screen util state and extensions.
- [Feature] Add `spaced_layout` helper. `Row` and `Column` has extension method for spaced. Adds space between children 

### `cli`

- Min Dart SDK downgraded to 3.0.0 from 3.2.6

### `ui`

- Remove `registry` folder from `public` folder

### `registry`

- Add `Card` component
- `Button` border color changed
- Add screen util extensions to components (Button and Card)
- [Remove] Remove widgets folder

### Root

- Add components list to README.md