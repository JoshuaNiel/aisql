-- People (20)
INSERT INTO Person (id, firstname, lastname, email, phoneNumber, ssn) VALUES
(1,  'Alice',   'Nguyen',    'alice.nguyen@email.com',    '555-0101', '123-45-6789'),
(2,  'Ben',     'Carter',    'ben.carter@email.com',      '555-0102', '234-56-7890'),
(3,  'Clara',   'Moss',      'clara.moss@email.com',      '555-0103', '345-67-8901'),
(4,  'David',   'Kim',       'david.kim@email.com',       '555-0104', '456-78-9012'),
(5,  'Emma',    'Patel',     'emma.patel@email.com',      '555-0105', '567-89-0123'),
(6,  'Frank',   'Lopez',     'frank.lopez@email.com',     '555-0106', '678-90-1234'),
(7,  'Grace',   'Hall',      'grace.hall@email.com',      '555-0107', '789-01-2345'),
(8,  'Henry',   'Brooks',    'henry.brooks@email.com',    '555-0108', '890-12-3456'),
(9,  'Isla',    'Warren',    'isla.warren@email.com',     '555-0109', '901-23-4567'),
(10, 'James',   'Reed',      'james.reed@email.com',      '555-0110', '012-34-5678'),
(11, 'Karen',   'Foster',    'karen.foster@email.com',    '555-0111', '111-22-3333'),
(12, 'Liam',    'Price',     'liam.price@email.com',      '555-0112', '222-33-4444'),
(13, 'Mia',     'Griffin',   'mia.griffin@email.com',     '555-0113', '333-44-5555'),
(14, 'Noah',    'Barnes',    'noah.barnes@email.com',     '555-0114', '444-55-6666'),
(15, 'Olivia',  'Jenkins',   'olivia.jenkins@email.com',  '555-0115', '555-66-7777'),
(16, 'Paul',    'Ross',      'paul.ross@email.com',       '555-0116', '666-77-8888'),
(17, 'Quinn',   'Sanders',   'quinn.sanders@email.com',   '555-0117', '777-88-9999'),
(18, 'Rachel',  'Morris',    'rachel.morris@email.com',   '555-0118', '888-99-0000'),
(19, 'Sam',     'Watson',    'sam.watson@email.com',      '555-0119', '999-00-1111'),
(20, 'Tina',    'Howard',    'tina.howard@email.com',     '555-0120', '100-11-2222');

-- Companies (8)
INSERT INTO Company (id, companyName, isHiring) VALUES
(1, 'TechNova Inc.',       1),
(2, 'BlueSky Solutions',   1),
(3, 'DataBridge Corp.',    0),
(4, 'Zenith Software',     1),
(5, 'PinnacleTech',        1),
(6, 'Orbit Systems',       1),
(7, 'Ironclad Analytics',  0),
(8, 'CloudForge Ltd.',     1);

-- Addresses (8)
INSERT INTO Address (id, street, city, state, zip) VALUES
(1, '100 Innovation Drive',  'San Francisco', 'CA', '94105'),
(2, '200 Enterprise Blvd',   'Austin',        'TX', '78701'),
(3, '300 Tech Park Ave',     'Seattle',       'WA', '98101'),
(4, '400 Startup Lane',      'New York',      'NY', '10001'),
(5, '500 Venture Circle',    'Denver',        'CO', '80202'),
(6, '600 Silicon Pkwy',      'Boston',        'MA', '02101'),
(7, '700 Data Center Rd',    'Chicago',       'IL', '60601'),
(8, '800 Cloud Campus',      'Portland',      'OR', '97201');

-- Job Listings (14)
INSERT INTO JobListing (id, companyId, salaryMin, salaryMax, isActive, workType, locationId) VALUES
(1,  1, 100000, 140000, 1, 'remote',  1),
(2,  1,  80000, 110000, 1, 'hybrid',  1),
(3,  2,  90000, 120000, 1, 'onsite',  2),
(4,  4, 110000, 150000, 1, 'remote',  3),
(5,  4,  70000,  95000, 0, 'onsite',  3),
(6,  5, 120000, 160000, 1, 'remote',  4),
(7,  5,  85000, 115000, 1, 'hybrid',  4),
(8,  6,  95000, 130000, 1, 'onsite',  5),
(9,  6,  75000, 100000, 1, 'hybrid',  5),
(10, 8, 105000, 145000, 1, 'remote',  6),
(11, 8,  88000, 118000, 1, 'onsite',  6),
(12, 2,  78000, 105000, 0, 'onsite',  2),
(13, 1,  60000,  85000, 1, 'hybrid',  1),
(14, 4, 130000, 175000, 1, 'remote',  8);

-- Requirements (14)
INSERT INTO Requirement (id, description) VALUES
(1,  'Proficiency in Python'),
(2,  'Experience with SQL databases'),
(3,  'Knowledge of REST APIs'),
(4,  'Familiarity with cloud platforms (AWS/GCP/Azure)'),
(5,  'Communication and teamwork skills'),
(6,  'Bachelor degree in Computer Science or related field'),
(7,  'Experience with React or Vue.js'),
(8,  'Machine learning or data science background'),
(9,  'Experience with Docker and Kubernetes'),
(10, 'Strong understanding of data structures and algorithms'),
(11, 'Experience with agile/scrum methodologies'),
(12, 'Proficiency in Java or C++'),
(13, 'Cybersecurity knowledge'),
(14, 'Technical writing and documentation skills');

-- Job Requirements
INSERT INTO JobRequirement (listingId, requirementId, isMandatory) VALUES
-- Listing 1: Senior Data Engineer (TechNova)
(1,  1,  1), (1,  2,  1), (1,  4,  0), (1,  9,  0),
-- Listing 2: Frontend Developer (TechNova)
(2,  7,  1), (2,  5,  1), (2,  3,  0),
-- Listing 3: Backend Developer (BlueSky)
(3,  2,  1), (3,  3,  1), (3,  6,  0), (3, 11,  0),
-- Listing 4: ML Engineer (Zenith)
(4,  1,  1), (4,  8,  1), (4,  4,  1),
-- Listing 5: IT Support (Zenith, inactive)
(5,  5,  0), (5,  6,  1),
-- Listing 6: Principal Engineer (PinnacleTech)
(6, 10,  1), (6, 12,  1), (6,  9,  1), (6,  4,  0),
-- Listing 7: Product Manager (PinnacleTech)
(7,  5,  1), (7, 11,  1), (7, 14,  0),
-- Listing 8: DevOps Engineer (Orbit)
(8,  9,  1), (8,  4,  1), (8,  2,  0),
-- Listing 9: QA Engineer (Orbit)
(9,  3,  1), (9,  5,  1), (9, 11,  0),
-- Listing 10: Cloud Architect (CloudForge)
(10,  4,  1), (10,  9,  1), (10, 10,  1), (10,  6,  0),
-- Listing 11: Security Analyst (CloudForge)
(11, 13,  1), (11,  2,  0), (11,  6,  1),
-- Listing 13: Junior Developer (TechNova)
(13,  1,  0), (13,  5,  1), (13,  6,  0),
-- Listing 14: Staff Engineer (Zenith)
(14, 10,  1), (14, 12,  1), (14,  4,  1), (14,  9,  0);

-- Job Applications (30)
INSERT INTO JobApplication (id, personId, companyId, listingId, status) VALUES
(1,  1,  1,  1,  'offered'),
(2,  2,  1,  1,  'interviewing'),
(3,  3,  2,  3,  'rejected'),
(4,  4,  4,  4,  'offered'),
(5,  5,  1,  2,  'interviewing'),
(6,  6,  2,  3,  'pending'),
(7,  1,  4,  4,  'rejected'),
(8,  3,  4,  4,  'interviewing'),
(9,  7,  5,  6,  'offered'),
(10, 8,  5,  7,  'interviewing'),
(11, 9,  6,  8,  'offered'),
(12, 10, 6,  9,  'rejected'),
(13, 11, 8, 10,  'interviewing'),
(14, 12, 8, 11,  'offered'),
(15, 13, 1, 13,  'pending'),
(16, 14, 4, 14,  'offered'),
(17, 15, 5,  7,  'rejected'),
(18, 16, 6,  8,  'interviewing'),
(19, 17, 8, 10,  'pending'),
(20, 18, 1,  2,  'offered'),
(21, 19, 5,  6,  'interviewing'),
(22, 20, 4,  4,  'rejected'),
(23, 2,  5,  7,  'pending'),
(24, 5,  6,  9,  'interviewing'),
(25, 6,  8, 11,  'offered'),
(26, 7,  8, 10,  'rejected'),
(27, 9,  4, 14,  'interviewing'),
(28, 10, 1,  1,  'rejected'),
(29, 11, 5,  6,  'rejected'),
(30, 14, 8, 10,  'interviewing');

-- Interviews (55)
INSERT INTO Interview (id, applicationId, round, type, passed) VALUES
-- App 1: Alice at TechNova listing 1 → offered (all pass)
(1,  1, 1, 'phone',      1),
(2,  1, 2, 'technical',  1),
(3,  1, 3, 'onsite',     1),
-- App 2: Ben at TechNova listing 1 → interviewing (failed tech)
(4,  2, 1, 'phone',      1),
(5,  2, 2, 'technical',  0),
-- App 3: Clara at BlueSky → rejected
(6,  3, 1, 'phone',      1),
(7,  3, 2, 'behavioral', 0),
-- App 4: David at Zenith → offered (all pass)
(8,  4, 1, 'phone',      1),
(9,  4, 2, 'technical',  1),
(10, 4, 3, 'onsite',     1),
-- App 5: Emma at TechNova frontend → interviewing (phone only so far)
(11, 5, 1, 'phone',      1),
-- App 7: Alice at Zenith → rejected
(12, 7, 1, 'phone',      1),
(13, 7, 2, 'technical',  0),
-- App 8: Clara at Zenith → interviewing
(14, 8, 1, 'phone',      1),
-- App 9: Grace at PinnacleTech → offered (all pass)
(15, 9, 1, 'phone',      1),
(16, 9, 2, 'technical',  1),
(17, 9, 3, 'behavioral', 1),
(18, 9, 4, 'onsite',     1),
-- App 10: Henry at PinnacleTech PM → interviewing
(19, 10, 1, 'phone',     1),
(20, 10, 2, 'behavioral',1),
-- App 11: Isla at Orbit DevOps → offered (all pass)
(21, 11, 1, 'phone',     1),
(22, 11, 2, 'technical', 1),
(23, 11, 3, 'onsite',    1),
-- App 12: James at Orbit QA → rejected
(24, 12, 1, 'phone',     1),
(25, 12, 2, 'technical', 0),
-- App 13: Karen at CloudForge → interviewing
(26, 13, 1, 'phone',     1),
(27, 13, 2, 'technical', 1),
-- App 14: Liam at CloudForge security → offered
(28, 14, 1, 'phone',     1),
(29, 14, 2, 'behavioral',1),
(30, 14, 3, 'onsite',    1),
-- App 16: Noah at Zenith staff → offered (all pass)
(31, 16, 1, 'phone',     1),
(32, 16, 2, 'technical', 1),
(33, 16, 3, 'onsite',    1),
-- App 17: Olivia at PinnacleTech → rejected
(34, 17, 1, 'phone',     1),
(35, 17, 2, 'behavioral',0),
-- App 18: Paul at Orbit → interviewing
(36, 18, 1, 'phone',     1),
-- App 20: Rachel at TechNova frontend → offered
(37, 20, 1, 'phone',     1),
(38, 20, 2, 'technical', 1),
(39, 20, 3, 'onsite',    1),
-- App 21: Sam at PinnacleTech → interviewing
(40, 21, 1, 'phone',     1),
(41, 21, 2, 'technical', 1),
-- App 22: Tina at Zenith → rejected
(42, 22, 1, 'phone',     0),
-- App 24: Emma at Orbit QA → interviewing
(43, 24, 1, 'phone',     1),
-- App 25: Frank at CloudForge → offered
(44, 25, 1, 'phone',     1),
(45, 25, 2, 'technical', 1),
(46, 25, 3, 'onsite',    1),
-- App 26: Grace at CloudForge → rejected
(47, 26, 1, 'phone',     1),
(48, 26, 2, 'technical', 0),
-- App 27: Isla at Zenith staff → interviewing
(49, 27, 1, 'phone',     1),
(50, 27, 2, 'technical', 1),
-- App 28: James at TechNova → rejected
(51, 28, 1, 'phone',     1),
(52, 28, 2, 'behavioral',0),
-- App 29: Karen at PinnacleTech → rejected
(53, 29, 1, 'phone',     0),
-- App 30: Noah at CloudForge → interviewing
(54, 30, 1, 'phone',     1),
(55, 30, 2, 'technical', 1);

-- Offers (10)
INSERT INTO Offer (id, applicationId, salary, startingBonus, easyBonus, stocks, accepted, expiryDate) VALUES
(1,  1,  130000, 10000.00, 5000.00,  500,  1,    '2026-04-15'),
(2,  4,  145000, 15000.00, 7500.00,  1000, 0,    '2026-03-01'),
(3,  20,  95000,  5000.00, 2500.00,  200,  1,    '2026-05-01'),
(4,  9,  155000, 20000.00, 10000.00, 2000, 1,    '2026-04-30'),
(5,  11, 125000, 12000.00, 6000.00,  750,  1,    '2026-05-15'),
(6,  14, 115000,  8000.00, 4000.00,  300,  0,    '2026-03-20'),
(7,  16, 165000, 25000.00, 12000.00, 3000, 1,    '2026-06-01'),
(8,  25, 110000,  9000.00, 4500.00,  400,  NULL, '2026-06-15'),
(9,  5,   92000,  4000.00, 2000.00,  150,  NULL, '2026-05-30'),
(10, 27, 170000, 30000.00, 15000.00, 5000, NULL, '2026-06-20');
