// Property categories (mirrors property_search_service)
const string CATEGORY_RESIDENTIAL_RENTAL = "RESIDENTIAL_RENTAL";
const string CATEGORY_RESIDENTIAL_SALE = "RESIDENTIAL_SALE";
const string CATEGORY_BUSINESS = "BUSINESS";

// Minimal property snapshot fetched from DB for insurance calculation
type PropertySnapshot record {|
    int propertyId;
    string category;
    string propertyType;
    string city;
    string state;
    string zipCode;
    decimal price;
    string priceUnit;
    decimal squareFeet;
|};

// A single insurance coverage tier
type InsuranceCoverage record {|
    string tierName;
    string description;
    decimal annualPremium;
    decimal monthlyPremium;
    decimal coverageLimit;
    decimal deductible;
    string[] includedPerils;
    string[] optionalAddOns;
|};

// Full insurance quote response
type InsuranceQuote record {|
    int? propertyId;
    string category;
    string propertyType;
    string city;
    string state;
    string zipCode;
    decimal estimatedPropertyValue;
    decimal squareFeet;
    string riskLevel;
    string[] riskFactors;
    InsuranceCoverage[] coverageTiers;
    string disclaimer;
|};

// A single optional insurance add-on
type InsuranceAddOn record {|
    string name;
    string description;
    decimal annualCost;
    boolean recommended;
|};

// Add-ons response
type InsuranceAddOnsResult record {|
    string category;
    string state;
    InsuranceAddOn[] addOns;
|};

// Risk profile used internally
type RiskProfile record {|
    string riskLevel;
    string[] riskFactors;
    decimal baseRate;
|};

// Single state entry in a comparison result
type StateComparisonEntry record {|
    string state;
    string riskLevel;
    string[] riskFactors;
    decimal standardAnnualPremium;
    decimal standardMonthlyPremium;
    decimal coverageLimit;
|};

// Result of a multi-state insurance comparison
type InsuranceComparisonResult record {|
    string category;
    string propertyType;
    decimal propertyValue;
    StateComparisonEntry[] stateComparisons;
    string disclaimer;
|};
