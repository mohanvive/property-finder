import ballerina/mcp;

listener mcp:Listener mcpListener = new (mcpPort);

@mcp:ServiceConfig {
    info: {
        name: "PropertyFinderMCP",
        version: "1.0.0"
    }
}
service mcp:Service /mcp on mcpListener {

    @mcp:Tool {
        description: "Search for residential rental properties (apartments, houses, condos, townhouses) in the United States. " +
            "Filter by city, state, zip code, price range (monthly rent), number of bedrooms/bathrooms, " +
            "pet policy, furnished status, and square footage. Returns a list of matching listings with key details."
    }
    remote function searchResidentialRentals(
            string? city = (),
            string? state = (),
            string? zipCode = (),
            decimal? minPrice = (),
            decimal? maxPrice = (),
            int? minBedrooms = (),
            int? maxBedrooms = (),
            int? minBathrooms = (),
            boolean? petsAllowed = (),
            boolean? furnished = (),
            decimal? minSquareFeet = (),
            decimal? maxSquareFeet = (),
            int? resultLimit = (),
            int? offset = ()
    ) returns SearchResult|error {
        RentalSearchFilter searchFilter = {
            city: city,
            state: state,
            zipCode: zipCode,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minBedrooms: minBedrooms,
            maxBedrooms: maxBedrooms,
            minBathrooms: minBathrooms,
            petsAllowed: petsAllowed,
            furnished: furnished,
            minSquareFeet: minSquareFeet,
            maxSquareFeet: maxSquareFeet,
            resultLimit: resultLimit,
            offset: offset
        };
        return queryResidentialRentals(searchFilter);
    }

    @mcp:Tool {
        description: "Search for residential properties for sale (single-family homes, condos, townhouses, multi-family, land) " +
            "in the United States. Filter by city, state, zip code, price range (sale price), number of bedrooms/bathrooms, " +
            "square footage, and property type. Returns a list of matching listings with key details."
    }
    remote function searchResidentialSales(
            string? city = (),
            string? state = (),
            string? zipCode = (),
            decimal? minPrice = (),
            decimal? maxPrice = (),
            int? minBedrooms = (),
            int? maxBedrooms = (),
            int? minBathrooms = (),
            decimal? minSquareFeet = (),
            decimal? maxSquareFeet = (),
            string? propertyType = (),
            int? resultLimit = (),
            int? offset = ()
    ) returns SearchResult|error {
        SaleSearchFilter searchFilter = {
            city: city,
            state: state,
            zipCode: zipCode,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minBedrooms: minBedrooms,
            maxBedrooms: maxBedrooms,
            minBathrooms: minBathrooms,
            minSquareFeet: minSquareFeet,
            maxSquareFeet: maxSquareFeet,
            propertyType: propertyType,
            resultLimit: resultLimit,
            offset: offset
        };
        return queryResidentialSales(searchFilter);
    }

    @mcp:Tool {
        description: "Search for business/commercial properties (office space, retail, warehouse, industrial, restaurant, mixed-use) " +
            "in the United States. Filter by city, state, zip code, price range (monthly rent or sale price), " +
            "square footage, property type, and minimum parking spaces. Returns a list of matching listings."
    }
    remote function searchBusinessProperties(
            string? city = (),
            string? state = (),
            string? zipCode = (),
            decimal? minPrice = (),
            decimal? maxPrice = (),
            decimal? minSquareFeet = (),
            decimal? maxSquareFeet = (),
            string? propertyType = (),
            int? minParkingSpaces = (),
            int? resultLimit = (),
            int? offset = ()
    ) returns SearchResult|error {
        BusinessSearchFilter searchFilter = {
            city: city,
            state: state,
            zipCode: zipCode,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minSquareFeet: minSquareFeet,
            maxSquareFeet: maxSquareFeet,
            propertyType: propertyType,
            minParkingSpaces: minParkingSpaces,
            resultLimit: resultLimit,
            offset: offset
        };
        return queryBusinessProperties(searchFilter);
    }

    @mcp:Tool {
        description: "Get the full details of a specific property by its unique property ID. " +
            "Returns all available information including description, agent contact details, amenities, and listing date."
    }
    remote function getPropertyDetails(int propertyId) returns Property|error {
        return queryPropertyDetails(propertyId);
    }

    @mcp:Tool {
        description: "Get a list of all available property types grouped by category (RESIDENTIAL_RENTAL, RESIDENTIAL_SALE, BUSINESS) " +
            "along with the count of active listings for each type. Useful for understanding what types of properties are available " +
            "before performing a search."
    }
    remote function getPropertyTypes() returns PropertyTypeInfo[]|error {
        return queryPropertyTypes();
    }
}


