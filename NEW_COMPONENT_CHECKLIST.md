## Checklist while adding a new component and registering.

- [ ] Make a new branch with name `feature-[ComponentName]`.
- [ ] Add component to `registry/ui/default_components` folder.
- [ ] Each component must have a separate `View Model`.
  - [ ] View model naming must be -> [ComponentName]Model.
  - [ ] Component name must be -> Default[ComponentName].
  - [ ] It must be based on `CamelCase` naming convention.
- [ ] Add component page to `registry/ui/pages` folder.
- [ ] Add component docs to `fcnui-website` docs.
- [ ] Add component to `CHANGELOG.md` in docs.
- [ ] Add component to `index.json` in API.
- [ ] Release playground with new component.(use `releaseplay.sh`).
- [ ] Release homepage with new component.
- [ ] Update root `README` with new component and link.