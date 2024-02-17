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