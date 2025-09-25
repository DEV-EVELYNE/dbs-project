-- ecommerce_store.sql
-- FULL E-COMMERCE STORE DATABASE WITH DATA

CREATE DATABASE ecommerce_store CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE ecommerce_store;

-- ================================================================
-- Customers
-- ================================================================
CREATE TABLE customers (
  customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(30),
  password_hash VARCHAR(255) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO customers (first_name, last_name, email, phone, password_hash)
VALUES 
('Alice','Mwangi','alice@example.com','+254700000001','hashedpassword123'),
('Brian','Otieno','brian.otieno@example.com','+254700000002','hashedpass456'),
('Catherine','Kamau','catherine.k@example.com','+254700000003','hashedpass789');

-- ================================================================
-- Addresses
-- ================================================================
CREATE TABLE addresses (
  address_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL,
  label VARCHAR(50),
  street VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100),
  postal_code VARCHAR(20),
  country VARCHAR(100) NOT NULL,
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO addresses (customer_id, label, street, city, state, postal_code, country, is_default)
VALUES
(1,'Home','123 Nairobi Street','Nairobi','Nairobi','00100','Kenya',1),
(2,'Work','45 Moi Avenue','Mombasa','Mombasa','80100','Kenya',1),
(3,'Home','77 Kenyatta Road','Kisumu','Kisumu','40100','Kenya',1);

-- ================================================================
-- Suppliers
-- ================================================================
CREATE TABLE suppliers (
  supplier_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  contact_email VARCHAR(255),
  contact_phone VARCHAR(30),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO suppliers (name, contact_email, contact_phone)
VALUES
('Acme Supplies','contact@acme.com','+254700111222'),
('TechWorld Ltd','support@techworld.com','+254700333444');

-- ================================================================
-- Categories
-- ================================================================
CREATE TABLE categories (
  category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(120) NOT NULL UNIQUE,
  parent_id INT UNSIGNED DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES categories(category_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO categories (name, slug, parent_id)
VALUES
('Electronics','electronics',NULL),
('Accessories','accessories',1),
('Books','books',NULL);

-- ================================================================
-- Products
-- ================================================================
CREATE TABLE products (
  product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(64) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
  weight_kg DECIMAL(8,3),
  active TINYINT(1) NOT NULL DEFAULT 1,
  supplier_id INT UNSIGNED,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO products (sku, name, description, price, weight_kg, supplier_id)
VALUES
('SKU-001','Wireless Headphones','High quality Bluetooth headphones',79.99,0.25,1),
('SKU-002','Smartphone X200','Latest model smartphone with 128GB storage',299.99,0.35,2),
('SKU-003','USB-C Charger','Fast charging 25W USB-C adapter',19.99,0.10,1),
('SKU-004','Programming in Python','Educational book on Python programming',29.99,0.50,2);

-- ================================================================
-- Product <-> Category (many-to-many)
-- ================================================================
CREATE TABLE product_categories (
  product_id INT UNSIGNED NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (product_id, category_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO product_categories (product_id, category_id)
VALUES
(1,1), -- Headphones → Electronics
(2,1), -- Smartphone → Electronics
(3,2), -- Charger → Accessories
(4,3); -- Book → Books

-- ================================================================
-- Inventory
-- ================================================================
CREATE TABLE inventory (
  inventory_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  product_id INT UNSIGNED NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  safety_stock INT NOT NULL DEFAULT 0,
  last_restocked DATETIME,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY uq_inventory_product (product_id)
) ENGINE=InnoDB;

INSERT INTO inventory (product_id, quantity, safety_stock, last_restocked)
VALUES
(1,50,5,NOW()),
(2,30,3,NOW()),
(3,100,10,NOW()),
(4,20,2,NOW());

-- ================================================================
-- Orders
-- ================================================================
CREATE TABLE orders (
  order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_number VARCHAR(50) NOT NULL UNIQUE,
  customer_id INT UNSIGNED NOT NULL,
  billing_address_id INT UNSIGNED,
  shipping_address_id INT UNSIGNED,
  subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
  shipping_cost DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (shipping_cost >= 0),
  discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
  tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (tax_amount >= 0),
  total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
  status ENUM('pending','paid','processing','shipped','delivered','cancelled','refunded') NOT NULL DEFAULT 'pending',
  placed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (billing_address_id) REFERENCES addresses(address_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO orders (order_number, customer_id, billing_address_id, shipping_address_id, subtotal, shipping_cost, discount_amount, tax_amount, total, status)
VALUES
('ORD-1001',1,1,1,79.99,5.00,0.00,0.00,84.99,'paid'),
('ORD-1002',2,2,2,319.98,10.00,20.00,0.00,309.98,'processing');

-- ================================================================
-- Order Items
-- ================================================================
CREATE TABLE order_items (
  order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  sku_snapshot VARCHAR(64) NOT NULL,
  product_name_snapshot VARCHAR(255) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price >= 0),
  quantity INT UNSIGNED NOT NULL CHECK (quantity > 0),
  line_total DECIMAL(14,2) NOT NULL CHECK (line_total >= 0),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO order_items (order_id, product_id, sku_snapshot, product_name_snapshot, unit_price, quantity, line_total)
VALUES
(1,1,'SKU-001','Wireless Headphones',79.99,1,79.99),
(2,2,'SKU-002','Smartphone X200',299.99,1,299.99),
(2,3,'SKU-003','USB-C Charger',19.99,1,19.99);

-- ================================================================
-- Done
-- ================================================================
