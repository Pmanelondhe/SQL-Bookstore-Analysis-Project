--Create Database 
CREATE DATABASE Onlinebookstore;

--Create tables Books,customers And orders

--DROP TABLE If EXISTS Books;

CREATE TABLE Books(
	Book_ID	SERIAL	Primary Key,
	Title  VARCHAR (100),
	Author	VARCHAR	(100),
	Genre	VARCHAR	(100),	
	Published_Year	INT,		
	Price	NUMERIC(10,2),	
	Stock	INT		
);

--DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers(
	Customer_ID	SERIAL	PRIMARY KEY,
	Name	VARCHAR(100),	
	Email	VARCHAR(100),	
	Phone	VARCHAR(15),
	City	VARCHAR(50),
	Country	VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders(
	Order_ID	SERIAL 	PRIMARY KEY,		
	Customer_ID	INT REFERENCES Customers(Customer_ID),		
	Book_ID	INT	REFERENCES Books(Book_ID),
	Order_Date	DATE,			
	Quantity	INT,			
	Total_Amount NUMERIC(10,2)			
);


--Import csv files

COPY Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'E:\Data analytics cource\Github and resume projects\SQL dataset\Books.csv'
CSV HEADER;

COPY Customers(Customer_ID,Name,Email,Phone,City,Country)
FROM 'E:\Data analytics cource\Github and resume projects\SQL dataset\Customers.csv'
CSV HEADER;

COPY Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM 'E:\Data analytics cource\Github and resume projects\SQL dataset\Orders.csv'
CSV HEADER;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
where genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
where published_year>=1950
order by published_year asc;

-- 3) List all customers from the Canada:
SELECT * FROM CUSTOMERS
WHERE country='Canada';


-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY order_date asc;

 
-- 5) Retrieve the total stock of books available:
SELECT  sum(stock) as total_stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM BOOKS
ORDER BY PRICE DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM orders
WHERE quantity>=1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE total_amount>=20
order by total_amount ASC;

-- 9) List all genres available in the Books table:

SELECT  DISTINCT(genre) FROM Books;


-- 10) Find the book with the lowest stock:
SELECT * FROM books 
ORDER BY stock ASC
LIMIT 1;



-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(total_amount) AS Total_Revenue
FROM orders;



-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT * FROM orders
SELECT * FROM Books

SELECT b.genre,SUM(o.quantity) AS sold_book
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
 SELECT genre, AVG(PRICE) AS avg_price 
 FROM books
 WHERE genre='Fantasy'
 group by genre;


-- 3) List customers who have placed at least 2 orders:


SELECT customer_id, COUNT(order_id) as total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)=2

SELECT c.customer_id,c.name,COUNT(o.order_id) AS total_orders
FROM orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id 
HAVING COUNT(order_id)>=2;


-- 4)Find the most frequentaly ordered book?
SELECT book_id,count(order_id) as total_order
FROM orders
GROUP BY book_id
ORDER BY count(order_id) DESC
LIMIT 1;

SELECT b.Book_id,b.title,COUNT(o.order_id) as total_orders
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.book_id
ORDER BY COUNT(order_id) DESC
LIMIT 1;

--5)show top 3 expesnsive books of 'fantasy' genre.

SELECT * FROM books
WHERE genre='Fantasy'
ORDER BY price desc
LIMIT 3;

--6) Retrive the total quantity of book sold by each author?
SELECT b.author,SUM(o.quantity) AS total_sold_book
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author
ORDER BY SUM(o.quantity) DESC;

SELECT * FROM ORDERS

--7)List the cities where customers who spent over $30 are located?
SELECT * FROM customers

SELECT DISTINCT(c.city),total_amount 
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE total_amount>30;

--8)Find the customer who spent the most on orders

SELECT c.customer_id,c.name, SUM(o.total_amount) AS total_spent 
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spent DESC
LIMIT 1;

--9)Calculate the stock remaining after all fulfill all oreders?

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;