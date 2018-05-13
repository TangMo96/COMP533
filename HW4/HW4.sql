

-- 1 Create Tables*********************************************************************************************************************
-- 1.1 Product
CREATE TABLE Product (
	productCode CHAR(3),
    productName VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (productCode)
);

-- 1.2 ProductPrice
CREATE TABLE ProductPrice (
	productCode CHAR(3),
    startDate DATE,
    cost DECIMAL(10,2) NULL,
    price DECIMAL(10,2) NULL,
    -- the combination of productCode and startDate form the primary key
    PRIMARY KEY (productCode, startDate),
    -- productCode must be a value in the product table
    FOREIGN KEY (productCode) REFERENCES Product(productCode)
);

-- 1.3 Ingredient
CREATE TABLE Ingredient(
	ingId INTEGER AUTO_INCREMENT NOT NULL,
    ingName VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    PRIMARY KEY (ingId),
    -- the combination of ingName and category must be unique
    UNIQUE (ingName, category)
)AUTO_INCREMENT=0;

-- 1.4 Recipe
CREATE TABLE Recipe(
	productCode CHAR(3),
    ingId INTEGER,
    qty FLOAT NOT NULL,
    unit VARCHAR(20) NOT NULL,
    PRIMARY KEY (productCode, ingId),
     -- ingId must be a value in the ingredient table
    FOREIGN KEY (ingId) REFERENCES Ingredient(ingId),  
     -- productCode must be a value in the product table
    FOREIGN KEY (productCode) REFERENCES Product(productCode)
 
);

-- 1.5 truckEven
CREATE TABLE TruckEvent(
	eventId INTEGER AUTO_INCREMENT,
    eventName VARCHAR(200) NOT NULL,
    eventStart Datetime NULL,
    eventEnd Datetime NULL,
    PRIMARY KEY (eventId),
     -- the combination of eventName and eventStart must be unique
    UNIQUE (eventName, EventStart)
)AUTO_INCREMENT=0;

-- 1.6 Sale
CREATE TABLE Sale(
	saleId INTEGER AUTO_INCREMENT,
    eventId INTEGER,
    productCode CHAR(3),
    PRIMARY KEY (saleId),
    -- productCode must be a value in the product table
    FOREIGN KEY (productCode) REFERENCES Product(ProductCode),
     -- eventId must be a value in the truckEvent table
	FOREIGN KEY (eventId) REFERENCES TruckEvent(eventId)    
)AUTO_INCREMENT=0;

-- 1.7 SaleDetail
CREATE TABLE SaleDetail(
	saleId INTEGER,
    ingId INTEGER,
    qty FLOAT NOT NULL,
    unit VARCHAR(20) NOT NULL,
     -- the combination of saleId and ingId form the primary key
	PRIMARY KEY (saleId, ingId),
    -- . ingId must be a value in the ingredient table
    FOREIGN KEY (ingId) REFERENCES ingredient(ingId),
    -- saleId must be a value in the sale table
    FOREIGN KEY (saleId) REFERENCES Sale(saleId)    
);

-- 1.8 Supplier
CREATE TABLE Supplier(
	supplierId INTEGER AUTO_INCREMENT,
    supplierName VARCHAR(150),
    street VARCHAR(150),
    city VARCHAR(150),
    state VARCHAR(50),
    postalCode VARCHAR(15),
    country VARCHAR(150),
	PRIMARY KEY (supplierId),
     -- the combination of supplierName, street, and city must be unique
    UNIQUE (supplierName, street, city)
)AUTO_INCREMENT=0;

-- 1.9 SupplierPhone
CREATE TABLE SupplierPhone(
	supplierId INTEGER,
    phoneType VARCHAR(50),
    phoneNumber VARCHAR(20),
    -- the combination of supplierId and phone type form the primary key
	PRIMARY KEY (supplierId, phoneType)
);

-- 1.10 LocalSupplier
CREATE TABLE LocalSupplier(
	supplierId INTEGER,
    transportFee DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (supplierId),
    FOREIGN KEY (supplierId) REFERENCES Supplier(supplierId)
);

-- 1.11 NationalSupplier
CREATE TABLE NationalSupplier(
	supplierId INTEGER,
    mileageCost DECIMAL(10,3) NOT NULL,
    distance FLOAT NOT NULL,
	PRIMARY KEY (supplierId),
     -- the supplierId value must exist in the supplier table
    FOREIGN KEY (supplierId) REFERENCES Supplier(supplierId)
);

-- 1.12 ingQuote
CREATE TABLE IngQuote(
	quoteId INTEGER AUTO_INCREMENT,
    supplierId INTEGER,
    issueDate DATE NOT NULL,
	expirationDate DATE NOT NULL,
	tax DECIMAL(10,2) NOT NULL,
    fees DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NULL DEFAULT NULL,
	PRIMARY KEY (quoteId),
    -- the supplierId value must exist in the supplier table
    FOREIGN KEY (supplierId) REFERENCES Supplier(supplierId),
    -- . the combination of supplierId and issueDate must be unique
    UNIQUE (supplierId, issueDate)
)AUTO_INCREMENT=0;

-- 1.13 quoteItem
CREATE TABLE QuoteItem(
	quoteId INTEGER,
    ingId INTEGER,
    qty FLOAT NOT NULL,
    unitCost FLOAT(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
	PRIMARY KEY (quoteId, ingId),
    -- the ingId value must exist in the ingredient table
    FOREIGN KEY (ingId) REFERENCES Ingredient(ingId),
     -- the quoteId value must exist in the quote table
    FOREIGN KEY (quoteId) REFERENCES IngQuote(quoteId)
);

-- 1.14 Delivery
CREATE TABLE Delivery(
	deliveryId INTEGER AUTO_INCREMENT,
    quoteId INTEGER,
	orderDate DATE NOT NULL,
	deliveryDate DATE NULL DEFAULT NULL,
	PRIMARY KEY (deliveryId),
    -- e quoteId value must exist in the quote table
	FOREIGN KEY (quoteId) REFERENCES IngQuote(quoteId)
)AUTO_INCREMENT=0;

-- 1.15 inventoryItem
CREATE TABLE InventoryItem(
	ingId INTEGER,
    quoteId INTEGER,
    expirationDate DATE NULL,
	stockQty FLOAT NOT NULL,
    unit VARCHAR(20) NOT NULL,
    qtyRemaining FLOAT NULL,
	PRIMARY KEY (ingId, quoteId),
    -- the ingId value must exist in the ingredient table
    FOREIGN KEY (ingId) REFERENCES Ingredient(ingId),
    -- e quoteId value must exist in the quote table
	FOREIGN KEY (quoteId) REFERENCES IngQuote(quoteId)    
);

-- 1.16 Equipment
CREATE TABLE Equipment(
    -- . each piece of equipment is assigned a unique name that also serves as the primary key
	equipmentName VARCHAR(50),
    installDate DATE NOT NULL,
	PRIMARY KEY (equipmentName)
);

-- 1.17 Maintenance
CREATE TABLE Maintenance(
	maintId INTEGER AUTO_INCREMENT,
    equipmentName VARCHAR(50) NOT NULL,
	description VARCHAR(150) NULL,
	beforeFlag INTEGER NOT NULL,
	triggerAmount INTEGER NOT NULL,
    triggerUnit VARCHAR(20) NOT NULL,
    duration INTEGER NOT NULL,
	PRIMARY KEY (maintId),
    -- equipmentName value must exist in the equipment table
	FOREIGN KEY (equipmentName) REFERENCES Equipment(equipmentName)
)AUTO_INCREMENT=0;

-- 1.18 MaintenanceLog
CREATE TABLE MaintenanceLog(
	maintId INTEGER,
    datePerformed DATE,
    duration INTEGER NULL,
    notes TEXT NULL,
	PRIMARY KEY (maintId, datePerformed)
);



-- 2 Create Data**********************************************************************************************************************************
-- products
INSERT INTO Product (productCode, productName) VALUES ('533', 'sundae');
INSERT INTO Product (productCode, productName) VALUES ('sx', 'extra sundae topping');
INSERT INTO Product (productCode, productName) VALUES ('mt', 'monkey tail');
INSERT INTO Product (productCode, productName) VALUES ('dk', 'drink');
-- price
INSERT INTO ProductPrice (productCode, startDate, price)       VALUES ('533', '2012-12-12', 4);
INSERT INTO ProductPrice (productCode, startDate, cost, price) VALUES ('sx', '2012-12-12', 0.05, 0.25);
INSERT INTO ProductPrice (productCode, startDate, cost, price) VALUES ('mt', '2012-12-12', 2.5, 5);
INSERT INTO ProductPrice (productCode, startDate, cost, price) VALUES ('dk', '2012-12-12', 0.44, 0.75);
-- ingredient
-- topping
INSERT INTO Ingredient (ingId, ingName, category) VALUES (1, 'no-topping', 'topping');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (2, 'sprinkles', 'topping');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (3, 'oreo', 'topping');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (4, 'peanuts', 'topping');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (5, 'hot fudge', 'topping');
-- ice cream base
INSERT INTO Ingredient (ingId, ingName, category) VALUES (6, 'chocolate', 'ice cream base');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (7, 'vanilla', 'ice cream base');
-- drink
INSERT INTO Ingredient (ingId, ingName, category) VALUES (8, 'coke', 'drink');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (9, 'sprite', 'drink');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (10, 'water', 'drink');

INSERT INTO Ingredient (ingId, ingName, category) VALUES (11, 'chocolate covered frozen banana', 'mt');

INSERT INTO Ingredient (ingId, ingName, category) VALUES (12, '10 oz dish', 'cup');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (13, 'tall napkin', 'paper goods');
INSERT INTO Ingredient (ingId, ingName, category) VALUES (14, 'short spoon', 'spoon');

INSERT INTO Ingredient (ingId, ingName, category) VALUES (15, 'strawberries', 'fruit');

-- ingredients for 533
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 12, 1, 'none');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 13, 1, 'none');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 6, 6, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 7, 6, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 14, 1, 'none');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 2, 1.5, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 3, 1.5, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 4, 1.5, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('533', 5, 1.5, 'ounce');

-- ingredients for sx,mt,dk
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('sx', 2, 1.5, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('sx', 3, 1.5, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('sx', 4, 1.5, 'ounce');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('mt', 11, 1, 'none');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('dk', 8, 1, 'bottle');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('dk', 9, 1, 'bottle');
INSERT INTO Recipe (productCode, ingId, qty, unit) VALUES ('dk', 10, 1, 'bottle');

-- Equipment
INSERT INTO Equipment (equipmentName, installDate) VALUES ('Rice',      '2012-12-12');
INSERT INTO Equipment (equipmentName, installDate) VALUES ('Owl',       '2012-12-12');
INSERT INTO Equipment (equipmentName, installDate) VALUES ('generator', '2012-12-12');
-- Maintenance
INSERT INTO Maintenance (equipmentName, description, beforeFlag, triggerAmount, triggerUnit, duration) VALUES ('Rice', 'clean', 1, 1, 'week', 120);
INSERT INTO Maintenance (equipmentName, description, beforeFlag, triggerAmount, triggerUnit, duration) VALUES ('Owl', 'clean', 1, 1, 'week', 120);
INSERT INTO Maintenance (equipmentName, description, beforeFlag, triggerAmount, triggerUnit, duration) VALUES ('generator', 'refuel', 0, 40, 'hour', 10);
INSERT INTO Maintenance (equipmentName, description, beforeFlag, triggerAmount, triggerUnit, duration) VALUES ('generator', 'change oil & filter', 0, 200, 'hour', 10);

INSERT INTO MaintenanceLog (maintId, datePerformed, notes) VALUES (3, '2018-03-01', 'Purchase more diesel!');
INSERT INTO MaintenanceLog (maintId, datePerformed, duration) VALUES (1, '2018-03-02', 100);
INSERT INTO MaintenanceLog (maintId, datePerformed, duration) VALUES (2, '2018-03-02', 110);

-- TruckEvent
INSERT INTO TruckEvent (eventName, eventStart, eventEnd) VALUES ('GSA study break', '2018-03-01 20:00:00', '2018-03-01 23:00:00');

-- 53 "533 sundae"
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
INSERT INTO Sale (eventId, productCode) VALUES (1, '533');
-- 5 monkey tails
INSERT INTO Sale (eventId, productCode) VALUES (1, 'mt');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'mt');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'mt');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'mt');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'mt');
-- 69 drinks: 10 cokes + 22 sprites + 37 water
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');
INSERT INTO Sale (eventId, productCode) VALUES (1, 'dk');

-- 25 vanilla
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (1, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (2, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (3, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (4, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (5, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (6, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (7, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (8, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (9, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (10, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (11, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (12, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (13, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (14, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (15, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (16, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (17, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (18, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (19, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (20, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (21, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (22, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (23, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (24, 7, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (25, 7, 6, 'ounce');

-- 28 chocolate
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (26, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (27, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (28, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (29, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (30, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (31, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (32, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (33, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (34, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (35, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (36, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (37, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (38, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (39, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (40, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (41, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (42, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (43, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (44, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (45, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (46, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (47, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (48, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (49, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (50, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (51, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (52, 6, 6, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (53, 6, 6, 'ounce');

-- 10  no topping
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (1, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (2, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (3, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (4, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (5, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (6, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (7, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (8, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (9, 1, 0, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (10, 1, 0, 'ounce');

-- 20 oreos
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (11, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (12, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (13, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (14, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (15, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (16, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (17, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (18, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (19, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (20, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (21, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (22, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (23, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (24, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (25, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (26, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (27, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (28, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (29, 3, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (30, 3, 1.5, 'ounce');

-- 3 peanuts
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (31, 4, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (32, 4, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (33, 4, 1.5, 'ounce');

-- 20 sprinkles
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (34, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (35, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (36, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (37, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (38, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (39, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (40, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (41, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (42, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (43, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (44, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (45, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (46, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (47, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (48, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (49, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (50, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (51, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (52, 2, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (53, 2, 1.5, 'ounce');

-- the toppings that 533 must has
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (1, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (2, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (3, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (4, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (5, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (6, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (7, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (8, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (9, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (10, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (11, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (12, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (13, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (14, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (15, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (16, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (17, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (18, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (19, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (20, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (21, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (22, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (23, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (24, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (25, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (26, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (27, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (28, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (29, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (30, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (31, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (32, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (33, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (34, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (35, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (36, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (37, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (38, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (39, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (40, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (41, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (42, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (43, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (44, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (45, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (46, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (47, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (48, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (49, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (50, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (51, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (52, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (53, 12, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (1, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (2, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (3, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (4, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (5, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (6, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (7, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (8, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (9, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (10, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (11, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (12, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (13, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (14, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (15, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (16, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (17, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (18, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (19, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (20, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (21, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (22, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (23, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (24, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (25, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (26, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (27, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (28, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (29, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (30, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (31, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (32, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (33, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (34, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (35, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (36, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (37, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (38, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (39, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (40, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (41, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (42, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (43, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (44, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (45, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (46, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (47, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (48, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (49, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (50, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (51, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (52, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (53, 13, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (1, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (2, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (3, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (4, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (5, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (6, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (7, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (8, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (9, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (10, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (11, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (12, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (13, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (14, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (15, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (16, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (17, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (18, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (19, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (20, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (21, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (22, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (23, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (24, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (25, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (26, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (27, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (28, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (29, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (30, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (31, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (32, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (33, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (34, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (35, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (36, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (37, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (38, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (39, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (40, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (41, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (42, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (43, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (44, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (45, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (46, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (47, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (48, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (49, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (50, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (51, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (52, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (53, 14, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (1, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (2, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (3, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (4, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (5, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (6, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (7, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (8, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (9, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (10, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (11, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (12, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (13, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (14, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (15, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (16, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (17, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (18, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (19, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (20, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (21, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (22, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (23, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (24, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (25, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (26, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (27, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (28, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (29, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (30, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (31, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (32, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (33, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (34, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (35, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (36, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (37, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (38, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (39, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (40, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (41, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (42, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (43, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (44, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (45, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (46, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (47, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (48, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (49, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (50, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (51, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (52, 5, 1.5, 'ounce');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (53, 5, 1.5, 'ounce');

-- 5 monkey tails
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (54, 11, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (55, 11, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (56, 11, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (57, 11, 1, 'none');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (58, 11, 1, 'none');

 -- 10 cokes
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (59, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (60, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (61, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (62, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (63, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (64, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (65, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (66, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (67, 8, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (68, 8, 1, 'bottle');

-- 22 sprites
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (69, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (70, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (71, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (72, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (73, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (74, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (75, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (76, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (77, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (78, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (79, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (80, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (81, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (82, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (83, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (84, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (85, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (86, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (87, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (88, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (89, 9, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (90, 9, 1, 'bottle');

-- 37 bottles of water
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (91, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (92, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (93, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (94, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (95, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (96, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (97, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (98, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (99, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (100, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (101, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (102, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (103, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (104, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (105, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (106, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (107, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (108, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (109, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (110, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (111, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (112, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (113, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (114, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (115, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (116, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (117, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (118, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (119, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (120, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (121, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (122, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (123, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (124, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (125, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (126, 10, 1, 'bottle');
INSERT INTO SaleDetail (saleId, ingId, qty, unit) VALUES (127, 10, 1, 'bottle');


-- 4 suppliers
INSERT INTO Supplier (supplierId, supplierName, street, city, state, postalCode, country) VALUES (1, 'Houston\'s Best Food', '934 University Blvd', 'Houston', 'TX', '77005', 'USA');
INSERT INTO Supplier (supplierId, supplierName, street, city, state, postalCode, country) VALUES (2, 'Local Premium Food', '101 Main St', 'Houston', 'TX', '77004', 'USA');
INSERT INTO Supplier (supplierId, supplierName, street, city, state, postalCode, country) VALUES (3, 'Best Food in Canada', ' 735 First Ave', 'Toronto', 'Ontario', 'M4B 1B5', 'Canada');
INSERT INTO Supplier (supplierId, supplierName, street, city, state, postalCode, country) VALUES (4, 'LA Ice Cream Supply', '535 King St', 'Lake Charles', 'LA', '70601', 'USA');
-- transportFee
INSERT INTO LocalSupplier (supplierId, transportFee) VALUES (1, 7);
INSERT INTO LocalSupplier (supplierId, transportFee) VALUES (2, 5);
INSERT INTO NationalSupplier (supplierId, mileageCost, distance) VALUES (3, 0.1, 1530);
INSERT INTO NationalSupplier (supplierId, mileageCost, distance) VALUES (4, 0.11, 148);
-- Quote
INSERT INTO IngQuote (quoteId, supplierId, issueDate, expirationDate, tax, fees) VALUES (1, 1, '2018-02-02', '2018-02-10', 5.98, 7);
INSERT INTO QuoteItem (quoteId, ingId, qty, unitCost, unit) VALUES (1, 15, 20, 2, 'pound');
INSERT INTO QuoteItem (quoteId, ingId, qty, unitCost, unit) VALUES (1, 7, 5, 3, 'gallon');
INSERT INTO QuoteItem (quoteId, ingId, qty, unitCost, unit) VALUES (1, 6, 5, 3.5, 'gallon');
-- competing quote
INSERT INTO IngQuote (quoteId, supplierId, issueDate, expirationDate, tax, fees) VALUES (2, 2, '2018-02-03', '2018-02-09', 6.35, 5);
INSERT INTO QuoteItem (quoteId, ingId, qty, unitCost, unit) VALUES (2, 15, 25, 1.75, 'pound');
INSERT INTO QuoteItem (quoteId, ingId, qty, unitCost, unit) VALUES (2, 7, 5, 3.2, 'gallon');
INSERT INTO QuoteItem (quoteId, ingId, qty, unitCost, unit) VALUES (2, 6, 5, 3.45, 'gallon');


-- 3 Short answer question**********************************************************************************************************************************
-- 3.0.1 
-- Float to caculate variables like distance and quantity, which supports many format; and Decimal to calculate money, which is precise.
    
-- 3.0.2 
-- When using the string, the names of ingredients are specific, which is convenient for us to look up; But string needs more memory space.

-- 3.0.3 Use the equipment and description to represent the maintId. 

-- 3.0.4 
-- Add an attribute to Sale for this new truck.
-- Add an attribute to TruckEvent for this new truck.
-- Add an attribute to Equipment for different equipment of this new truck.
-- Add an attribute to Maintenance for different maintenance of this new truck.
-- Add an attribute to MaintenanceLog for different maintenanceLog of this new truck.

-- 3.0.5 Chocalate.


    
-- 4 Queries**********************************************************************************************************************************
-- 4.0.1
SELECT Pr.productCode, Pr.productName, Ing.ingId, Ing.ingName, Ing.category, Re.qty, Re.unit
FROM Ingredient Ing	JOIN Recipe Re ON Re.ingId = Ing.ingId JOIN Product Pr ON Pr.productCode = Re.productCode
WHERE Pr.productCode = '533' ORDER BY Ing.ingName;

-- 4.0.2 
-- For test
CREATE OR REPLACE VIEW Cost AS 
SELECT I.quoteId, (I.ingCost + Ing.tax + Ing.fees) AS qCost
FROM (SELECT E.quoteId, SUM(E.ecost) AS ingCost FROM (
		SELECT Q.quoteId, (Q.qty * Q.unitCost) AS ecost FROM QuoteItem Q ) E GROUP BY E.quoteId ) I
    JOIN IngQuote Ing ON I.quoteId = Ing.quoteId JOIN LocalSupplier L ON L.supplierId = Ing.supplierId;
set @lowest = (SELECT MIN(qCost) FROM Cost);
SELECT * FROM Cost WHERE qCost = @lowest;

-- 4.0.3
SELECT SUM(Pr.price) AS income
FROM TruckEvent Tr 	JOIN Sale Sa ON Tr.eventId = Sa.eventId	JOIN ProductPrice Pr ON Pr.productCode = Sa.productCode;


-- If we want to test, we have to drop all the tables as follows:
-- DROP TABLE IF EXISTS MaintenanceLog;
-- DROP TABLE IF EXISTS Maintenance;
-- DROP TABLE IF EXISTS Equipment;
-- DROP TABLE IF EXISTS InventoryItem;
-- DROP TABLE IF EXISTS Delivery;
-- DROP TABLE IF EXISTS QuoteItem;
-- DROP TABLE IF EXISTS IngQuote;
-- DROP TABLE IF EXISTS NationalSupplier;
-- DROP TABLE IF EXISTS LocalSupplier;
-- DROP TABLE IF EXISTS SupplierPhone;
-- DROP TABLE IF EXISTS Supplier;
-- DROP TABLE IF EXISTS SaleDetail;
-- DROP TABLE IF EXISTS Sale;
-- DROP TABLE IF EXISTS TruckEvent;
-- DROP TABLE IF EXISTS Recipe;
-- DROP TABLE IF EXISTS Ingredient;
-- DROP TABLE IF EXISTS ProductPrice;
-- DROP TABLE IF EXISTS Product;


