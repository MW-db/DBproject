CREATE TABLE tempCart(
  clientID INT NOT NULL ,
  productID INT NOT NULL ,
  pieces INT NOT NULL ,
  FOREIGN KEY (clientID) REFERENCES Clients(ClientID),
  FOREIGN KEY (productID) REFERENCES Products(ProductID)
);