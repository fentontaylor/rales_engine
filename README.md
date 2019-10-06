# Rales Engine API

### Setup
1) Fork/Clone git@github.com:fentontaylor/rales_engine.git
2) `bundle`
3) `rake import:all` to import data from csv files into database

### Database Schema
![schema](https://user-images.githubusercontent.com/18686466/66276988-68d27d00-e855-11e9-94b5-bac3bea0c7a2.png)

### Endpoints

**Resources**
All resource endpoints can be queried to return all records or one specific record by id. See the schema above for all the resources available.

- `/api/v1/merchants` will return serailzed JSON of all merchants
- `/api/v1/merchants/23` will return JSON of just the merchant with id 23

**Search Feature**
You can return the first instance or all instances of records that meet the search critera using the `/find` and `/find_all` endpoints. Search endpoints need exactly one query param. All resources can be queried using any of their attributes, including id. For example, merchants can be queried using id, name, created_at, updated_at. See below for examples.
Values for created_at/updated_at must be exactly in the format below. More dynamic searching by date will be added in v2.

- `/api/v1/merchants/find?id=23`
- `/api/v1/merchants/find?name=Willms and Sons`
- `/api/v1/merchants/find?created_at=2012-03-27T14:54:01Z`

- `/api/v1/merchants/find_all?updated_at=2012-03-27T14:54:01Z`
- `/api/v1/items/find_all?merchant_id=23`

**Business Intelligence Endpoints**
*All Merchants*
- `/api/v1/merchants/most_revenue?quantity=x` returns the top x merchants ranked by total revenue
- `/api/v1/merchants/revenue?date=x` returns the total revenue for date x across all merchants

*Single Merchant*
- `/api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions.

*Items*
- `/api/v1/items/most_revenue?quantity=x` returns the top x items ranked by total revenue generated

- `/api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.

*Customers*
- `/api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions
