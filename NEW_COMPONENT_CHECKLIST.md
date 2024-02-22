## Checklist while adding a new component and registering.

- [x] Make a new branch with name `feature-[ComponentName]`.
- [x] Add component to `registry/ui/default_components` folder.
- [x] Each component must have a separate `View Model`.
  - [x] View model naming must be -> [ComponentName]Model.
  - [x] Component name must be -> Default[ComponentName].
  - [x] It must be based on `CamelCase` naming convention.
- [x] Add component page to `registry/ui/pages` folder.
- [x] Add component docs to `fcnui-website` docs.
- [x] Add component to `CHANGELOG.md` in docs.
- [x] Add component to `index.json` in API.
- [ ] Release homepage with new component.
- [ ] Release playground with new component.(use `releaseplay.sh`).
- [ ] Update root `README` with new component and link.