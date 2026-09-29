// Property category constants
const string CATEGORY_RESIDENTIAL_RENTAL = "RESIDENTIAL_RENTAL";
const string CATEGORY_RESIDENTIAL_SALE = "RESIDENTIAL_SALE";
const string CATEGORY_BUSINESS = "BUSINESS";

// Property record returned from DB queries
type Property record {|
    int propertyId;
    string category;
    string propertyType;
    string title;
    string description;
    string address;
    string city;
    string state;
    string zipCode;
    decimal price;
    string priceUnit;
    decimal squareFeet;
    int? bedrooms;
    int? bathrooms;
    int? parkingSpaces;
    boolean petsAllowed;
    boolean furnished;
    string status;
    string listedDate;
    string agentName;
    string agentPhone;
    string agentEmail;
|};

// Simplified listing for search results
type PropertyListing record {|
    int propertyId;
    string category;
    string propertyType;
    string title;
    string address;
    string city;
    string state;
    string zipCode;
    decimal price;
    string priceUnit;
    decimal squareFeet;
    int? bedrooms;
    int? bathrooms;
    string status;
|};

// Search filters for residential rentals
type RentalSearchFilter record {|
    string? city;
    string? state;
    string? zipCode;
    decimal? minPrice;
    decimal? maxPrice;
    int? minBedrooms;
    int? maxBedrooms;
    int? minBathrooms;
    boolean? petsAllowed;
    boolean? furnished;
    decimal? minSquareFeet;
    decimal? maxSquareFeet;
    int? resultLimit;
    int? offset;
|};

// Search filters for residential sales
type SaleSearchFilter record {|
    string? city;
    string? state;
    string? zipCode;
    decimal? minPrice;
    decimal? maxPrice;
    int? minBedrooms;
    int? maxBedrooms;
    int? minBathrooms;
    decimal? minSquareFeet;
    decimal? maxSquareFeet;
    string? propertyType;
    int? resultLimit;
    int? offset;
|};

// Search filters for business properties
type BusinessSearchFilter record {|
    string? city;
    string? state;
    string? zipCode;
    decimal? minPrice;
    decimal? maxPrice;
    decimal? minSquareFeet;
    decimal? maxSquareFeet;
    string? propertyType;
    int? minParkingSpaces;
    int? resultLimit;
    int? offset;
|};

// Search result wrapper
type SearchResult record {|
    int totalCount;
    PropertyListing[] properties;
|};

// Property type info
type PropertyTypeInfo record {|
    string category;
    string propertyType;
    int count;
|};
