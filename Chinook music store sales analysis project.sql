#Chinook Music Store: customer and sales insights 
USE chinook;
#1. Identify top 5 customers by total amount spent 
SELECT c.CustomerId,
	   c.FirstName,
       c.LastName,
       c.Email,
       SUM(Total) AS TotalSpent
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Email
ORDER BY TotalSpent DESC
LIMIT 5;

#2. Identify the countries with top sales 
SELECT c.CustomerId,
	   i.BillingAddress,
       i.BillingCountry,
       c.Email,
       SUM(Total) AS TotalSpent
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, i.BillingAddress, i.BillingCountry, c.Email
ORDER BY TotalSpent DESC
LIMIT 5;

#3. What is the most purchased genre by invoice count and revenue?
SELECT COUNT(DISTINCT i.InvoiceId) AS InvoiceCount,
	    g.Name AS GenreName,
	   SUM(il.UnitPrice*il.Quantity) AS Revenue,
       SUM(il.Quantity) AS TotalTrackSold
FROM invoiceline il
JOIN track t
ON il.TrackId = t.TrackId
JOIN genre g
ON t.GenreId = g.GenreId
JOIN invoice i
ON i.InvoiceId = il.InvoiceId
GROUP BY g.name
ORDER BY Revenue DESC, TotalTrackSold DESC
LIMIT 1;

#4. What is the monthly sales trend?
SELECT 
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    SUM(Total) AS MonthlySales
FROM Invoice
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;

#5. Who are the employee(s) associated with the most high-spending customers?
SELECT e.EmployeeId,
	    e.FirstName,
        e.LastName,
        c.FirstName,
        c.LastName,
        SUM(i.Total)
FROM employee e
JOIN customer c
ON e.EmployeeId = c.SupportRepId
JOIN invoice i
ON i.CustomerId = c.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName, c.FirstName, c.LastName
ORDER BY SUM(i.Total) DESC
LIMIT 5;

#6. What are the top 10 tracks sold (by quantity and revenue)?
SELECT t.TrackId,
	   t.name AS TrackName,
	   t.Composer,
       SUM(il.UnitPrice * il.Quantity) AS Revenue,
       SUM(il.Quantity) AS TotalSold
FROM track t
JOIN invoiceline il
ON t.TrackId = il.TrackId
GROUP BY t.TrackId, TrackName, t.Composer
ORDER BY  Revenue DESC, TotalSold DESC
LIMIT 10;

#7. What is the customer distribution by country?
SELECT 
    Country,
    COUNT(*) AS CustomerCount
FROM Customer
GROUP BY Country
ORDER BY CustomerCount DESC;

#8. Average invoice total per country.
SELECT AVG(i.total) TotalAvg,
	   country
FROM invoice i 
JOIN customer c
ON i.CustomerId = c.CustomerId
GROUP BY country 
ORDER BY TotalAvg DESC;

#9. Tracks with the highest unit price.
SELECT 
    TrackId,
    Name AS TrackName,
    Composer,
    UnitPrice
FROM Track
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Track);

#10. How many tracks are in each genre and playlist?
#since the genre and playlist tables cannot be joined the query for this question has to be done seperately 
SELECT g.GenreId, 
       g.Name AS GenreName,
	   COUNT(t.TrackId) AS TrackCount
FROM Track t
JOIN Genre g
ON t.GenreId = g.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY TrackCount DESC;

SELECT p.Name AS PlaylistName,
       COUNT(pt.TrackId) AS TrackCount
FROM Playlist p
JOIN PlaylistTrack pt 
ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId, p.Name
ORDER BY TrackCount DESC;
