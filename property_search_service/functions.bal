import ballerina/sql;
import ballerina/mcp;

// Query residential rental properties from the database
function queryResidentialRentals(RentalSearchFilter searchFilter) returns SearchResult|error {
    int limitVal = searchFilter.resultLimit ?: 10;
    int offsetVal = searchFilter.offset ?: 0;

    sql:ParameterizedQuery filterQuery = buildRentalFilters(searchFilter);
    sql:ParameterizedQuery countQuery = `SELECT COUNT(*) FROM properties WHERE category = ${CATEGORY_RESIDENTIAL_RENTAL} AND status = 'ACTIVE'`;
    sql:ParameterizedQuery countFilterQuery = buildRentalFilters(searchFilter);
    sql:ParameterizedQuery fullCountQuery = sql:queryConcat(countQuery, countFilterQuery);
    int totalCount = check dbClient->queryRow(fullCountQuery);

    sql:ParameterizedQuery fullQuery = sql:queryConcat(
        `SELECT property_id AS propertyId, category, property_type AS propertyType, title, address, city, state, 
        zip_code AS zipCode, price, price_unit AS priceUnit, square_feet AS squareFeet, bedrooms, bathrooms, status 
        FROM properties WHERE category = ${CATEGORY_RESIDENTIAL_RENTAL} AND status = 'ACTIVE'`,
        filterQuery
    );
    stream<PropertyListing, sql:Error?> resultStream = dbClient->query(fullQuery);
    PropertyListing[] allResults = check from PropertyListing prop in resultStream
        select prop;

    int endIdx = int:min(offsetVal + limitVal, allResults.length());
    PropertyListing[] propertyList = offsetVal < allResults.length() ? allResults.slice(offsetVal, endIdx) : [];

    return {totalCount: totalCount, properties: propertyList};
}

// Build filter clauses for rental search
function buildRentalFilters(RentalSearchFilter searchFilter) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery filterQuery = ` `;

    string? cityVal = searchFilter.city;
    if cityVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND city = ${cityVal}`);
    }

    string? stateVal = searchFilter.state;
    if stateVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND state = ${stateVal}`);
    }

    string? zipCodeVal = searchFilter.zipCode;
    if zipCodeVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND zip_code = ${zipCodeVal}`);
    }

    decimal? minPriceVal = searchFilter.minPrice;
    if minPriceVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND price >= ${minPriceVal}`);
    }

    decimal? maxPriceVal = searchFilter.maxPrice;
    if maxPriceVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND price <= ${maxPriceVal}`);
    }

    int? minBedroomsVal = searchFilter.minBedrooms;
    if minBedroomsVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND bedrooms >= ${minBedroomsVal}`);
    }

    int? maxBedroomsVal = searchFilter.maxBedrooms;
    if maxBedroomsVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND bedrooms <= ${maxBedroomsVal}`);
    }

    int? minBathroomsVal = searchFilter.minBathrooms;
    if minBathroomsVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND bathrooms >= ${minBathroomsVal}`);
    }

    boolean? petsAllowedVal = searchFilter.petsAllowed;
    if petsAllowedVal is boolean {
        filterQuery = sql:queryConcat(filterQuery, ` AND pets_allowed = ${petsAllowedVal}`);
    }

    boolean? furnishedVal = searchFilter.furnished;
    if furnishedVal is boolean {
        filterQuery = sql:queryConcat(filterQuery, ` AND furnished = ${furnishedVal}`);
    }

    decimal? minSqFtVal = searchFilter.minSquareFeet;
    if minSqFtVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND square_feet >= ${minSqFtVal}`);
    }

    decimal? maxSqFtVal = searchFilter.maxSquareFeet;
    if maxSqFtVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND square_feet <= ${maxSqFtVal}`);
    }

    return filterQuery;
}

// Query residential sale properties from the database
function queryResidentialSales(SaleSearchFilter searchFilter) returns SearchResult|error {
    int limitVal = searchFilter.resultLimit ?: 10;
    int offsetVal = searchFilter.offset ?: 0;

    sql:ParameterizedQuery filterQuery = buildSaleFilters(searchFilter);
    sql:ParameterizedQuery countQuery = `SELECT COUNT(*) FROM properties WHERE category = ${CATEGORY_RESIDENTIAL_SALE} AND status = 'ACTIVE'`;
    sql:ParameterizedQuery countFilterQuery = buildSaleFilters(searchFilter);
    sql:ParameterizedQuery fullCountQuery = sql:queryConcat(countQuery, countFilterQuery);
    int totalCount = check dbClient->queryRow(fullCountQuery);

    sql:ParameterizedQuery fullQuery = sql:queryConcat(
        `SELECT property_id AS propertyId, category, property_type AS propertyType, title, address, city, state, 
        zip_code AS zipCode, price, price_unit AS priceUnit, square_feet AS squareFeet, bedrooms, bathrooms, status 
        FROM properties WHERE category = ${CATEGORY_RESIDENTIAL_SALE} AND status = 'ACTIVE'`,
        filterQuery
    );
    stream<PropertyListing, sql:Error?> resultStream = dbClient->query(fullQuery);
    PropertyListing[] allResults = check from PropertyListing prop in resultStream
        select prop;

    int endIdx = int:min(offsetVal + limitVal, allResults.length());
    PropertyListing[] propertyList = offsetVal < allResults.length() ? allResults.slice(offsetVal, endIdx) : [];

    return {totalCount: totalCount, properties: propertyList};
}

// Build filter clauses for sale search
function buildSaleFilters(SaleSearchFilter searchFilter) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery filterQuery = ` `;

    string? cityVal = searchFilter.city;
    if cityVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND city = ${cityVal}`);
    }

    string? stateVal = searchFilter.state;
    if stateVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND state = ${stateVal}`);
    }

    string? zipCodeVal = searchFilter.zipCode;
    if zipCodeVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND zip_code = ${zipCodeVal}`);
    }

    decimal? minPriceVal = searchFilter.minPrice;
    if minPriceVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND price >= ${minPriceVal}`);
    }

    decimal? maxPriceVal = searchFilter.maxPrice;
    if maxPriceVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND price <= ${maxPriceVal}`);
    }

    int? minBedroomsVal = searchFilter.minBedrooms;
    if minBedroomsVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND bedrooms >= ${minBedroomsVal}`);
    }

    int? maxBedroomsVal = searchFilter.maxBedrooms;
    if maxBedroomsVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND bedrooms <= ${maxBedroomsVal}`);
    }

    int? minBathroomsVal = searchFilter.minBathrooms;
    if minBathroomsVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND bathrooms >= ${minBathroomsVal}`);
    }

    decimal? minSqFtVal = searchFilter.minSquareFeet;
    if minSqFtVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND square_feet >= ${minSqFtVal}`);
    }

    decimal? maxSqFtVal = searchFilter.maxSquareFeet;
    if maxSqFtVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND square_feet <= ${maxSqFtVal}`);
    }

    string? propertyTypeVal = searchFilter.propertyType;
    if propertyTypeVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND property_type = ${propertyTypeVal}`);
    }

    return filterQuery;
}

// Query business properties from the database
function queryBusinessProperties(BusinessSearchFilter searchFilter) returns SearchResult|error {
    int limitVal = searchFilter.resultLimit ?: 10;
    int offsetVal = searchFilter.offset ?: 0;

    sql:ParameterizedQuery filterQuery = buildBusinessFilters(searchFilter);
    sql:ParameterizedQuery countQuery = `SELECT COUNT(*) FROM properties WHERE category = ${CATEGORY_BUSINESS} AND status = 'ACTIVE'`;
    sql:ParameterizedQuery countFilterQuery = buildBusinessFilters(searchFilter);
    sql:ParameterizedQuery fullCountQuery = sql:queryConcat(countQuery, countFilterQuery);
    int totalCount = check dbClient->queryRow(fullCountQuery);

    sql:ParameterizedQuery fullQuery = sql:queryConcat(
        `SELECT property_id AS propertyId, category, property_type AS propertyType, title, address, city, state, 
        zip_code AS zipCode, price, price_unit AS priceUnit, square_feet AS squareFeet, bedrooms, bathrooms, status 
        FROM properties WHERE category = ${CATEGORY_BUSINESS} AND status = 'ACTIVE'`,
        filterQuery
    );
    stream<PropertyListing, sql:Error?> resultStream = dbClient->query(fullQuery);
    PropertyListing[] allResults = check from PropertyListing prop in resultStream
        select prop;

    int endIdx = int:min(offsetVal + limitVal, allResults.length());
    PropertyListing[] propertyList = offsetVal < allResults.length() ? allResults.slice(offsetVal, endIdx) : [];

    return {totalCount: totalCount, properties: propertyList};
}

// Build filter clauses for business property search
function buildBusinessFilters(BusinessSearchFilter searchFilter) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery filterQuery = ` `;

    string? cityVal = searchFilter.city;
    if cityVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND city = ${cityVal}`);
    }

    string? stateVal = searchFilter.state;
    if stateVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND state = ${stateVal}`);
    }

    string? zipCodeVal = searchFilter.zipCode;
    if zipCodeVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND zip_code = ${zipCodeVal}`);
    }

    decimal? minPriceVal = searchFilter.minPrice;
    if minPriceVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND price >= ${minPriceVal}`);
    }

    decimal? maxPriceVal = searchFilter.maxPrice;
    if maxPriceVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND price <= ${maxPriceVal}`);
    }

    decimal? minSqFtVal = searchFilter.minSquareFeet;
    if minSqFtVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND square_feet >= ${minSqFtVal}`);
    }

    decimal? maxSqFtVal = searchFilter.maxSquareFeet;
    if maxSqFtVal is decimal {
        filterQuery = sql:queryConcat(filterQuery, ` AND square_feet <= ${maxSqFtVal}`);
    }

    string? propertyTypeVal = searchFilter.propertyType;
    if propertyTypeVal is string {
        filterQuery = sql:queryConcat(filterQuery, ` AND property_type = ${propertyTypeVal}`);
    }

    int? minParkingVal = searchFilter.minParkingSpaces;
    if minParkingVal is int {
        filterQuery = sql:queryConcat(filterQuery, ` AND parking_spaces >= ${minParkingVal}`);
    }

    return filterQuery;
}

// Get full property details by ID
function queryPropertyDetails(int propertyId) returns Property|error {
    sql:ParameterizedQuery detailQuery = `SELECT property_id AS propertyId, category, property_type AS propertyType, title, description, address, city, state, 
        zip_code AS zipCode, price, price_unit AS priceUnit, square_feet AS squareFeet, bedrooms, bathrooms, 
        parking_spaces AS parkingSpaces, pets_allowed AS petsAllowed, furnished, 
        status, listed_date AS listedDate, agent_name AS agentName, agent_phone AS agentPhone, agent_email AS agentEmail 
        FROM properties WHERE property_id = ${propertyId}`;
    Property propertyDetail = check dbClient->queryRow(detailQuery);
    return propertyDetail;
}

// Get available property types with counts
function queryPropertyTypes() returns PropertyTypeInfo[]|error {
    sql:ParameterizedQuery typesQuery = `SELECT category, property_type AS propertyType, COUNT(*) as count 
        FROM properties WHERE status = 'ACTIVE' 
        GROUP BY category, property_type 
        ORDER BY category, property_type`;
    stream<PropertyTypeInfo, sql:Error?> resultStream = dbClient->query(typesQuery);
    PropertyTypeInfo[] typeList = check from PropertyTypeInfo propType in resultStream
        select propType;
    return typeList;
}

// Extract an optional string from the arg map
isolated function getOptionalString(map<json> argMap, string key) returns string? {
    json val = argMap[key] ?: ();
    if val is string {
        return val;
    }
    return ();
}

// Extract an optional int from the arg map
isolated function getOptionalInt(map<json> argMap, string key) returns int? {
    json val = argMap[key] ?: ();
    if val is int {
        return val;
    }
    if val is float {
        return <int>val;
    }
    if val is decimal {
        return <int>val;
    }
    if val is string {
        int|error parsed = int:fromString(val);
        if parsed is int {
            return parsed;
        }
        // Try parsing as float then converting
        float|error floatParsed = float:fromString(val);
        if floatParsed is float {
            return <int>floatParsed;
        }
    }
    return ();
}

// Extract an optional decimal from the arg map
isolated function getOptionalDecimal(map<json> argMap, string key) returns decimal? {
    json val = argMap[key] ?: ();
    if val is decimal {
        return val;
    }
    if val is float {
        return <decimal>val;
    }
    if val is int {
        return <decimal>val;
    }
    if val is string {
        decimal|error parsed = decimal:fromString(val);
        if parsed is decimal {
            return parsed;
        }
    }
    return ();
}

// Extract an optional boolean from the arg map
isolated function getOptionalBoolean(map<json> argMap, string key) returns boolean? {
    json val = argMap[key] ?: ();
    if val is boolean {
        return val;
    }
    if val is string {
        boolean|error parsed = boolean:fromString(val);
        if parsed is boolean {
            return parsed;
        }
    }
    return ();
}

// Build RentalSearchFilter from raw arg map
function buildRentalSearchFilter(map<json> argMap) returns RentalSearchFilter {
    return {
        city: getOptionalString(argMap, "city"),
        state: getOptionalString(argMap, "state"),
        zipCode: getOptionalString(argMap, "zipCode"),
        minPrice: getOptionalDecimal(argMap, "minPrice"),
        maxPrice: getOptionalDecimal(argMap, "maxPrice"),
        minBedrooms: getOptionalInt(argMap, "minBedrooms"),
        maxBedrooms: getOptionalInt(argMap, "maxBedrooms"),
        minBathrooms: getOptionalInt(argMap, "minBathrooms"),
        petsAllowed: getOptionalBoolean(argMap, "petsAllowed"),
        furnished: getOptionalBoolean(argMap, "furnished"),
        minSquareFeet: getOptionalDecimal(argMap, "minSquareFeet"),
        maxSquareFeet: getOptionalDecimal(argMap, "maxSquareFeet"),
        resultLimit: getOptionalInt(argMap, "resultLimit"),
        offset: getOptionalInt(argMap, "offset")
    };
}

// Build SaleSearchFilter from raw arg map
function buildSaleSearchFilter(map<json> argMap) returns SaleSearchFilter {
    return {
        city: getOptionalString(argMap, "city"),
        state: getOptionalString(argMap, "state"),
        zipCode: getOptionalString(argMap, "zipCode"),
        minPrice: getOptionalDecimal(argMap, "minPrice"),
        maxPrice: getOptionalDecimal(argMap, "maxPrice"),
        minBedrooms: getOptionalInt(argMap, "minBedrooms"),
        maxBedrooms: getOptionalInt(argMap, "maxBedrooms"),
        minBathrooms: getOptionalInt(argMap, "minBathrooms"),
        minSquareFeet: getOptionalDecimal(argMap, "minSquareFeet"),
        maxSquareFeet: getOptionalDecimal(argMap, "maxSquareFeet"),
        propertyType: getOptionalString(argMap, "propertyType"),
        resultLimit: getOptionalInt(argMap, "resultLimit"),
        offset: getOptionalInt(argMap, "offset")
    };
}

// Build BusinessSearchFilter from raw arg map
function buildBusinessSearchFilter(map<json> argMap) returns BusinessSearchFilter {
    return {
        city: getOptionalString(argMap, "city"),
        state: getOptionalString(argMap, "state"),
        zipCode: getOptionalString(argMap, "zipCode"),
        minPrice: getOptionalDecimal(argMap, "minPrice"),
        maxPrice: getOptionalDecimal(argMap, "maxPrice"),
        minSquareFeet: getOptionalDecimal(argMap, "minSquareFeet"),
        maxSquareFeet: getOptionalDecimal(argMap, "maxSquareFeet"),
        propertyType: getOptionalString(argMap, "propertyType"),
        minParkingSpaces: getOptionalInt(argMap, "minParkingSpaces"),
        resultLimit: getOptionalInt(argMap, "resultLimit"),
        offset: getOptionalInt(argMap, "offset")
    };
}

// Build a CallToolResult from any result or error
function buildCallToolResult(anydata|error result) returns mcp:CallToolResult {
    if result is error {
        return {
            content: [{'type: "text", text: result.message()}],
            isError: true
        };
    }
    return {
        content: [{'type: "text", text: result.toJsonString()}]
    };
}
