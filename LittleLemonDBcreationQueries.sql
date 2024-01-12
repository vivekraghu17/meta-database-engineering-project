-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS LittleLemonDB;
USE LittleLemonDB;

-- Create the Menu table
CREATE TABLE Menu (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    Cuisine VARCHAR(255) NOT NULL,
    ItemName VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Description TEXT,
    UNIQUE (ItemName)
);

-- Create the Customer Details table
CREATE TABLE CustomerDetails (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    ContactDetails VARCHAR(255) NOT NULL
);

-- Create the Bookings table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    TableNumber INT NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CustomerDetails(CustomerID)
);

-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    CustomerID INT NOT NULL,
    MenuID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES CustomerDetails(CustomerID),
    FOREIGN KEY (MenuID) REFERENCES Menu(ItemID)
);

-- Create the Order Delivery Status table
CREATE TABLE OrderDeliveryStatus (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    DeliveryDate DATE,
    Status VARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Create the Staff Information table
CREATE TABLE StaffInformation (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    Role VARCHAR(255) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    OrderID INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Create the MenuItems table
CREATE TABLE MenuItems (
    MenuItemID INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(255),
    StarterName VARCHAR(255),
    DessertName VARCHAR(255),
    MenuID INT NOT NULL,
    FOREIGN KEY (MenuID) REFERENCES Menu(ItemID)
);