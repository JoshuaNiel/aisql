-- People
INSERT INTO Person (id, firstname, lastname, email, phoneNumber, ssn) VALUES
(1, 'Alice', 'Nguyen', 'alice.nguyen@email.com', '555-0101', '123-45-6789'),
(2, 'Ben', 'Carter', 'ben.carter@email.com', '555-0102', '234-56-7890'),
(3, 'Clara', 'Moss', 'clara.moss@email.com', '555-0103', '345-67-8901'),
(4, 'David', 'Kim', 'david.kim@email.com', '555-0104', '456-78-9012'),
(5, 'Emma', 'Patel', 'emma.patel@email.com', '555-0105', '567-89-0123'),
(6, 'Frank', 'Lopez', 'frank.lopez@email.com', '555-0106', '678-90-1234');

-- Companies
INSERT INTO Company (id, companyName, isHiring) VALUES
(1, 'TechNova Inc.', 1),
(2, 'BlueSky Solutions', 1),
(3, 'DataBridge Corp.', 0),
(4, 'Zenith Software', 1);

-- Addresses
INSERT INTO Address (id, street, city, state, zip) VALUES
(1, '100 Innovation Drive', 'San Francisco', 'CA', '94105'),
(2, '200 Enterprise Blvd', 'Austin', 'TX', '78701'),
(3, '300 Tech Park Ave', 'Seattle', 'WA', '98101');

-- Job Listings
INSERT INTO JobListing (id, companyId, salaryMin, salaryMax, isActive, workType, locationId) VALUES
(1, 1, 100000, 140000, 1, 'remote', 1),
(2, 1, 80000, 110000, 1, 'hybrid', 1),
(3, 2, 90000, 120000, 1, 'onsite', 2),
(4, 4, 110000, 150000, 1, 'remote', 3),
(5, 4, 70000, 95000, 0, 'onsite', 3);

-- Requirements
INSERT INTO Requirement (id, description) VALUES
(1, 'Proficiency in Python'),
(2, 'Experience with SQL databases'),
(3, 'Knowledge of REST APIs'),
(4, 'Familiarity with cloud platforms (AWS/GCP/Azure)'),
(5, 'Communication and teamwork skills'),
(6, 'Bachelor degree in Computer Science or related field'),
(7, 'Experience with React or Vue.js'),
(8, 'Machine learning or data science background');

-- Job Requirements (linking listings to requirements)
INSERT INTO JobRequirement (listingId, requirementId, isMandatory) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 4, 0),
(2, 7, 1),
(2, 5, 1),
(3, 2, 1),
(3, 3, 1),
(3, 6, 0),
(4, 1, 1),
(4, 8, 1),
(4, 4, 1),
(5, 5, 0),
(5, 6, 1);

-- Job Applications
INSERT INTO JobApplication (id, personId, companyId, listingId, status) VALUES
(1, 1, 1, 1, 'offered'),
(2, 2, 1, 1, 'interviewing'),
(3, 3, 2, 3, 'rejected'),
(4, 4, 4, 4, 'offered'),
(5, 5, 1, 2, 'interviewing'),
(6, 6, 2, 3, 'pending'),
(7, 1, 4, 4, 'rejected'),
(8, 3, 4, 4, 'interviewing');

-- Interviews
INSERT INTO Interview (id, applicationId, round, type, passed) VALUES
(1, 1, 1, 'phone', 1),
(2, 1, 2, 'technical', 1),
(3, 1, 3, 'onsite', 1),
(4, 2, 1, 'phone', 1),
(5, 2, 2, 'technical', 0),
(6, 3, 1, 'phone', 1),
(7, 3, 2, 'behavioral', 0),
(8, 4, 1, 'phone', 1),
(9, 4, 2, 'technical', 1),
(10, 4, 3, 'onsite', 1),
(11, 5, 1, 'phone', 1),
(12, 7, 1, 'phone', 1),
(13, 7, 2, 'technical', 0),
(14, 8, 1, 'phone', 1);

-- Offers
INSERT INTO Offer (id, applicationId, salary, startingBonus, easyBonus, stocks, accepted, expiryDate) VALUES
(1, 1, 130000, 10000.00, 5000.00, 500, 1, '2026-04-15'),
(2, 4, 145000, 15000.00, 7500.00, 1000, 0, '2026-03-01'),
(3, 5, 95000, 5000.00, 2500.00, 200, NULL, '2026-05-01');
