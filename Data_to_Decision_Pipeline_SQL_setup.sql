use pipeline;
Create table products (
						product_id varchar(20) Primary Key , 
                        product_name varchar(100) Not Null,
                        category varchar(20) Not Null,
                        sub_category varchar(20) Not Null
                        );
Create table customers ( 
						customer_id varchar(20) Primary Key ,
                        customer_name varchar(25) ,
                        segment varchar(20) Not Null
                        );
Create table locations (
						location_id int Primary Key ,
                        city varchar(30) Not Null,
                        state varchar(25) Not Null,
                        country varchar(25) Not Null,
                        region varchar(25) Not Null,
                        market varchar(25) Not Null
                        );
Create table logistics ( 
						log_id int Primary Key ,
                        order_priority Enum('Critical','High','Medium','Low'),
                        ship_mode varchar(20) 
                        );
Create table fact (
					transaction_id int Primary Key,
                    order_id int Not Null,
                    order_date date Not Null,
                    ship_date date Not Null,
                    sales bigint Not Null,
                    quantity int Not Null, 
                    discount float ,
                    profit float Not Null,
                    shipping_cost float Not Null,
                    gross_sales bigint Not Null,
                    COGS bigint Not Null,
                    unit_price int Not Null,
                    customer_id varchar(25) ,
                    product_id varchar(25) , 
                    location_id int,
                    log_id int ,
                    
                    foreign key (customer_id) references customers(customer_id),
                    foreign key (product_id) references products(product_id) ,
                    foreign key (location_id) references locations(location_id) ,
                    foreign key (log_id) references logistics(log_id) 
                    );
		
