# Zomato SQL Data Analysis

This repository contains the code and documentation for an Exploratory Data Analysis (EDA) of Zomato data using SQL queries in Python via the *mysql-connector* module. The data is stored in a MySQL database named **zomato**, consisting of several tables.

## Dataset

The dataset comprises multiple tables in the **zomato** database. Here are the details of the tables used for this analysis:

### Table: goldusers_signup

- **userid**: User ID.
- **gold_signup_date**: Date when a user signed up for the Gold membership.

### Table: users

- **userid**: User ID.
- **signup_date**: Date when a user signed up.

### Table: sales

- **userid**: User ID.
- **created_date**: Date when a sale was created.
- **product_id**: Product ID associated with the sale.

### Table: product

- **product_id**: Product ID.
- **product_name**: Name of the product.
- **price**: Price of the product.

## EDA Files

[zomato.ipynb](zomato.ipynb): Jupyter Notebook containing the Python code for the exploratory data analysis of the Zomato data using SQL queries.

[zomato solution (SQL code).sql](zomato%20solution%20(SQL%20code).sql): MySQL script containing the queries for the exploratory data analysis of the Zomato data.

## Usage

You can clone this repository to your local machine and run the Jupyter Notebook to perform the SQL-based EDA. Ensure you have a MySQL server set up with the **zomato** database containing the necessary tables.

```bash
git clone https://github.com/HloHarshit/Zomato-SQL-EDA.git
cd Zomato-SQL-EDA
jupyter notebook zomato.ipynb
```