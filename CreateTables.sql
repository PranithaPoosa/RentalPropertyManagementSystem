create database FinalProject_Group1;

use FinalProject_Group1;

-- Apartment Table
CREATE TABLE Apartment (
  ApartmentID INT PRIMARY KEY,
  ApartmentName VARCHAR(50),
  AddressID INT NOT NULL,
  LandlordID INT NOT NULL,
  EmployeeID INT NOT NULL,
  FOREIGN KEY (AddressID) REFERENCES ApartmentAddress(AddressID),
  FOREIGN KEY (LandlordID) REFERENCES Landlord(LandlordID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- ApartmentUnit Table
CREATE TABLE ApartmentUnit (
  UnitID INT PRIMARY KEY,
  ApartmentID INT NOT NULL,
  UnitTypeID INT NOT NULL,
  UnitNumber VARCHAR(10),
  RentAmount DECIMAL(10, 2),
  FOREIGN KEY (ApartmentID) REFERENCES Apartment(ApartmentID),
  FOREIGN KEY (UnitTypeID) REFERENCES UnitType(UnitTypeID)
);

-- ApartmentAddress Table
CREATE TABLE ApartmentAddress (
  AddressID INT PRIMARY KEY,
  Street VARCHAR(255),
  City VARCHAR(50),
  State VARCHAR(50),
  ZipCode VARCHAR(10)
);
 

-- UnitType Table
CREATE TABLE UnitType (
    UnitTypeID INT PRIMARY KEY,
    UnitTypeName VARCHAR(50),
    UnitTypeDescription VARCHAR(255)
);

-- Tenant Table
CREATE TABLE Tenant (
    TenantID INT PRIMARY KEY,
    TenantFirstName VARCHAR(255),
    TenantLastName VARCHAR(255),
    EmailAddress VARCHAR(255),
    PhoneNumber VARCHAR(20)
);

-- UnitAvailability Table
CREATE TABLE UnitAvailability (
    UnitAvailabilityID INT PRIMARY KEY,
    UnitID INT NOT NULL,
    UnitAvailabilityStartDate DATE,
    UnitAvailabilityEndDate DATE,
    isAvailable BIT,
    FOREIGN KEY (UnitID) REFERENCES ApartmentUnit(UnitID)
);

-- MaintenanceRequest Table 
CREATE TABLE MaintenanceRequest (
    MaintenanceRequestID INT PRIMARY KEY,
    UnitID INT NOT NULL,
    RequestDate DATE DEFAULT GETDATE(),
    RequestDescription VARCHAR(200),
    Status VARCHAR(50),
    FOREIGN KEY (UnitID) REFERENCES ApartmentUnit(UnitID),
    CHECK (Status IN ('Pending', 'In Progress', 'Completed'))
);

-- Lease Table
CREATE TABLE Lease (
    TenantID INT NOT NULL,
    UnitID INT NOT NULL,
    StartDate DATE,
    EndDate DATE,
    SecurityDeposit DECIMAL(10,2),
    PRIMARY KEY (TenantID, UnitID),
    FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
    FOREIGN KEY (UnitID) REFERENCES ApartmentUnit(UnitID)
);

-- Payment Table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    UnitID INT NOT NULL,
    PaymentDate DATE DEFAULT GETDATE(),
    Amount DECIMAL(10,2),
    FOREIGN KEY (UnitID) REFERENCES ApartmentUnit(UnitID)
);

-- Landlord Table
CREATE TABLE Landlord (
    LandlordID INT PRIMARY KEY,
    LandlordFirstName VARCHAR(255),
    LandlordLastName VARCHAR(255),
    LandlordContactNumber VARCHAR(20)
);

-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeFirstName VARCHAR(255),
    EmployeeLastName VARCHAR(255),
    EmployeeContact VARCHAR(20)
);

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    CustomerFirstName VARCHAR(50),
    CustomerLastName VARCHAR(50),
    CustomerContact VARCHAR(20),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
 );

-- CustomerPreferences Table
CREATE TABLE CustomerPreferences (
  CustomerID INT NOT NULL,
  UnitTypeID INT NOT NULL,
  MinimumRent DECIMAL(10,2) NOT NULL,
  MaximumRent DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (CustomerID, UnitTypeID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (UnitTypeID) REFERENCES UnitType(UnitTypeID),
  CHECK (MinimumRent <= MaximumRent)
);

-- Feedback Table
CREATE TABLE Feedback (
  FeedbackID INT PRIMARY KEY,
  TenantID INT NOT NULL,
  FeedbackDate DATE NOT NULL DEFAULT GETDATE(),
  FeedbackDescription VARCHAR(500) NOT NULL,
  FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID)
);

