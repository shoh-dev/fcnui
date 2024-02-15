### `fcnui` CLI

The `fcnui` CLI (Command-Line Interface) tool is a powerful utility designed to simplify the management of `fcnui` components within Flutter projects.

### Links

<a target="_blank" href="https://fcnui.shoh.dev/docs/get_started">Getting started</a>

<a target="_blank" href="https://pub.dev/packages/fcnui">pub.dev</a>

#### Commands:

1. **init**:
    - Initializes a new Flutter project with `fcnui` integration.
    - Creates a directory structure for managing `fcnui` components.
    - Creates `fcnui.json` file to store the project's configuration.

2. **add [component_name]**:
    - Fetches the specified component from the API.
    - Checks if the component already exists in the project and if the version is up-to-date.
    - If the component is not present or an updated version is available, prompts the user to add or update the component.
    - Generates a new Dart file for the component if added or updated.

3. **help**:
    - Provides information about all available commands and their usage.

4. **version**:
    - Displays the current version of the `fcnui` CLI tool.

