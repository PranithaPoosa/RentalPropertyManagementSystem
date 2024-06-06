-- Number of Preferences for each UnitType
CREATE VIEW CustomerPreferencesPerUnitType AS
SELECT
	ut.UnitTypeName,
	COUNT(cp.CustomerID) AS NumOfPreferences
FROM
	UnitType ut
LEFT JOIN CustomerPreferences cp ON
	ut.UnitTypeID = cp.UnitTypeID
GROUP BY
	ut.UnitTypeName;


-- Total Available Apartments in Each City
CREATE VIEW AvailableApartmentsPerCity AS
SELECT
	AA.City AS City,
	COUNT(DISTINCT A.ApartmentID) AS AvailableApartments
FROM
	Apartment A
JOIN ApartmentUnit AU ON
	A.ApartmentID = AU.ApartmentID
JOIN UnitAvailability UA ON
	AU.UnitID = UA.UnitID
JOIN ApartmentAddress AA ON
	A.AddressID = AA.AddressID
WHERE
	UA.isAvailable = 1
GROUP BY
	AA.City;


-- Maximum & Minimum Rent for Each Unit Type
CREATE VIEW MaxMinRent AS
SELECT
	ut.UnitTypeName,
	MIN(au.RentAmount) AS MinimumRent,
	MAX(au.RentAmount) AS MaximumRent,
	AVG(au.RentAmount) AS AverageRent
FROM
	ApartmentUnit au
JOIN UnitType ut ON
	au.UnitTypeID = ut.UnitTypeID
GROUP BY
	ut.UnitTypeName;


-- Number of Units Available and Their Avg Rent per Year
CREATE VIEW AvgRentAndUnitAvailability AS
SELECT
	YEAR(UA.UnitAvailabilityStartDate) AS YEAR,
	AVG(AU.RentAmount) AS AverageRent,
	COUNT(*) AS NumberOfUnits
FROM
	UnitAvailability UA
INNER JOIN ApartmentUnit AU ON
	UA.UnitID = AU.UnitID
INNER JOIN Apartment A ON
	AU.ApartmentID = A.ApartmentID
WHERE
	UA.isAvailable = 1
GROUP BY
	YEAR(UA.UnitAvailabilityStartDate)
ORDER BY
	YEAR;


-- Create a view that displays information about the tenants and their leases
CREATE VIEW TenantLeases AS
SELECT
	dbo.GetFullName(t.TenantFirstName,
	t.TenantLastName) AS 'Full Name',
	dbo.CalculateLeaseDays(l.StartDate,
	l.EndDate) AS 'LeasePeriod',
	t.EmailAddress,
	t.PhoneNumber,
	a.ApartmentName,
	au.UnitNumber,
	l.StartDate,
	l.EndDate,
	l.SecurityDeposit
FROM
	Tenant t
INNER JOIN Lease l ON
	t.TenantID = l.TenantID
INNER JOIN ApartmentUnit au ON
	l.UnitID = au.UnitID
INNER JOIN Apartment a ON
	au.ApartmentID = a.ApartmentID;






























