import ballerina/mcp;

listener mcp:StreamableHttpListener mcpListener = check new (9010);

@mcp:StreamableHttpServiceConfig {
    info: {
        name: "PropertyFinderMCP",
        version: "1.0.0"
    },
    sessionMode: mcp:STATELESS,
    options: {
        instructions: "This MCP service provides tools to search for properties in the United States. " +
            "It supports three categories: residential rentals, residential properties for sale, and business/commercial properties. " +
            "Use searchResidentialRentals to find rental homes/apartments, searchResidentialSales to find homes for purchase, " +
            "searchBusinessProperties to find commercial spaces, getPropertyDetails to retrieve full details of a specific property, " +
            "and getPropertyTypes to discover available property types for filtering."
    }
}
service mcp:StreamableHttpAdvancedService /mcp on mcpListener {

    remote function onListTools() returns mcp:ListToolsResult|mcp:ServerError {
        return {
            tools: [
                {
                    name: "searchResidentialRentals",
                    description: "Search for residential rental properties (apartments, houses, condos, townhouses) in the United States. " +
                        "Filter by city, state, zip code, price range (monthly rent), number of bedrooms/bathrooms, " +
                        "pet policy, furnished status, and square footage. Returns a list of matching listings with key details.",
                    inputSchema: {
                        'type: "object",
                        properties: {
                            "city": {"type": "string", "description": "City name to filter by"},
                            "state": {"type": "string", "description": "US state abbreviation (e.g. CA, TX, NY)"},
                            "zipCode": {"type": "string", "description": "ZIP code to filter by"},
                            "minPrice": {"type": "number", "description": "Minimum monthly rent in USD"},
                            "maxPrice": {"type": "number", "description": "Maximum monthly rent in USD"},
                            "minBedrooms": {"type": "integer", "description": "Minimum number of bedrooms"},
                            "maxBedrooms": {"type": "integer", "description": "Maximum number of bedrooms"},
                            "minBathrooms": {"type": "integer", "description": "Minimum number of bathrooms"},
                            "petsAllowed": {"type": "boolean", "description": "Filter by pet policy"},
                            "furnished": {"type": "boolean", "description": "Filter by furnished status"},
                            "minSquareFeet": {"type": "number", "description": "Minimum square footage"},
                            "maxSquareFeet": {"type": "number", "description": "Maximum square footage"},
                            "resultLimit": {"type": "integer", "description": "Max results to return (default 10)"},
                            "offset": {"type": "integer", "description": "Pagination offset (default 0)"}
                        },
                        required: []
                    }
                },
                {
                    name: "searchResidentialSales",
                    description: "Search for residential properties for sale (single-family homes, condos, townhouses, multi-family, land) " +
                        "in the United States. Filter by city, state, zip code, price range (sale price), number of bedrooms/bathrooms, " +
                        "square footage, and property type. Returns a list of matching listings with key details.",
                    inputSchema: {
                        'type: "object",
                        properties: {
                            "city": {"type": "string", "description": "City name to filter by"},
                            "state": {"type": "string", "description": "US state abbreviation (e.g. CA, TX, NY)"},
                            "zipCode": {"type": "string", "description": "ZIP code to filter by"},
                            "minPrice": {"type": "number", "description": "Minimum sale price in USD"},
                            "maxPrice": {"type": "number", "description": "Maximum sale price in USD"},
                            "minBedrooms": {"type": "integer", "description": "Minimum number of bedrooms"},
                            "maxBedrooms": {"type": "integer", "description": "Maximum number of bedrooms"},
                            "minBathrooms": {"type": "integer", "description": "Minimum number of bathrooms"},
                            "minSquareFeet": {"type": "number", "description": "Minimum square footage"},
                            "maxSquareFeet": {"type": "number", "description": "Maximum square footage"},
                            "propertyType": {"type": "string", "description": "Property type: Single-Family, Condo, Townhouse, Multi-Family, Land"},
                            "resultLimit": {"type": "integer", "description": "Max results to return (default 10)"},
                            "offset": {"type": "integer", "description": "Pagination offset (default 0)"}
                        },
                        required: []
                    }
                },
                {
                    name: "searchBusinessProperties",
                    description: "Search for business/commercial properties (office space, retail, warehouse, industrial, restaurant, mixed-use) " +
                        "in the United States. Filter by city, state, zip code, price range (monthly rent or sale price), " +
                        "square footage, property type, and minimum parking spaces. Returns a list of matching listings.",
                    inputSchema: {
                        'type: "object",
                        properties: {
                            "city": {"type": "string", "description": "City name to filter by"},
                            "state": {"type": "string", "description": "US state abbreviation (e.g. CA, TX, NY)"},
                            "zipCode": {"type": "string", "description": "ZIP code to filter by"},
                            "minPrice": {"type": "number", "description": "Minimum price in USD"},
                            "maxPrice": {"type": "number", "description": "Maximum price in USD"},
                            "minSquareFeet": {"type": "number", "description": "Minimum square footage"},
                            "maxSquareFeet": {"type": "number", "description": "Maximum square footage"},
                            "propertyType": {"type": "string", "description": "Property type: Office, Retail, Warehouse, Industrial, Restaurant, Mixed-Use"},
                            "minParkingSpaces": {"type": "integer", "description": "Minimum number of parking spaces"},
                            "resultLimit": {"type": "integer", "description": "Max results to return (default 10)"},
                            "offset": {"type": "integer", "description": "Pagination offset (default 0)"}
                        },
                        required: []
                    }
                },
                {
                    name: "getPropertyDetails",
                    description: "Get the full details of a specific property by its unique property ID. " +
                        "Returns all available information including description, agent contact details, amenities, and listing date.",
                    inputSchema: {
                        'type: "object",
                        properties: {
                            "propertyId": {"type": "integer", "description": "The unique property ID"}
                        },
                        required: ["propertyId"]
                    }
                },
                {
                    name: "getPropertyTypes",
                    description: "Get a list of all available property types grouped by category (RESIDENTIAL_RENTAL, RESIDENTIAL_SALE, BUSINESS) " +
                        "along with the count of active listings for each type. Useful for understanding what types of properties are available " +
                        "before performing a search.",
                    inputSchema: {
                        'type: "object",
                        properties: {},
                        required: []
                    }
                }
            ]
        };
    }

    remote function onCallTool(mcp:CallToolParams params) returns mcp:CallToolResult|mcp:ServerError {
        record {}? args = params.arguments;
        map<json> argMap = {};
        if args is map<json> {
            argMap = args;
        }

        match params.name {
            "searchResidentialRentals" => {
                RentalSearchFilter searchFilter = buildRentalSearchFilter(argMap);
                SearchResult|error result = queryResidentialRentals(searchFilter);
                return buildCallToolResult(result);
            }
            "searchResidentialSales" => {
                SaleSearchFilter searchFilter = buildSaleSearchFilter(argMap);
                SearchResult|error result = queryResidentialSales(searchFilter);
                return buildCallToolResult(result);
            }
            "searchBusinessProperties" => {
                BusinessSearchFilter searchFilter = buildBusinessSearchFilter(argMap);
                SearchResult|error result = queryBusinessProperties(searchFilter);
                return buildCallToolResult(result);
            }
            "getPropertyDetails" => {
                json idJson = argMap["propertyId"] ?: 0;
                int|error propertyId = int:fromString(idJson.toString());
                if propertyId is error {
                    return {content: [{'type: "text", text: "Invalid propertyId: must be an integer"}], isError: true};
                }
                Property|error result = queryPropertyDetails(propertyId);
                return buildCallToolResult(result);
            }
            "getPropertyTypes" => {
                PropertyTypeInfo[]|error result = queryPropertyTypes();
                return buildCallToolResult(result);
            }
            _ => {
                return error mcp:ServerError(string `Unknown tool: ${params.name}`);
            }
        }
    }
}
