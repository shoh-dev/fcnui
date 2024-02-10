### `fcnui` CLI

The `fcnui` CLI (Command-Line Interface) tool is a powerful utility designed to simplify the management of `fcnui` components within Flutter projects.

### Pub Dev Link

<a target="_blank" href="https://pub.dev/packages/fcnui">Open pub.dev</a>

### Getting Started

<a target="_blank" href="https://github.com/shoh-dev/fcnui/wiki">Full Documentation</a>

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