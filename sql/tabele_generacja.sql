CREATE TABLE Products(
  ProductID INT NOT NULL AUTO_INCREMENT,
  Amount INT NOT NULL,
  Price INT NOT NULL,
  Name VARCHAR(50),
  Expiration_date DATE NOT NULL ,
  Type ENUM("Food", "Drink", "Other"),
  PRIMARY KEY (ProductID)
);

CREATE TABLE Sales(
  SaleID INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL ,
  Date_from DATE NOT NULL,
  Date_to DATE NOT NULL,
  ProductID INT NOT NULL,
  Price INT NOT NULL ,
  PRIMARY KEY (SaleID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Storage(
  Capacity INT NOT NULL ,
  Food_capacity INT NOT NULL ,
  Drinks_capacity INT NOT NULL ,
  Other_capacity INT NOT NULL ,
  Capacity_usage INT NOT NULL ,
  Food_usage INT NOT NULL ,
  Drinks_usage INT NOT NULL ,
  Others_usage INT NOT NULL

);

CREATE TABLE Log(
  Date DATE NOT NULL ,
  User VARCHAR(25) ,
  Operation VARCHAR(125),
  Table_name VARCHAR(50),
  Column_name VARCHAR(60),
  Old_value VARCHAR(70),
  New_value VARCHAR(70),
  STATUS VARCHAR(70)
);

CREATE TABLE Delivery(
  DeliveryID INT NOT NULL AUTO_INCREMENT,
  Order_date DATE NOT NULL ,
  Receiving_date DATE NOT NULL ,
  Status ENUM("Created", "Ordered", "Received", "Canceled"),
  PRIMARY KEY (DeliveryID)
);

CREATE TABLE itemsInDelivery(
  DeliveryID INT NOT NULL,
  ProductID INT NOT NULL ,
  Amount INT NOT NULL ,
  FOREIGN KEY (DeliveryID) REFERENCES Delivery(DeliveryID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Clients(
  ClientID INT NOT NULL AUTO_INCREMENT,
  Login VARCHAR(30) NOT NULL,
  Password VARCHAR(40) NOT NULL ,
  Name VARCHAR(40) NOT NULL ,
  Surname VARCHAR(40) NOT NULL ,
  Company VARCHAR(50),
  Phone VARCHAR(9) NOT NULL ,
  Adress VARCHAR(255) NOT NULL ,
  Wallet INT NOT NULL ,
  PRIMARY KEY (ClientID)
);

CREATE TABLE History(
  ClientID INT NOT NULL ,
  ProductID INT NOT NULL ,
  Quantity INT NOT NULL ,
  Price INT NOT NULL ,
  Data DATE NOT NULL,
  FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Transactions(
  TransactionID INT NOT NULL AUTO_INCREMENT,
  Date DATE NOT NULL ,
  ClientID INT NOT NULL ,
  TotalPrice INT NOT NULL ,
  NumberOfProducts INT NOT NULL ,
  Status ENUM("Waiting", "Declined", "Accepted", "Paid"),
  PRIMARY KEY (TransactionID),
  FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

CREATE TABLE Workers(
  WorkerID INT NOT NULL AUTO_INCREMENT,
  Login VARCHAR(30) NOT NULL,
  Password VARCHAR(40) NOT NULL ,
  Name VARCHAR(40) NOT NULL ,
  Surname VARCHAR(40) NOT NULL ,
  PESEL VARCHAR(11) NOT NULL ,
  Phone VARCHAR(9) NOT NULL ,
  Salary INT NOT NULL ,
  ContractFrom DATE NOT NULL ,
  ContractTo DATE,
  PRIMARY KEY (WorkerID)
);

CREATE TABLE Balance(
  Date DATE NOT NULL ,
  Status ENUM("Paid", "Unpaid", "Received", "Canceled") ,
  DeliveryID INT,
  WorkerID INT,
  TransactionID INT,
  Fee INT NOT NULL,
  Income INT,
  Expense INT,
  Balance INT NOT NULL ,
  FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
  FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID),
  FOREIGN KEY (DeliveryID) REFERENCES Delivery(DeliveryID)
);

CREATE TABLE itemInTransaction(
  transactionID INT NOT NULL ,
  productID INT NOT NULL ,
    amount INT,
  FOREIGN KEY (transactionID) REFERENCES Transactions(TransactionID),
  FOREIGN KEY (productID) REFERENCES Products(ProductID)
);

CREATE TABLE tempCart(
  clientID INT NOT NULL ,
  productID INT NOT NULL ,
  pieces INT NOT NULL ,
  FOREIGN KEY (clientID) REFERENCES Clients(ClientID),
  FOREIGN KEY (productID) REFERENCES Products(ProductID)
);