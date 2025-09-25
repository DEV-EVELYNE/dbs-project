📦 E-commerce Store Database
📌 Overview

This project implements a full-featured relational database for an E-commerce Store using MySQL 8.
It manages customers, suppliers, products, categories, orders, carts, inventory, payments, and shipping.

The schema follows best practices with:

✅ Well-structured tables

✅ Primary & Foreign keys

✅ One-to-One, One-to-Many, and Many-to-Many relationships

✅ Constraints (NOT NULL, UNIQUE, CHECK)

✅ Indexes for performance

✅ Sample data inserts

🏗️ Database Schema
1. Customers & Addresses

Customers can have multiple saved addresses.

Address linked via customer_id.

2. Suppliers & Products

Products are supplied by suppliers.

Each product belongs to one or more categories.

Products can have multiple images.

3. Categories

Products are organized into categories (e.g., Electronics, Clothing).

Many-to-Many relationship handled by product_categories.

4. Orders & Order Items

Customers place orders.

Each order contains multiple items.

Order status is tracked (pending, shipped, delivered, cancelled).

5. Cart System

Each customer has one cart.

A cart can contain multiple products.

6. Inventory Management

Tracks stock levels for each product.

Prevents negative stock via constraints.

7. Payments & Shipping

Orders are linked to payments.

Orders are also linked to shipping info.

8. Coupons & Discounts

Many-to-Many relationship between orders and coupons.

🔑 Relationships

One-to-One:

Customer ↔ Cart

One-to-Many:

Customer → Orders

Order → Order Items

Product → Product Images

Many-to-Many:

Products ↔ Categories

Orders ↔ Coupons

⚙️ Features

Enforces referential integrity with foreign keys.

Uses CHECK constraints for valid values (e.g., non-negative prices).

Automatic timestamps with created_at and updated_at.

Cascading updates/deletes for related data.

📂 File Structure
📦 ecommerce_store_db
 ┣ 📜 ecommerce_store.sql   # Full database schema + inserts
 ┗ 📜 README.md             # Documentation (this file)

How to use
Open MySQL client or phpMyAdmin.

Run the SQL file:

mysql -u root -p < ecommerce_store.sql


The database will be created as ecommerce_store.

Use it:

USE ecommerce_store;
SHOW TABLES;

📊 Sample Data

The SQL file includes sample inserts for quick testing:

👤 Customers (John Doe, Jane Smith)

🏬 Supplier (Tech World Ltd.)

📦 Products (Smartphone, Laptop)

📂 Categories (Electronics, Clothing)

🛒 Orders & Cart items

⚠️ Notes

If you see a warning about INT display width → it’s safe to ignore in MySQL 8.

For a clean version with no warnings, use INT UNSIGNED instead of INT(11).
