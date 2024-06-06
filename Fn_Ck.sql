-- Function to generate FullName based on FirstName and LastName
CREATE FUNCTION dbo.GetFullName (@FirstName VARCHAR(255),
@LastName VARCHAR(255))
RETURNS VARCHAR(510)
AS
BEGIN
	DECLARE @FullName VARCHAR(510)
    SET
	@FullName = @FirstName + ' ' + @LastName
    RETURN @FullName
END;

-- Function to get the rent amount for a given unit
CREATE FUNCTION dbo.GetRentAmountForUnit(@UnitID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @RentAmount MONEY;

SELECT
	@RentAmount = RentAmount
FROM
	ApartmentUnit
WHERE
	UnitID = @UnitID;

RETURN @RentAmount;
END;

-- Function to ensure that the RentAmount is greater than 0
CREATE FUNCTION fn_aCheckRentAmount(@RentAmount DECIMAL(10,
2))
RETURNS BIT
AS
BEGIN
    RETURN CASE
	WHEN @RentAmount > 0 THEN 1
	ELSE 0
END
END;

-- Function to calculate the lease period
CREATE FUNCTION dbo.CalculateLeaseDays(@StartDate DATE,
@EndDate DATE)
RETURNS INT
AS
BEGIN
    DECLARE @LeaseDays INT

    IF @StartDate <= @EndDate
        SET
@LeaseDays = DATEDIFF(DAY,
@StartDate,
@EndDate)
ELSE
        SET
@LeaseDays = NULL

    RETURN @LeaseDays
END;


-- CHECK constraint to ensure payment amount is atleast equal to rent amount 
ALTER TABLE Payment
ADD CONSTRAINT CK_Payment_AmountEqualsRent CHECK (Amount >= dbo.GetRentAmountForUnit(UnitID));

-- CHECK constraint to the ApartmentUnit table
ALTER TABLE ApartmentUnit
ADD CONSTRAINT chk_RentAmount CHECK (dbo.fn_CheckRentAmount(RentAmount) = 1);

-- Check Constraint to see if Start Date is earlier than End Date 
ALTER TABLE Lease 
ADD CONSTRAINT chk_dates CHECK (dbo.CalculateLeaseDays(StartDate,
EndDate) IS NOT NULL);

-- Check Constraint to see if Start Date is earlier than End Date 
ALTER TABLE UnitAvailability  
ADD CONSTRAINT chk_dates_ua CHECK (dbo.CalculateLeaseDays(UnitAvailabilityStartDate ,
UnitAvailabilityEndDate) IS NOT NULL);
