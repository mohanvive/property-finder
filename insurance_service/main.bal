import ballerina/mcp;

listener mcp:Listener mcpListener = new (mcpPort);

@mcp:ServiceConfig {
    info: {
        name: "PropertyInsuranceMCP",
        version: "1.0.0"
    }
}
service mcp:Service /mcp on mcpListener {

    @mcp:Tool {
        description: "Get insurance coverage options and estimated premium quotes for a property that exists in the database. " +
            "Provide the property ID to look up its details automatically. " +
            "Returns three coverage tiers (Basic, Standard, Comprehensive) with annual/monthly premiums, " +
            "coverage limits, deductibles, included perils, risk level, and risk factors. " +
            "Use getInsuranceQuoteByDetails instead if the property is not in the database."
    }
    remote function getInsuranceQuoteByPropertyId(int propertyId) returns InsuranceQuote|error {
        return getQuoteByPropertyId(propertyId);
    }

    @mcp:Tool {
        description: "Get insurance coverage options and estimated premium quotes for any property by providing its details manually. " +
            "Use this for properties not in the database, hypothetical scenarios, or custom valuations. " +
            "category: one of RESIDENTIAL_RENTAL, RESIDENTIAL_SALE, BUSINESS. " +
            "propertyType for residential: Apartment, House, Condo, Townhouse, Studio, Single-Family, Multi-Family, Land. " +
            "propertyType for business: Office, Retail, Warehouse, Industrial, Restaurant, Mixed-Use. " +
            "state: 2-letter US state abbreviation (e.g. CA, TX, NY, FL). " +
            "propertyValue: estimated market value in USD (for rentals/leases, use estimated replacement cost). " +
            "squareFeet: total square footage of the property. " +
            "Returns three coverage tiers with premiums, risk assessment, and risk factors."
    }
    remote function getInsuranceQuoteByDetails(
            string category,
            string propertyType,
            string city,
            string state,
            string zipCode,
            decimal propertyValue,
            decimal squareFeet
    ) returns InsuranceQuote {
        return getQuoteByDetails(category, propertyType, city, state, zipCode, propertyValue, squareFeet);
    }

    @mcp:Tool {
        description: "Get a list of available optional insurance add-ons for a given property category and US state. " +
            "Add-ons are supplemental coverages that can be added to any base insurance tier. " +
            "Some add-ons are state-specific (e.g. wildfire rider for CA, hurricane/windstorm for FL/LA, hail rider for TX, volcanic activity for HI). " +
            "category: one of RESIDENTIAL_RENTAL, RESIDENTIAL_SALE, BUSINESS. " +
            "state: 2-letter US state abbreviation. " +
            "Returns each add-on with its name, description, annual cost, and whether it is recommended."
    }
    remote function getInsuranceAddOns(string category, string state) returns InsuranceAddOnsResult {
        return getAddOns(category, state);
    }

    @mcp:Tool {
        description: "Compare insurance premiums across multiple US states for the same property type and value. " +
            "Useful for understanding how location affects insurance costs before purchasing or leasing a property. " +
            "category: one of RESIDENTIAL_RENTAL, RESIDENTIAL_SALE, BUSINESS. " +
            "propertyType: the type of property (e.g. Single-Family, Apartment, Office, Warehouse). " +
            "propertyValue: estimated property value in USD. " +
            "squareFeet: total square footage. " +
            "states: comma-separated list of 2-letter US state abbreviations to compare (e.g. 'CA,TX,FL,NY,CO'). " +
            "Returns a summary of Standard tier annual premiums and risk levels for each state."
    }
    remote function compareInsuranceByState(
            string category,
            string propertyType,
            decimal propertyValue,
            decimal squareFeet,
            string states
    ) returns InsuranceComparisonResult {
        return compareByState(category, propertyType, propertyValue, squareFeet, states);
    }
}
