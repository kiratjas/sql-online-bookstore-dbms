create database library_project;
#parent table--> Authors
create table Authors(author_id int,author_name varchar(25), birth_year int, constraint pri_id primary key(author_id));
INSERT INTO Authors(author_id, author_name, birth_year) VALUES (1, 'J.K.Rowling', 1965), (2, 'George
R.R. Martin', 1948), (3, 'J.R.R. Tolkien', 1892), (4, 'Isaac Asimov', 1920), (5, 'Agatha Christie', 1890);
select * from Authors;

#child table --> Books
create table Books(book_id int,title varchar(30),author_id int,publication_year int,price float4);
alter table Books add primary key(book_id);
INSERT INTO Books (book_id, title, author_id, publication_year, price) VALUES (1,'HarryPotter and SorcererStone', 1, 1997, 19.99), (2,'A Game of Thrones', 2, 1996, 24.99), (3,'The Hobbit', 3, 1937,
14.99), (4,'Foundation', 4, 1951, 29.99), (5, 'Murder on the Orient Express', 5, 1934, 12.99);
alter table Books add constraint athr_id foreign key(author_id) references Authors (author_id);
select * from Books;
#parent table --> customers
create table Customers(customer_id int,customer_name varchar(25),email varchar(30), address varchar(35), constraint c_id primary key(customer_id));
INSERT INTO Customers (customer_id, customer_name, email, address) VALUES (1,'Alice Smith',
'alice.smith@example.com','123 Elm Street'), (2,'Bob Johnson','bob.johnson@example.com', '456 Oak
Avenue'), (3,'Carol Davis','carol.davis@example.com','789 Pine Road'), (4,'David Wilson',
'david.wilson@example.com','101 Maple Lane'), (5,'Eve Brown','eve.brown@example.com','202 Birch Boulevard');

#child table --> Orders
create table Orders(order_id int, customer_id int, order_date date, constraint or_id primary key(order_id));
INSERT INTO Orders (order_id, customer_id, order_date) VALUES(1, 1,'2024-08-01'), (2, 2,'2024-08-02'), (3, 3,'2024-08-03'), (4, 4,'2024-08-04'), (5, 5,'2024-08-05');
alter table Orders add constraint cus_id foreign key(customer_id) references Customers(customer_id);

create table Order_Details(order_detail_id int, order_id int, book_id int, quantity int, constraint or_de_id primary key(order_detail_id));
INSERT INTO Order_Details (order_detail_id, order_id, book_id, quantity) VALUES (1, 1, 1, 2), (2, 1, 3, 1),
(3, 2, 2, 1), (4, 3, 4, 3), (5, 4, 5, 1);
alter table Order_Details add constraint odr_id foreign key(order_id) references Orders(order_id);
alter table Order_Details add constraint bk_id foreign key(book_id) references Books(book_id);
select * from Order_Details;

#1-->List all books along with their authors and prices.
select B.title,B.price,A.author_name from Books as B inner join Authors as A on B.author_id=A.author_id; #done

#2-->Retrieve a list of customers and their order dates.
select customers.customer_name,Orders.order_date from Orders inner join Customers on customers.customer_id=Orders.customer_id; #done

#3-->Calculate the total order amount for each order  #done
select od.order_id,SUM(b.price*od.quantity) as Total_order_amount from Order_Details as od left join 
Books as b on b.book_id=od.book_id group by od.order_id; 

#Find the best-selling book (the book with the most orders). #done
select b.title from Books as b right join order_details as od on b.book_id=od.book_id 
where od.quantity>=(select max(quantity) from order_details);

#Identify the author who has the most books in the bookstore.
select a.author_name from authors as a join books as b on b.author_id=a.author_id where book_id in(
select b.book_id from Books as b right join order_details as od on b.book_id=od.book_id 
where od.quantity>=(select max(quantity) from order_details));

#Create a query to find the top three authors with the most books in the bookstore. List their names and the count of books they have authored.
select a.author_name from authors as a right join Books as b on a.author_id=b.author_id where
book_id in (select b.book_id from Books as b right join order_details as od on b.book_id=od.book_id 
where od.quantity>=(select max(quantity) from order_details));



