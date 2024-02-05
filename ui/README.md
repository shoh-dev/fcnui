## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

# API Documentation for /ui/component

## UI Provider Routes

| Endpoint | Description |
| --- | --- |
| `ui_provider/routes/index.dart` | Handles incoming requests and returns a JSON response with a single key-value pair, where the key is 'name' and the value is 'Flutter Demo'. |

## UI Component Route

| Endpoint | Method | Description | Parameters |
| --- | --- | --- | --- |
| `ui/app/api/ui/component/route.js` | GET | Returns a default response indicating that the GET method is not available for this route. | None |
| `ui/app/api/ui/component/route.js` | POST | Takes a request, extracts the 'componentNames' from the request body, and returns a response containing the components found in the `defaultThemeComponentsIndex`. | 'components': An array of component names |

## UI Theme componentNames

| File | Description |
| --- | --- |
| `ui/app/api/registry/themes/default/ui/index.json` | Contains a list of UI componentNames for the default theme. Each component is represented as a JSON object with a 'name' and 'content' key. The 'content' key contains the Dart code for the component. |

This format provides a clear and concise overview of your API's endpoints, their methods, descriptions, and required parameters. It also includes a section for UI theme componentNames.