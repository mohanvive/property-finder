-- Property Finder Database Schema
-- Supports: Residential Rentals, Residential Sales, Business/Commercial Properties

CREATE DATABASE IF NOT EXISTS property_finder;
USE property_finder;

CREATE TABLE IF NOT EXISTS properties (
    property_id     INT AUTO_INCREMENT PRIMARY KEY,

    -- Category: RESIDENTIAL_RENTAL | RESIDENTIAL_SALE | BUSINESS
    category        VARCHAR(30)     NOT NULL,

    -- Property type within category
    -- Residential Rental: Apartment, House, Condo, Townhouse, Studio
    -- Residential Sale:   Single-Family, Condo, Townhouse, Multi-Family, Land
    -- Business:           Office, Retail, Warehouse, Industrial, Restaurant, Mixed-Use
    property_type   VARCHAR(50)     NOT NULL,

    title           VARCHAR(255)    NOT NULL,
    description     TEXT,

    -- Location
    address         VARCHAR(255)    NOT NULL,
    city            VARCHAR(100)    NOT NULL,
    state           CHAR(2)         NOT NULL,   -- US state abbreviation e.g. CA, TX, NY
    zip_code        VARCHAR(10)     NOT NULL,

    -- Pricing
    price           DECIMAL(15, 2)  NOT NULL,
    price_unit      VARCHAR(20)     NOT NULL DEFAULT 'USD',  -- e.g. USD/month, USD

    -- Size & features
    square_feet     DECIMAL(10, 2)  NOT NULL,
    bedrooms        INT,            -- NULL for business properties
    bathrooms       INT,            -- NULL for business properties
    parking_spaces  INT,

    -- Residential-specific flags
    pets_allowed    BOOLEAN         NOT NULL DEFAULT FALSE,
    furnished       BOOLEAN         NOT NULL DEFAULT FALSE,

    -- Listing metadata
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',  -- ACTIVE | SOLD | RENTED | INACTIVE
    listed_date     DATE            NOT NULL,

    -- Agent contact
    agent_name      VARCHAR(100)    NOT NULL,
    agent_phone     VARCHAR(20)     NOT NULL,
    agent_email     VARCHAR(100)    NOT NULL,

    -- Indexes for common search patterns
    INDEX idx_category          (category),
    INDEX idx_category_status   (category, status),
    INDEX idx_city_state        (city, state),
    INDEX idx_zip_code          (zip_code),
    INDEX idx_price             (price),
    INDEX idx_bedrooms          (bedrooms),
    INDEX idx_square_feet       (square_feet),
    INDEX idx_property_type     (property_type),
    INDEX idx_listed_date       (listed_date)
);

-- -------------------------------------------------------
-- Sample Data: Residential Rentals
-- -------------------------------------------------------
INSERT INTO properties (category, property_type, title, description, address, city, state, zip_code,
    price, price_unit, square_feet, bedrooms, bathrooms, parking_spaces, pets_allowed, furnished, status, listed_date,
    agent_name, agent_phone, agent_email)
VALUES
('RESIDENTIAL_RENTAL', 'Apartment', 'Modern 2BR Apartment in Downtown Austin', 
    'Bright and spacious 2-bedroom apartment with city views, in-unit laundry, and rooftop access.',
    '123 Congress Ave', 'Austin', 'TX', '78701', 2200.00, 'USD/month', 950.00, 2, 2, 1, TRUE, FALSE, 'ACTIVE', '2026-08-01',
    'Sarah Johnson', '512-555-0101', 'sarah.johnson@realty.com'),

('RESIDENTIAL_RENTAL', 'House', 'Spacious 4BR Family Home in Suburbs', 
    'Large family home with backyard, 2-car garage, and excellent school district.',
    '456 Oak Lane', 'Houston', 'TX', '77001', 3500.00, 'USD/month', 2400.00, 4, 3, 2, TRUE, FALSE, 'ACTIVE', '2026-08-10',
    'Mike Davis', '713-555-0202', 'mike.davis@realty.com'),

('RESIDENTIAL_RENTAL', 'Studio', 'Cozy Studio in Manhattan Financial District', 
    'Fully furnished studio with high-speed internet, gym access, and doorman service.',
    '789 Wall St', 'New York', 'NY', '10005', 3200.00, 'USD/month', 450.00, 0, 1, 0, FALSE, TRUE, 'ACTIVE', '2026-08-15',
    'Emily Chen', '212-555-0303', 'emily.chen@realty.com'),

('RESIDENTIAL_RENTAL', 'Condo', 'Luxury Condo with Ocean View in Miami Beach', 
    'Stunning ocean-view condo with resort-style amenities, pool, and concierge.',
    '321 Ocean Dr', 'Miami', 'FL', '33139', 4500.00, 'USD/month', 1200.00, 2, 2, 1, FALSE, TRUE, 'ACTIVE', '2026-09-01',
    'Carlos Rivera', '305-555-0404', 'carlos.rivera@realty.com'),

('RESIDENTIAL_RENTAL', 'Townhouse', 'Pet-Friendly Townhouse in Seattle', 
    'Three-story townhouse with private patio, modern kitchen, and attached garage.',
    '654 Pine St', 'Seattle', 'WA', '98101', 3800.00, 'USD/month', 1800.00, 3, 2, 1, TRUE, FALSE, 'ACTIVE', '2026-09-05',
    'Linda Park', '206-555-0505', 'linda.park@realty.com'),

-- -------------------------------------------------------
-- Sample Data: Residential Sales
-- -------------------------------------------------------
('RESIDENTIAL_SALE', 'Single-Family', 'Charming 3BR Ranch Home in Phoenix', 
    'Well-maintained ranch-style home with updated kitchen, pool, and desert landscaping.',
    '100 Cactus Rd', 'Phoenix', 'AZ', '85001', 425000.00, 'USD', 1750.00, 3, 2, 2, FALSE, FALSE, 'ACTIVE', '2026-07-20',
    'Tom Wilson', '602-555-0606', 'tom.wilson@realty.com'),

('RESIDENTIAL_SALE', 'Condo', 'Downtown Chicago High-Rise Condo', 
    'Stunning 22nd-floor condo with panoramic lake views, floor-to-ceiling windows, and premium finishes.',
    '200 N Michigan Ave', 'Chicago', 'IL', '60601', 750000.00, 'USD', 1400.00, 2, 2, 1, FALSE, FALSE, 'ACTIVE', '2026-08-05',
    'Rachel Green', '312-555-0707', 'rachel.green@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'Luxury Estate in Beverly Hills', 
    'Magnificent 6-bedroom estate with home theater, wine cellar, infinity pool, and guest house.',
    '500 Sunset Blvd', 'Los Angeles', 'CA', '90210', 4500000.00, 'USD', 7500.00, 6, 7, 4, FALSE, FALSE, 'ACTIVE', '2026-08-20',
    'James Hartley', '310-555-0808', 'james.hartley@realty.com'),

('RESIDENTIAL_SALE', 'Townhouse', 'Modern Townhouse in Denver Tech Center', 
    'Contemporary 3-story townhouse with rooftop deck, smart home features, and mountain views.',
    '300 Tech Blvd', 'Denver', 'CO', '80202', 620000.00, 'USD', 2100.00, 3, 3, 2, FALSE, FALSE, 'ACTIVE', '2026-09-01',
    'Anna Martinez', '720-555-0909', 'anna.martinez@realty.com'),

('RESIDENTIAL_SALE', 'Multi-Family', 'Investment Duplex in Nashville', 
    'Income-producing duplex with two 2BR units, fully rented, great cap rate.',
    '400 Music Row', 'Nashville', 'TN', '37203', 550000.00, 'USD', 2800.00, 4, 4, 2, FALSE, FALSE, 'ACTIVE', '2026-09-10',
    'Bob Thompson', '615-555-1010', 'bob.thompson@realty.com'),

-- -------------------------------------------------------
-- Sample Data: Business Properties
-- -------------------------------------------------------
('BUSINESS', 'Office', 'Class A Office Space in San Francisco Financial District', 
    'Premium office space with panoramic bay views, conference rooms, and 24/7 security.',
    '101 Market St', 'San Francisco', 'CA', '94105', 12000.00, 'USD/month', 3500.00, NULL, NULL, 10, FALSE, FALSE, 'ACTIVE', '2026-07-15',
    'David Kim', '415-555-1111', 'david.kim@commercial.com'),

('BUSINESS', 'Retail', 'High-Traffic Retail Space on 5th Avenue', 
    'Prime retail location with floor-to-ceiling windows, high foot traffic, and loading dock.',
    '500 5th Ave', 'New York', 'NY', '10110', 25000.00, 'USD/month', 2000.00, NULL, NULL, 0, FALSE, FALSE, 'ACTIVE', '2026-08-01',
    'Susan Lee', '212-555-1212', 'susan.lee@commercial.com'),

('BUSINESS', 'Warehouse', 'Industrial Warehouse in Dallas Logistics Hub', 
    '30,000 sqft warehouse with 20ft ceilings, 4 loading docks, and rail access.',
    '700 Industrial Pkwy', 'Dallas', 'TX', '75201', 18000.00, 'USD/month', 30000.00, NULL, NULL, 20, FALSE, FALSE, 'ACTIVE', '2026-08-15',
    'Frank Brown', '214-555-1313', 'frank.brown@commercial.com'),

('BUSINESS', 'Restaurant', 'Turnkey Restaurant Space in Chicago River North', 
    'Fully equipped restaurant with commercial kitchen, bar area, and outdoor patio seating for 120.',
    '800 N Clark St', 'Chicago', 'IL', '60610', 9500.00, 'USD/month', 3200.00, NULL, NULL, 5, FALSE, FALSE, 'ACTIVE', '2026-09-01',
    'Maria Santos', '312-555-1414', 'maria.santos@commercial.com'),

('BUSINESS', 'Mixed-Use', 'Mixed-Use Building in Portland Pearl District', 
    'Ground-floor retail with 3 residential units above. Excellent investment opportunity.',
    '900 NW 23rd Ave', 'Portland', 'OR', '97210', 8500.00, 'USD/month', 5000.00, NULL, NULL, 8, FALSE, FALSE, 'ACTIVE', '2026-09-15',
    'Chris Taylor', '503-555-1515', 'chris.taylor@commercial.com'),

-- -------------------------------------------------------
-- Additional Sample Data: Residential Rentals
-- -------------------------------------------------------
('RESIDENTIAL_RENTAL', 'Apartment', 'Cozy 1BR Apartment Near Boston University',
    'Charming 1-bedroom apartment steps from campus, hardwood floors, updated kitchen, and on-site laundry.',
    '22 Commonwealth Ave', 'Boston', 'MA', '02215', 2800.00, 'USD/month', 680.00, 1, 1, 0, FALSE, FALSE, 'ACTIVE', '2026-09-10',
    'Patricia Walsh', '617-555-1601', 'patricia.walsh@realty.com'),

('RESIDENTIAL_RENTAL', 'House', 'Charming Craftsman Home in Portland',
    'Beautifully restored 3-bedroom craftsman with original hardwood floors, large backyard, and detached garage.',
    '310 SE Hawthorne Blvd', 'Portland', 'OR', '97214', 3200.00, 'USD/month', 1650.00, 3, 2, 1, TRUE, FALSE, 'ACTIVE', '2026-09-12',
    'Nathan Brooks', '503-555-1602', 'nathan.brooks@realty.com'),

('RESIDENTIAL_RENTAL', 'Apartment', 'High-Rise Studio in Las Vegas Strip Area',
    'Modern studio with floor-to-ceiling windows, resort-style pool, and 24-hour concierge.',
    '3700 S Las Vegas Blvd', 'Las Vegas', 'NV', '89109', 1800.00, 'USD/month', 520.00, 0, 1, 1, FALSE, TRUE, 'ACTIVE', '2026-09-08',
    'Donna Reyes', '702-555-1603', 'donna.reyes@realty.com'),

('RESIDENTIAL_RENTAL', 'Condo', 'Upscale 2BR Condo in Atlanta Midtown',
    'Sleek condo with open floor plan, chef kitchen, private balcony, and access to rooftop terrace.',
    '1010 Peachtree St NE', 'Atlanta', 'GA', '30309', 2900.00, 'USD/month', 1100.00, 2, 2, 1, FALSE, FALSE, 'ACTIVE', '2026-09-15',
    'Marcus Hill', '404-555-1604', 'marcus.hill@realty.com'),

('RESIDENTIAL_RENTAL', 'House', 'Sunny 3BR Bungalow in San Diego Mission Hills',
    'Bright bungalow with updated bathrooms, wraparound porch, and walking distance to shops and cafes.',
    '4520 Goldfinch St', 'San Diego', 'CA', '92103', 4200.00, 'USD/month', 1400.00, 3, 2, 1, TRUE, FALSE, 'ACTIVE', '2026-09-18',
    'Olivia Grant', '619-555-1605', 'olivia.grant@realty.com'),

-- -------------------------------------------------------
-- Additional Sample Data: Residential Sales
-- -------------------------------------------------------
('RESIDENTIAL_SALE', 'Single-Family', 'Renovated Colonial in Raleigh North Hills',
    'Fully renovated 4-bedroom colonial with open-concept kitchen, new roof, and large fenced backyard.',
    '215 Lassiter Mill Rd', 'Raleigh', 'NC', '27609', 580000.00, 'USD', 2600.00, 4, 3, 2, FALSE, FALSE, 'ACTIVE', '2026-08-28',
    'Jennifer Cole', '919-555-1701', 'jennifer.cole@realty.com'),

('RESIDENTIAL_SALE', 'Condo', 'Waterfront Condo in San Diego Marina District',
    'Stunning marina-view condo with private boat slip, gourmet kitchen, and resort amenities.',
    '1800 Harbor Island Dr', 'San Diego', 'CA', '92101', 1250000.00, 'USD', 1800.00, 2, 2, 2, FALSE, FALSE, 'ACTIVE', '2026-09-02',
    'Steven Nguyen', '619-555-1702', 'steven.nguyen@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'New Construction Home in Austin Round Rock',
    'Brand-new 5-bedroom home with smart home technology, energy-efficient design, and community pool.',
    '900 Sunrise Rd', 'Round Rock', 'TX', '78664', 695000.00, 'USD', 3200.00, 5, 4, 3, FALSE, FALSE, 'ACTIVE', '2026-09-05',
    'Laura Simmons', '512-555-1703', 'laura.simmons@realty.com'),

('RESIDENTIAL_SALE', 'Land', 'Buildable Lot in Scottsdale Desert Highlands',
    '1.2-acre flat lot with mountain views, utilities at street, and approved building plans available.',
    '8900 E Pinnacle Peak Rd', 'Scottsdale', 'AZ', '85255', 320000.00, 'USD', 52272.00, NULL, NULL, NULL, FALSE, FALSE, 'ACTIVE', '2026-09-08',
    'Derek Stone', '480-555-1704', 'derek.stone@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'Historic Victorian in San Francisco Painted Ladies Row',
    'Meticulously restored Victorian with original details, modern systems, and panoramic park views.',
    '712 Steiner St', 'San Francisco', 'CA', '94117', 3200000.00, 'USD', 2900.00, 4, 3, 1, FALSE, FALSE, 'ACTIVE', '2026-09-12',
    'Heather Flynn', '415-555-1705', 'heather.flynn@realty.com'),

('RESIDENTIAL_SALE', 'Townhouse', 'Luxury Townhouse in Washington DC Capitol Hill',
    'Elegant 3-level townhouse with rooftop terrace, private courtyard, and walking distance to the Capitol.',
    '320 A St SE', 'Washington', 'DC', '20003', 1100000.00, 'USD', 2400.00, 3, 3, 1, FALSE, FALSE, 'ACTIVE', '2026-09-14',
    'Gregory Adams', '202-555-1706', 'gregory.adams@realty.com'),

-- -------------------------------------------------------
-- Additional Sample Data: Business Properties
-- -------------------------------------------------------
('BUSINESS', 'Office', 'Creative Coworking Office in Austin Domain',
    'Flexible open-plan office with private suites, high-speed fiber, podcast studio, and rooftop lounge.',
    '11601 Domain Dr', 'Austin', 'TX', '78758', 7500.00, 'USD/month', 4200.00, NULL, NULL, 15, FALSE, FALSE, 'ACTIVE', '2026-08-20',
    'Tiffany Moore', '512-555-1801', 'tiffany.moore@commercial.com'),

('BUSINESS', 'Retail', 'Corner Retail Unit in Miami Wynwood Arts District',
    'High-visibility corner unit with 20ft ceilings, polished concrete floors, and heavy foot traffic from art walks.',
    '2750 NW 3rd Ave', 'Miami', 'FL', '33127', 6800.00, 'USD/month', 1800.00, NULL, NULL, 2, FALSE, FALSE, 'ACTIVE', '2026-08-25',
    'Alejandro Vega', '305-555-1802', 'alejandro.vega@commercial.com'),

('BUSINESS', 'Industrial', 'Manufacturing Facility in Detroit Industrial Corridor',
    '50,000 sqft manufacturing plant with 3-phase power, 30ft ceilings, 6 dock doors, and rail spur.',
    '4400 E Jefferson Ave', 'Detroit', 'MI', '48207', 32000.00, 'USD/month', 50000.00, NULL, NULL, 40, FALSE, FALSE, 'ACTIVE', '2026-09-01',
    'Raymond Clark', '313-555-1803', 'raymond.clark@commercial.com'),

('BUSINESS', 'Office', 'Boutique Office Suite in Boston Back Bay',
    'Fully furnished 8-person office suite in a historic brownstone with fiber internet and shared conference room.',
    '200 Newbury St', 'Boston', 'MA', '02116', 5500.00, 'USD/month', 1200.00, NULL, NULL, 4, FALSE, TRUE, 'ACTIVE', '2026-09-05',
    'Samantha Price', '617-555-1804', 'samantha.price@commercial.com'),

('BUSINESS', 'Warehouse', 'Last-Mile Distribution Center in Phoenix Mesa',
    'Modern 15,000 sqft distribution warehouse with ESFR sprinklers, 24/7 access, and freeway proximity.',
    '1550 S Alma School Rd', 'Mesa', 'AZ', '85210', 11000.00, 'USD/month', 15000.00, NULL, NULL, 12, FALSE, FALSE, 'ACTIVE', '2026-09-10',
    'Victor Huang', '480-555-1805', 'victor.huang@commercial.com'),

('BUSINESS', 'Restaurant', 'Ghost Kitchen Space in Los Angeles Culver City',
    'Fully licensed commercial kitchen with 4 dedicated cooking stations, walk-in cooler, and delivery staging area.',
    '9000 Washington Blvd', 'Los Angeles', 'CA', '90232', 4200.00, 'USD/month', 1500.00, NULL, NULL, 6, FALSE, FALSE, 'ACTIVE', '2026-09-13',
    'Priya Nair', '310-555-1806', 'priya.nair@commercial.com'),

-- -------------------------------------------------------
-- Batch 3: 30 Additional Listings
-- -------------------------------------------------------

-- Residential Rentals (12)
('RESIDENTIAL_RENTAL', 'Apartment', 'Bright 2BR Apartment in Minneapolis Uptown',
    'Sun-filled apartment with exposed brick, stainless appliances, rooftop deck, and bike storage.',
    '2901 Hennepin Ave', 'Minneapolis', 'MN', '55408', 1950.00, 'USD/month', 900.00, 2, 1, 1, TRUE, FALSE, 'ACTIVE', '2026-09-01',
    'Allison Burke', '612-555-2001', 'allison.burke@realty.com'),

('RESIDENTIAL_RENTAL', 'House', 'Spacious 5BR Home in Charlotte Ballantyne',
    'Executive rental home with gourmet kitchen, home office, 3-car garage, and community pool access.',
    '14200 Ballantyne Corporate Pl', 'Charlotte', 'NC', '28277', 4800.00, 'USD/month', 3500.00, 5, 4, 3, FALSE, FALSE, 'ACTIVE', '2026-09-03',
    'Kevin Marsh', '704-555-2002', 'kevin.marsh@realty.com'),

('RESIDENTIAL_RENTAL', 'Studio', 'Modern Studio in Denver LoDo District',
    'Industrial-chic studio with polished concrete floors, Juliet balcony, and walkable to Union Station.',
    '1600 Little Raven St', 'Denver', 'CO', '80202', 1700.00, 'USD/month', 480.00, 0, 1, 0, FALSE, TRUE, 'ACTIVE', '2026-09-04',
    'Cassandra Fox', '720-555-2003', 'cassandra.fox@realty.com'),

('RESIDENTIAL_RENTAL', 'Condo', 'Luxury 3BR Condo in Honolulu Waikiki',
    'Oceanfront condo with lanai, resort pool, concierge, and stunning Diamond Head views.',
    '2500 Kalakaua Ave', 'Honolulu', 'HI', '96815', 6500.00, 'USD/month', 1600.00, 3, 2, 1, FALSE, TRUE, 'ACTIVE', '2026-09-06',
    'Leilani Kahale', '808-555-2004', 'leilani.kahale@realty.com'),

('RESIDENTIAL_RENTAL', 'Townhouse', 'Contemporary Townhouse in Nashville Germantown',
    'Three-level townhouse with chef kitchen, private rooftop, and steps from top restaurants.',
    '1100 4th Ave N', 'Nashville', 'TN', '37208', 3600.00, 'USD/month', 2000.00, 3, 3, 1, FALSE, FALSE, 'ACTIVE', '2026-09-07',
    'Tyler Ross', '615-555-2005', 'tyler.ross@realty.com'),

('RESIDENTIAL_RENTAL', 'Apartment', 'Affordable 1BR in Philadelphia Fishtown',
    'Renovated 1-bedroom with exposed brick, updated bath, and easy access to SEPTA.',
    '1400 Frankford Ave', 'Philadelphia', 'PA', '19125', 1600.00, 'USD/month', 720.00, 1, 1, 0, TRUE, FALSE, 'ACTIVE', '2026-09-09',
    'Monica Shaw', '215-555-2006', 'monica.shaw@realty.com'),

('RESIDENTIAL_RENTAL', 'House', 'Pet-Friendly Ranch Home in Tucson Foothills',
    'Single-story ranch with large fenced yard, covered patio, and mountain views. Dogs welcome.',
    '5800 N Kolb Rd', 'Tucson', 'AZ', '85750', 2400.00, 'USD/month', 1900.00, 3, 2, 2, TRUE, FALSE, 'ACTIVE', '2026-09-11',
    'Brenda Ortiz', '520-555-2007', 'brenda.ortiz@realty.com'),

('RESIDENTIAL_RENTAL', 'Apartment', 'Upscale 2BR in Chicago Gold Coast',
    'Elegant apartment with lake views, doorman, fitness center, and valet parking.',
    '1000 N Lake Shore Dr', 'Chicago', 'IL', '60611', 4200.00, 'USD/month', 1300.00, 2, 2, 1, FALSE, FALSE, 'ACTIVE', '2026-09-13',
    'Jonathan Pierce', '312-555-2008', 'jonathan.pierce@realty.com'),

('RESIDENTIAL_RENTAL', 'Condo', 'Waterfront Condo in Baltimore Inner Harbor',
    'Stunning harbor-view condo with private balcony, marina access, and modern finishes.',
    '100 Harborview Dr', 'Baltimore', 'MD', '21230', 2700.00, 'USD/month', 1050.00, 2, 2, 1, FALSE, FALSE, 'ACTIVE', '2026-09-14',
    'Diane Foster', '410-555-2009', 'diane.foster@realty.com'),

('RESIDENTIAL_RENTAL', 'Studio', 'Furnished Studio in San Jose Downtown',
    'Fully furnished studio ideal for tech professionals, with co-working lounge and rooftop terrace.',
    '200 S Market St', 'San Jose', 'CA', '95113', 2500.00, 'USD/month', 510.00, 0, 1, 1, FALSE, TRUE, 'ACTIVE', '2026-09-16',
    'Raj Patel', '408-555-2010', 'raj.patel@realty.com'),

('RESIDENTIAL_RENTAL', 'House', 'Family Home in Columbus Dublin Suburb',
    'Well-maintained 4-bedroom home in top-rated school district with finished basement and large deck.',
    '6200 Avery Rd', 'Dublin', 'OH', '43016', 2900.00, 'USD/month', 2800.00, 4, 3, 2, TRUE, FALSE, 'ACTIVE', '2026-09-17',
    'Sandra Kelley', '614-555-2011', 'sandra.kelley@realty.com'),

('RESIDENTIAL_RENTAL', 'Apartment', 'Trendy 1BR in Brooklyn Williamsburg',
    'Hip loft-style apartment with 12ft ceilings, exposed ductwork, and rooftop access in vibrant neighborhood.',
    '175 Bedford Ave', 'Brooklyn', 'NY', '11211', 3400.00, 'USD/month', 780.00, 1, 1, 0, FALSE, FALSE, 'ACTIVE', '2026-09-19',
    'Zoe Chambers', '718-555-2012', 'zoe.chambers@realty.com'),

-- Residential Sales (10)
('RESIDENTIAL_SALE', 'Single-Family', 'Elegant 4BR Home in Atlanta Buckhead',
    'Stunning traditional home with chef kitchen, formal dining, screened porch, and resort-style pool.',
    '3200 Peachtree Rd NE', 'Atlanta', 'GA', '30305', 1450000.00, 'USD', 4200.00, 4, 4, 3, FALSE, FALSE, 'ACTIVE', '2026-08-22',
    'Courtney Bell', '404-555-2101', 'courtney.bell@realty.com'),

('RESIDENTIAL_SALE', 'Condo', 'Penthouse Condo in Las Vegas High-Rise',
    'Spectacular penthouse with panoramic Strip views, private terrace, smart home system, and 2 parking spots.',
    '4381 W Flamingo Rd', 'Las Vegas', 'NV', '89103', 980000.00, 'USD', 2200.00, 3, 3, 2, FALSE, FALSE, 'ACTIVE', '2026-08-30',
    'Brandon Cruz', '702-555-2102', 'brandon.cruz@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'New Build in Houston Sugar Land',
    'Energy Star certified 4-bedroom new construction with open floor plan, solar panels, and EV charger.',
    '3500 Sweetwater Blvd', 'Sugar Land', 'TX', '77479', 520000.00, 'USD', 2900.00, 4, 3, 2, FALSE, FALSE, 'ACTIVE', '2026-09-03',
    'Melissa Tran', '281-555-2103', 'melissa.tran@realty.com'),

('RESIDENTIAL_SALE', 'Townhouse', 'Luxury Townhouse in Seattle Capitol Hill',
    'Modern 4-story townhouse with rooftop deck, 2-car garage, and designer finishes throughout.',
    '1500 E Pine St', 'Seattle', 'WA', '98122', 1100000.00, 'USD', 2600.00, 3, 3, 2, FALSE, FALSE, 'ACTIVE', '2026-09-06',
    'Andrew Kim', '206-555-2104', 'andrew.kim@realty.com'),

('RESIDENTIAL_SALE', 'Multi-Family', 'Triplex Investment in Kansas City Midtown',
    'Fully occupied triplex with three 2BR units, updated mechanicals, and strong rental history.',
    '3900 Main St', 'Kansas City', 'MO', '64111', 480000.00, 'USD', 4200.00, 6, 3, 3, FALSE, FALSE, 'ACTIVE', '2026-09-08',
    'Patricia Long', '816-555-2105', 'patricia.long@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'Waterfront Home in Tampa Bay Shores',
    'Stunning waterfront property with private dock, boat lift, heated pool, and panoramic bay views.',
    '4800 Bayshore Blvd', 'Tampa', 'FL', '33611', 2200000.00, 'USD', 3800.00, 4, 4, 3, FALSE, FALSE, 'ACTIVE', '2026-09-10',
    'George Russo', '813-555-2106', 'george.russo@realty.com'),

('RESIDENTIAL_SALE', 'Condo', 'Ski-In/Ski-Out Condo in Denver Mountain Village',
    'Rare ski-in/ski-out condo with slope views, stone fireplace, and access to world-class amenities.',
    '100 Vail Rd', 'Vail', 'CO', '81657', 1750000.00, 'USD', 1900.00, 3, 3, 1, FALSE, FALSE, 'ACTIVE', '2026-09-11',
    'Stephanie Ward', '970-555-2107', 'stephanie.ward@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'Craftsman Bungalow in Portland Sellwood',
    'Lovingly maintained 1920s bungalow with original built-ins, updated systems, and lush garden.',
    '7800 SE 13th Ave', 'Portland', 'OR', '97202', 650000.00, 'USD', 1550.00, 3, 2, 1, FALSE, FALSE, 'ACTIVE', '2026-09-13',
    'Hannah Scott', '503-555-2108', 'hannah.scott@realty.com'),

('RESIDENTIAL_SALE', 'Land', 'Lakefront Lot in Lake Tahoe South Shore',
    '0.8-acre lakefront lot with 80ft of private beach, utilities stubbed, and approved septic design.',
    '1200 Lakeview Ave', 'South Lake Tahoe', 'CA', '96150', 1900000.00, 'USD', 34848.00, NULL, NULL, NULL, FALSE, FALSE, 'ACTIVE', '2026-09-15',
    'Douglas Fir', '530-555-2109', 'douglas.fir@realty.com'),

('RESIDENTIAL_SALE', 'Single-Family', 'Gated Estate in Scottsdale Paradise Valley',
    'Magnificent 7-bedroom estate on 2 acres with tennis court, guest casita, and resort pool.',
    '6000 E Lincoln Dr', 'Paradise Valley', 'AZ', '85253', 6500000.00, 'USD', 9800.00, 7, 8, 6, FALSE, FALSE, 'ACTIVE', '2026-09-17',
    'Victoria Stone', '480-555-2110', 'victoria.stone@realty.com'),

-- Business Properties (8)
('BUSINESS', 'Office', 'Tech Campus Office in Seattle Bellevue',
    'Modern open-plan office with collaboration zones, server room, cafeteria, and on-site gym.',
    '10900 NE 8th St', 'Bellevue', 'WA', '98004', 22000.00, 'USD/month', 8000.00, NULL, NULL, 30, FALSE, FALSE, 'ACTIVE', '2026-08-18',
    'Eric Johansson', '425-555-2201', 'eric.johansson@commercial.com'),

('BUSINESS', 'Retail', 'Flagship Retail Space in Denver 16th Street Mall',
    'Prime pedestrian mall location with 25ft ceilings, full glass facade, and 2,500 daily foot traffic.',
    '500 16th St Mall', 'Denver', 'CO', '80202', 14000.00, 'USD/month', 3800.00, NULL, NULL, 0, FALSE, FALSE, 'ACTIVE', '2026-08-22',
    'Natalie Burns', '720-555-2202', 'natalie.burns@commercial.com'),

('BUSINESS', 'Warehouse', 'Cold Storage Facility in Minneapolis Produce District',
    '8,000 sqft refrigerated warehouse with -10°F freezer section, dock levelers, and 3-phase power.',
    '2800 University Ave SE', 'Minneapolis', 'MN', '55414', 9500.00, 'USD/month', 8000.00, NULL, NULL, 8, FALSE, FALSE, 'ACTIVE', '2026-08-28',
    'Carl Jensen', '612-555-2203', 'carl.jensen@commercial.com'),

('BUSINESS', 'Office', 'Medical Office Suite in Houston Medical Center',
    'Purpose-built medical office with exam rooms, waiting area, ADA compliance, and ample parking.',
    '6550 Bertner Ave', 'Houston', 'TX', '77030', 8500.00, 'USD/month', 2800.00, NULL, NULL, 20, FALSE, FALSE, 'ACTIVE', '2026-09-02',
    'Dr. Angela Wu', '713-555-2204', 'angela.wu@commercial.com'),

('BUSINESS', 'Industrial', 'Flex Industrial Space in Phoenix Deer Valley',
    '12,000 sqft flex space with 18ft clear height, 2 grade-level doors, and 400A electrical service.',
    '2020 W Deer Valley Rd', 'Phoenix', 'AZ', '85027', 8800.00, 'USD/month', 12000.00, NULL, NULL, 15, FALSE, FALSE, 'ACTIVE', '2026-09-04',
    'Todd Larson', '602-555-2205', 'todd.larson@commercial.com'),

('BUSINESS', 'Restaurant', 'Full-Service Restaurant in New Orleans French Quarter',
    'Iconic French Quarter location with full liquor license, 80-seat dining room, and courtyard patio.',
    '800 Bourbon St', 'New Orleans', 'LA', '70116', 11000.00, 'USD/month', 4500.00, NULL, NULL, 10, FALSE, FALSE, 'ACTIVE', '2026-09-07',
    'Celeste Dupont', '504-555-2206', 'celeste.dupont@commercial.com'),

('BUSINESS', 'Mixed-Use', 'Mixed-Use Development in Nashville East Nashville',
    'Newly built mixed-use with 4,000 sqft ground-floor retail and 6 residential units above.',
    '1200 Gallatin Ave', 'Nashville', 'TN', '37206', 16000.00, 'USD/month', 9500.00, NULL, NULL, 12, FALSE, FALSE, 'ACTIVE', '2026-09-09',
    'Amber Collins', '615-555-2207', 'amber.collins@commercial.com'),

('BUSINESS', 'Retail', 'Strip Mall End-Cap in Orlando International Drive',
    'High-visibility end-cap unit near theme parks with drive-through potential and pylon signage.',
    '8000 International Dr', 'Orlando', 'FL', '32819', 7200.00, 'USD/month', 2200.00, NULL, NULL, 25, FALSE, FALSE, 'ACTIVE', '2026-09-12',
    'Ryan Castillo', '407-555-2208', 'ryan.castillo@commercial.com');
