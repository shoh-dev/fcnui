// Importing the default response function from the utils directory
import {defaultResponse} from '../../utils/defaultResponse';

// Importing the default theme components index from the registry directory
import defaultThemeComponentsIndex from '../../registry/ui/index.json';

// The GET method for this route, which currently returns a default response
// indicating that the GET method is not available for this route.
export async function GET(request) {
    return defaultResponse({success: false, data: "GET method is not available for this route. Use POST method only."});
}

// The POST method for this route. It takes a request, extracts the 'components'
// from the request body, and returns a response containing the components found
// in the defaultThemeComponentsIndex.
export async function POST(request) {
    try {
        // Extracting the 'components' from the request body
        const {componentNames} = await request.json();

        // If no 'componentNames' are provided, return an error message
        if (!componentNames) {
            return defaultResponse({success: false, error: "Provide 'componentNames' as list in the request body"});
        }

        // If the 'componentNames' array is empty, return an error message
        if (componentNames.length < 1) {
            return defaultResponse({success: false, error: "Provide at least one component name"});
        }

        // Initialize an array to store the found componentNames
        let foundComponents = [];
        let notFoundComponents = [];

        // Loop through the defaultThemeComponentsIndex to find the requested componentNames
        for (let i = 0; i < componentNames.length; i++) {
            const componentName = componentNames[i];
            const component = defaultThemeComponentsIndex.find(component => component.name === componentName);
            if (component) {
                foundComponents.push(component);
            } else {
                notFoundComponents.push(componentName);
            }
        }

        if(foundComponents.length < 1) return defaultResponse({success: false, error: "No components found"});

        // If components are found, return them in the response
        return defaultResponse({
            success: true, error: {
                "notFoundComponents": notFoundComponents
            },
            data: foundComponents,
        });
    } catch (error) {
        // If an error occurs, return the error message in the response
        return defaultResponse({success: false, error: error.message});
    }
}