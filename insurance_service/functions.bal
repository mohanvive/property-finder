import ballerina/sql;

// Fetch property snapshot from DB by ID
function fetchPropertySnapshot(int propertyId) returns PropertySnapshot|error {
    sql:ParameterizedQuery snapshotQuery = `
        SELECT property_id AS propertyId, category, property_type AS propertyType,
               city, state, zip_code AS zipCode, price, price_unit AS priceUnit,
               square_feet AS squareFeet
        FROM properties
        WHERE property_id = ${propertyId}`;
    return dbClient->queryRow(snapshotQuery);
}

// Estimate insurable property value from listing data
isolated function estimatePropertyValue(string category, decimal price, string priceUnit, decimal squareFeet) returns decimal {
    if category == CATEGORY_RESIDENTIAL_SALE {
        // Sale price is the property value
        return price;
    }
    // For rentals and business leases, estimate replacement cost from square footage
    decimal ratePerSqFt = category == CATEGORY_BUSINESS ? 280.0d : 210.0d;
    return (squareFeet * ratePerSqFt).round(2);
}

// Determine risk profile based on US state, category, and property type
isolated function buildRiskProfile(string state, string category, string propertyType) returns RiskProfile {
    string[] highRiskStates = ["FL", "LA", "TX", "CA", "HI"];
    string[] mediumRiskStates = ["OK", "KS", "MO", "TN", "NC", "SC", "GA", "AL", "MS", "AR", "VA", "NJ", "NY"];

    string riskLevel;
    string[] riskFactors = [];
    decimal baseRate;

    if highRiskStates.indexOf(state) is int {
        riskLevel = "HIGH";
        baseRate = 0.012d;
        match state {
            "FL" => { riskFactors = ["Hurricane risk", "Flood zone", "Sinkholes"]; }
            "LA" => { riskFactors = ["Hurricane risk", "Flood zone", "Storm surge"]; }
            "TX" => { riskFactors = ["Hurricane/hail risk", "Tornado corridor", "Flash flooding"]; }
            "CA" => { riskFactors = ["Earthquake risk", "Wildfire risk", "Landslide risk"]; }
            "HI" => { riskFactors = ["Hurricane risk", "Volcanic activity", "Tsunami risk"]; }
            _ => { riskFactors = ["Elevated natural disaster risk"]; }
        }
    } else if mediumRiskStates.indexOf(state) is int {
        riskLevel = "MEDIUM";
        baseRate = 0.008d;
        riskFactors = ["Tornado/severe storm risk", "Moderate flood exposure"];
    } else {
        riskLevel = "LOW";
        baseRate = 0.005d;
        riskFactors = ["Standard risk profile"];
    }

    // Category adjustments
    if category == CATEGORY_BUSINESS {
        baseRate = baseRate * 1.4d;
        riskFactors.push("Commercial liability exposure");
    }

    // Property-type adjustments
    match propertyType {
        "Restaurant" => {
            baseRate = baseRate * 1.5d;
            riskFactors.push("Elevated fire risk (commercial kitchen)");
        }
        "Warehouse" | "Industrial" => {
            baseRate = baseRate * 1.3d;
            riskFactors.push("Large-footprint structural risk");
        }
        "Studio" => { baseRate = baseRate * 0.85d; }
        "Land" => { baseRate = 0.001d; }
        _ => {}
    }

    return {riskLevel: riskLevel, riskFactors: riskFactors, baseRate: baseRate};
}

// Build the three coverage tiers from a risk profile and property value
isolated function buildCoverageTiers(RiskProfile riskProfile, string category, decimal propertyValue) returns InsuranceCoverage[] {
    decimal baseAnnual = (propertyValue * riskProfile.baseRate).round(2);

    // Perils
    string[] basicPerils = ["Fire", "Lightning", "Windstorm", "Hail", "Explosion", "Vandalism", "Theft"];
    string[] standardPerils = [...basicPerils, "Water damage", "Falling objects", "Weight of ice/snow", "Freezing pipes"];
    string[] comprehensivePerils = [...standardPerils, "Earthquake", "Flood", "Sewer backup", "Equipment breakdown"];

    // Add-on hints differ by category
    string[] residentialAddOns = ["Flood insurance", "Earthquake rider", "Jewelry/valuables", "Home office", "Identity theft protection", "Umbrella policy"];
    string[] businessAddOns = ["Business interruption", "General liability", "Workers compensation", "Cyber liability", "Equipment breakdown", "Commercial auto", "Umbrella policy"];
    string[] addOnHints = category == CATEGORY_BUSINESS ? businessAddOns : residentialAddOns;

    InsuranceCoverage basicTier = {
        tierName: "Basic",
        description: "Essential protection covering major perils. Ideal for budget-conscious owners or low-risk properties.",
        annualPremium: baseAnnual,
        monthlyPremium: (baseAnnual / 12.0d).round(2),
        coverageLimit: propertyValue,
        deductible: 2500.0d,
        includedPerils: basicPerils,
        optionalAddOns: addOnHints
    };

    decimal standardAnnual = (baseAnnual * 1.4d).round(2);
    InsuranceCoverage standardTier = {
        tierName: "Standard",
        description: "Broader everyday protection with lower deductible. The most popular choice for US property owners.",
        annualPremium: standardAnnual,
        monthlyPremium: (standardAnnual / 12.0d).round(2),
        coverageLimit: (propertyValue * 1.1d).round(2),
        deductible: 1500.0d,
        includedPerils: standardPerils,
        optionalAddOns: addOnHints
    };

    decimal comprehensiveAnnual = (baseAnnual * 2.0d).round(2);
    InsuranceCoverage comprehensiveTier = {
        tierName: "Comprehensive",
        description: "Maximum protection including natural disasters, lowest deductible, and extended replacement cost.",
        annualPremium: comprehensiveAnnual,
        monthlyPremium: (comprehensiveAnnual / 12.0d).round(2),
        coverageLimit: (propertyValue * 1.25d).round(2),
        deductible: 500.0d,
        includedPerils: comprehensivePerils,
        optionalAddOns: addOnHints
    };

    return [basicTier, standardTier, comprehensiveTier];
}

// Assemble a full InsuranceQuote from parts
isolated function assembleQuote(int? propertyId, string category, string propertyType,
        string city, string state, string zipCode,
        decimal propertyValue, decimal squareFeet) returns InsuranceQuote {

    RiskProfile riskProfile = buildRiskProfile(state, category, propertyType);
    InsuranceCoverage[] tiers = buildCoverageTiers(riskProfile, category, propertyValue);

    return {
        propertyId: propertyId,
        category: category,
        propertyType: propertyType,
        city: city,
        state: state,
        zipCode: zipCode,
        estimatedPropertyValue: propertyValue,
        squareFeet: squareFeet,
        riskLevel: riskProfile.riskLevel,
        riskFactors: riskProfile.riskFactors,
        coverageTiers: tiers,
        disclaimer: "These are estimated premiums for informational purposes only. " +
            "Actual premiums depend on property age, condition, claims history, credit score, and insurer underwriting. " +
            "Please consult a licensed insurance agent for a binding quote."
    };
}

// Get insurance quote for a known property by ID (looks up DB)
function getQuoteByPropertyId(int propertyId) returns InsuranceQuote|error {
    PropertySnapshot prop = check fetchPropertySnapshot(propertyId);
    decimal propertyValue = estimatePropertyValue(prop.category, prop.price, prop.priceUnit, prop.squareFeet);
    return assembleQuote(prop.propertyId, prop.category, prop.propertyType,
        prop.city, prop.state, prop.zipCode, propertyValue, prop.squareFeet);
}

// Get insurance quote for any property by providing details (no DB lookup)
isolated function getQuoteByDetails(string category, string propertyType, string city, string state,
        string zipCode, decimal propertyValue, decimal squareFeet) returns InsuranceQuote {
    return assembleQuote((), category, propertyType, city, state, zipCode, propertyValue, squareFeet);
}

// Compare Standard tier premiums across multiple states
isolated function compareByState(string category, string propertyType, decimal propertyValue,
        decimal squareFeet, string states) returns InsuranceComparisonResult {

    string[] stateList = re `,\s*`.split(states);
    StateComparisonEntry[] comparisons = [];

    foreach string stateCode in stateList {
        string trimmedState = stateCode.trim().toUpperAscii();
        if trimmedState.length() == 0 {
            continue;
        }
        RiskProfile riskProfile = buildRiskProfile(trimmedState, category, propertyType);
        decimal baseAnnual = (propertyValue * riskProfile.baseRate).round(2);
        decimal standardAnnual = (baseAnnual * 1.4d).round(2);
        decimal standardMonthly = (standardAnnual / 12.0d).round(2);

        StateComparisonEntry entry = {
            state: trimmedState,
            riskLevel: riskProfile.riskLevel,
            riskFactors: riskProfile.riskFactors,
            standardAnnualPremium: standardAnnual,
            standardMonthlyPremium: standardMonthly,
            coverageLimit: (propertyValue * 1.1d).round(2)
        };
        comparisons.push(entry);
    }

    return {
        category: category,
        propertyType: propertyType,
        propertyValue: propertyValue,
        stateComparisons: comparisons,
        disclaimer: "These are estimated Standard tier premiums for comparison purposes only. " +
            "Actual premiums vary by insurer, property condition, and individual risk factors."
    };
}

// Get available add-ons for a category and state
isolated function getAddOns(string category, string state) returns InsuranceAddOnsResult {
    InsuranceAddOn[] addOns;

    if category == CATEGORY_BUSINESS {
        addOns = [
            {name: "Business Interruption", description: "Covers lost income when your business cannot operate due to a covered loss.", annualCost: 1200.0d, recommended: true},
            {name: "General Liability", description: "Protects against third-party bodily injury and property damage claims.", annualCost: 800.0d, recommended: true},
            {name: "Workers Compensation", description: "Covers employee injuries and illnesses that occur on the job.", annualCost: 1500.0d, recommended: true},
            {name: "Cyber Liability", description: "Covers data breaches, ransomware attacks, and cyber incidents.", annualCost: 950.0d, recommended: false},
            {name: "Equipment Breakdown", description: "Covers repair or replacement of mechanical and electrical equipment.", annualCost: 600.0d, recommended: false},
            {name: "Commercial Auto", description: "Covers vehicles used for business purposes.", annualCost: 1800.0d, recommended: false},
            {name: "Umbrella Policy", description: "Additional liability coverage above your standard policy limits.", annualCost: 500.0d, recommended: true}
        ];
    } else {
        addOns = [
            {name: "Flood Insurance", description: "Covers flood damage not included in standard policies. Required in FEMA flood zones.", annualCost: 700.0d, recommended: true},
            {name: "Earthquake Rider", description: "Covers structural damage and personal property loss from earthquakes.", annualCost: 450.0d, recommended: false},
            {name: "Jewelry & Valuables", description: "Scheduled personal property coverage for jewelry, art, and collectibles.", annualCost: 200.0d, recommended: false},
            {name: "Home Office", description: "Covers business equipment and liability for home-based businesses.", annualCost: 150.0d, recommended: false},
            {name: "Identity Theft Protection", description: "Covers costs to restore your identity after theft.", annualCost: 100.0d, recommended: false},
            {name: "Umbrella Policy", description: "Additional liability coverage above your standard policy limits.", annualCost: 300.0d, recommended: true},
            {name: "Sewer Backup", description: "Covers damage from sewer or drain backup not included in standard policies.", annualCost: 120.0d, recommended: false}
        ];

        // State-specific add-ons
        if state == "CA" {
            addOns.push({name: "Wildfire Mitigation Rider", description: "Enhanced wildfire coverage with premium credits for mitigation measures.", annualCost: 380.0d, recommended: true});
        }
        if state == "FL" || state == "LA" {
            addOns.push({name: "Hurricane Shutters Credit", description: "Premium discount for certified hurricane protection installations.", annualCost: -150.0d, recommended: true});
            addOns.push({name: "Windstorm Rider", description: "Enhanced windstorm coverage for hurricane-prone coastal areas.", annualCost: 520.0d, recommended: true});
        }
        if state == "TX" {
            addOns.push({name: "Hail Damage Rider", description: "Enhanced hail coverage for Texas storm corridor properties.", annualCost: 280.0d, recommended: true});
        }
        if state == "HI" {
            addOns.push({name: "Volcanic Activity Rider", description: "Covers lava flow and volcanic ash damage.", annualCost: 600.0d, recommended: true});
        }
    }

    return {category: category, state: state, addOns: addOns};
}
