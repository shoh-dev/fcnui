//Create a defaultResponse method which takes parameters for success, data and error and returns a JSON object with the same keys. and export it


export function defaultResponse({ data, success = false, error }) {
    return Response.json({
        success,
        data,
        error
    });
}