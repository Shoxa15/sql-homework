# Lesson 3: Importing and Exporting Data

✅ Importing Data (BULK INSERT, Excel, Text)
✅ Exporting Data (Excel, Text)
✅ Comments, Identity column, NULL/NOT NULL values
✅ Unique Key, Primary Key, Foreign Key, Check Constraint
✅ Differences between UNIQUE KEY and PRIMARY KEY

> **Notes before doing the tasks:**
> - Tasks should be solved using **SQL Server**.
> - Case insensitivity applies.
> - Alias names do not affect the score.
> - Scoring is based on the **correct output**.
> - One correct solution is sufficient.

______________________________________

## 🟢 Easy-Level Tasks (10)
1. Define and explain the purpose of BULK INSERT in SQL Server.
   
  BULK INSERT in SQL Server is optimized for fast, large-scale data imports, offering key benefits:

  High Performance: Processes data in batches, reducing overhead and enabling minimal logging for faster loads.

  Efficient ETL & Migrations: Ideal for bulk data transfers in ETL pipelines or system migrations.

  Simplified File Handling: Supports various formats (CSV, text, etc.) with options for delimiters, headers, and NULL handling.

  Reduced Network Traffic: Imports data in a single operation instead of row-by-row.

  Log & External Data Ingestion: Quickly loads log files or external data for analysis.

  Best for: Large datasets where traditional INSERT would be too slow or resource-intensive.  
  
2. List four file formats that can be imported into SQL Server.
  CSV, TXT (flat files) and xml
  
3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).

  CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2));
  
4. Insert three records into the Products table using INSERT INTO.

  INSERT INTO Products (ProductID, ProductName, Price)
  VALUES
    (1, 'Banana', 1200.00),
    (2, 'Apple', 25.50),
    (3, 'Pineapple', 75.00);
  
5. Explain the difference between NULL and NOT NULL.
    NULL
    Represents missing, unknown, or inapplicable data.
    Not the same as 0, '' (empty string), or FALSE.
    Default behavior: Columns allow NULL unless specified otherwise.
    Comparisons: Use IS NULL or IS NOT NULL (not = or !=).
    Aggregate functions (e.g., SUM(), AVG()) ignore NULL values.
    
    NOT NULL
    Ensures a column must always have a value.
    Used for mandatory data (e.g., CustomerID, OrderDate).
    Primary keys are automatically NOT NULL.

  Example:
  CREATE TABLE Orders (  
    OrderID INT PRIMARY KEY,        
    CustomerID INT NOT NULL,          
    ShipDate DATE NULL);  
  
      
6. Add a UNIQUE constraint to the ProductName column in the Products table.
  1. Adding a Named Constraint : This approach gives the constraint a specific name, which is helpful for identifying and managing it later
    ALTER TABLE Products
    ADD CONSTRAINT UQ_Products_ProductName UNIQUE (ProductName);

  2. Adding an Unnamed Constraint : While this works, SQL Server will automatically generate a name for the constraint, which can be less intuitive if you need to reference it later.
    ALTER TABLE Products
    ADD UNIQUE (ProductName);

    
7. Write a comment in a SQL query explaining its purpose.
    Single line comments:
    Use two hyphens (--) at the beginning of the line. Everything from -- to the end of the line is considered a comment
    -- This query retrieves all active customers from the Customers table.
    SELECT CustomerID, CustomerName, Email
    FROM Customers
    WHERE IsActive = 1;

    Multi-Line comments:
      Use /* to start the comment and */ to end it. Anything between these delimiters is a comment, and it can span multiple lines.

    /*
    This section of the query updates the price of a specific product.
    It targets products that have been on sale for more than 30 days
    and resets their price to the original value.
    */
    UPDATE Products
    SET Price = OriginalPrice
    WHERE ProductID = 123 AND SaleEndDate < GETDATE() - 30;

    

  
8. Add CategoryID column to the Products table.
  
  ALTER TABLE Products
  ADD CategoryID INT;
  
9. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.

  CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50) UNIQUE NOT NULL);

  Explanation:
  CategoryID → PRIMARY KEY (unique & non-null).
  
  CategoryName → VARCHAR(50) (max 50 chars), must be unique and non-null.
  
  This ensures:
  * No duplicate CategoryID or CategoryName.
  * No missing (NULL) values in either column.


10. Explain the purpose of the IDENTITY column in SQL Server.
  Automatically generates sequential numbers for unique row IDs (like auto-increment).
  
  Key Features:
   Automatic numbering – No manual ID management.
   Efficient for joins/indexes – Best with integer PKs.
   One per table – Only one IDENTITY column allowed.
   Gaps possible – Rollbacks/restarts may skip numbers.

    CREATE TABLE TableName (
    ID INT IDENTITY(1,1) PRIMARY KEY, -- Start at 1, increment by 1
    Name VARCHAR(100) NOT NULL);

    Usually paired with PRIMARY KEY.
    Use SET IDENTITY_INSERT ON to manually insert IDs.
    Not guaranteed to be gap-free.
    Ideal for surrogate keys in database tables.
      
________________________________________

## 🟠 Medium-Level Tasks (10)
11. Use BULK INSERT to import data from a text file into the Products table.
  Steps to execute:
  Create the products_data.txt file: Save the content provided above into a file named products_data.txt in the C:\Temp\ directory (or adjust the path in the BULK INSERT statement accordingly).
  Ensure SQL Server has permissions: Make sure the SQL Server service account has read access to the C:\Temp\ directory and the products_data.txt file. If not, the BULK INSERT command will fail with a permission error.
  Execute the SQL command: Run the BULK INSERT statement in SQL Server Management Studio (SSMS) or any other SQL client connected to your SQL Server instance.
  After execution, the three records from your text file will be inserted into the Products table. You can verify this by running:
  
      query:
  SELECT * FROM Products;
      
12. Create a FOREIGN KEY in the Products table that references the Categories table.
  Products table:
  CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) UNIQUE,
    Price DECIMAL(10, 2),
    CategoryID INT);
  
  Categories table:

  CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE NOT NULL);

  ALTER TABLE Products
  ADD CONSTRAINT FK_Products_Categories
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
      
13. Explain the differences between PRIMARY KEY and UNIQUE KEY.

                PK vs UNIQUE Key
Feature	  PRIMARY KEY	        UNIQUE KEY
Purpose   Main row identifier	Ensures unique values
NULLs 	  Not allowed	Allows one NULL
Per Table	One only	Multiple allowed
Index	    Clustered (default)	Non-clustered (default)
When to Use:
PK: For mandatory unique IDs (ID, OrderNo)

Unique: For optional unique fields (Email, SSN)

Example:

sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY,           
    Email VARCHAR(100) UNIQUE);


  
14. Add a CHECK constraint to the Products table ensuring Price > 0.

Add Price Validation
query
  ALTER TABLE Products
  ADD CONSTRAINT CK_PricePositive CHECK (Price > 0);
What It Does:
 Ensures Price > 0
 Blocks invalid inserts/updates
 Enforces business rules

Example Rejection:

query
  INSERT INTO Products (Price) VALUES (0); -- Fails
 

  
15. Modify the Products table to add a column Stock (INT, NOT NULL).

    ALTER TABLE Products
    ADD Stock INT NOT NULL DEFAULT 0;
 
    Adds Stock column (integer, required)
  
    Sets 0 for existing rows
  
    Future inserts default to 0 if value not provided

16. Use the ISNULL function to replace NULL values in Price column with a 0.
SELECT
    ProductID,
    ProductName,
    ISNULL(Price, 0) AS Price, -- If Price is NULL, show 0; otherwise show actual Price
    CategoryID,
    Stock
FROM
    Products;

Using UPDATE with ISNULL (to permanently change NULL values to 0):
  
  UPDATE Products
  SET Price = ISNULL(Price, 0)
  WHERE Price IS NULL;

Explanation:

UPDATE Products SET Price = ISNULL(Price, 0): For each row, this sets the Price column to the result of ISNULL(Price, 0). 
If the current Price is NULL, it will be replaced by 0. If it is not NULL, it will retain its current value.
WHERE Price IS NULL;: This WHERE clause is an optimization. It tells SQL Server to only perform the UPDATE operation on rows where Price is currently NULL. 
This makes the update more efficient as it does not process rows that already have a non-NULL price.



17. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.

  Purpose
 Links tables (child→parent)
 Ensures valid references
 Prevents orphaned records

Syntax
query

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
);


ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
Key Rules
Parent column must be PK or UNIQUE

Prevents invalid inserts/updates

Optional actions:

ON DELETE CASCADE (auto-delete children)

ON DELETE SET NULL

________________________________________

## 🔴 Hard-Level Tasks (10)
18. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
  CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1), 
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL, 
    Age INT,
    
    CONSTRAINT CK_Customers_AgeMinimum CHECK (Age >= 18),
    PhoneNumber VARCHAR(20)
);

  
19. Create a table with an IDENTITY column starting at 100 and incrementing by 10.
  
  CREATE TABLE Orders (
      OrderID INT IDENTITY(100, 10) PRIMARY KEY, 
      OrderDate DATE NOT NULL,
      CustomerID INT NOT NULL,
      TotalAmount DECIMAL(10, 2)
  );
  
20. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.

    CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,     
    ProductID INT NOT NULL,   
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    LineTotal AS (Quantity * UnitPrice), 

    
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);
  
21. Explain the use of COALESCE and ISNULL functions for handling NULL values.

  In SQL Server, both COALESCE and ISNULL are functions used to handle NULL values by returning an alternative value when a given expression evaluates to NULL. 
  While they serve a similar purpose, they have key differences in their behavior, flexibility, and adherence to SQL standards.

COALESCE Function
Purpose:
The COALESCE function evaluates its arguments in order and returns the first non-NULL expression. 
It is a highly flexible function because it can take multiple arguments.

Syntax:COALESCE (expression1, expression2, ..., expressionN)

ISNULL Function
Purpose:
The ISNULL function replaces NULL with the specified replacement value. It is simpler and designed specifically for handling NULLs for a single expression.

Syntax:ISNULL (check_expression, replacement_value)
  
22. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.

  CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1), 
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL, 
    PhoneNumber VARCHAR(20),
    HireDate DATE NOT NULL DEFAULT GETDATE(), 
    Salary DECIMAL(10, 2) CHECK (Salary >= 0) 
);
  
  
23. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName VARCHAR(50) UNIQUE NOT NULL
);


INSERT INTO Departments (DeptName) VALUES ('Sales'), ('Marketing'), ('IT');

-- Option A: Creating the table with the FK constraint
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DeptID INT, -- This will be our Foreign Key
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (DeptID)
    REFERENCES Departments(DeptID)
    ON DELETE CASCADE   -- If a Department is deleted, delete its Employees
    ON UPDATE CASCADE    -- If a DeptID changes, update it in Employees
);


INSERT INTO Employees (FirstName, LastName, DeptID) VALUES
('Alice', 'Smith', 1), -- Sales
('Bob', 'Johnson', 2), -- Marketing
('Charlie', 'Brown', 1), -- Sales
('Diana', 'Prince', 3); -- IT

On delete cascade
DELETE FROM Departments WHERE DeptID = 1; 

On update cascade

INSERT INTO Departments (DeptName) VALUES ('New Dept'); 
INSERT INTO Employees (FirstName, LastName, DeptID) VALUES ('Frank', 'Green', (SELECT DeptID FROM Departments WHERE DeptName = 'New Dept'));
SELECT * FROM Departments;
SELECT * FROM Employees;
