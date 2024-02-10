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

## UI Component Route

| Endpoint                           | Method | Description                                                                                                                  | Parameters                                |
|------------------------------------|--------|------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| `ui/app/api/ui/component/route.js` | GET    | Returns a default response indicating that the GET method is not available for this route.                                   | None                                      |
| `ui/app/api/ui/component/route.js` | POST   | Takes a request, extracts the 'componentNames' from the request body, and returns a response containing the found components | 'components': An array of component names |
