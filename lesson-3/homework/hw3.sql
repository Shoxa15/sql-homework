Easy-Level Tasks
-- 1. BULK INSERT используется для импорта больших объёмов данных из файла в таблицу SQL Server
-- Пример (не работает без реального файла):
BULK INSERT Products
FROM 'C:\Data\products.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
-- 2. Распространённые форматы файлов для импорта в SQL Server:
-- .csv, .txt, .xls, .xml

-- 3. Создать таблицу Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 4. Вставить три записи в таблицу Products
INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.99),
(3, 'Keyboard', 45.50);

-- 5. NULL означает отсутствие значения; NOT NULL означает, что значение должно быть обязательно
-- Пример:
-- ProductDescription VARCHAR(100) NULL
-- ProductCode VARCHAR(20) NOT NULL

-- 6. Добавить ограничение UNIQUE на колонку ProductName
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- 7. Пример комментария в SQL:
-- Этот запрос выбирает все товары, у которых цена выше 100
SELECT * FROM Products WHERE Price > 100;

-- 8. Добавить колонку CategoryID
ALTER TABLE Products
ADD CategoryID INT;

-- 9. Создать таблицу Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

-- 10. Колонка IDENTITY автоматически увеличивает значение
-- Пример таблицы с IDENTITY:
CREATE TABLE ExampleTableWithIdentity (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Description VARCHAR(100)
);
