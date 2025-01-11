# Join problems in SQL

This exploration is based on a blog post by Alex Petralia entitled [Preventing common analytical errors: Join duplicates and join misses](https://alexpetralia.com/2017/07/19/more-dangerous-subtleties-of-joins-in-sql/).

He discusses two major semantic errors, both of which occur during SQL joins:

1. Join duplications
2. Join misses

## Tables

```sql
CREATE TABLE OR REPLACE sales AS SELECT * FROM 'sales.tsv';
CREATE TABLE OR REPLACE products AS SELECT * FROM 'products.tsv';
```

__sales__

|    date    |   product    | customer | quantity |
|------------|--------------|----------|---------:|
| 2017-07-01 | Stapler      | Alice    | 1        |
| 2017-07-01 | Tissues      | James    | 3        |
| 2017-07-05 | Soap         | Kevin    | 2        |
| 2017-07-06 | Tissues      | Kelly    | 2        |
| 2017-07-06 | Pack of pens | Richard  | 3        |

__products__

|   product    | price | creation_date_utc |
|--------------|------:|-------------------|
| Stapler      | 4.5   | 2017-07-01        |
| Tissues      | 2.75  | 2017-07-01        |
| Soap         | 3.5   | 2017-07-01        |
| Pack of pens | 2.5   | 2017-07-01        |
| Tissues      | 3.0   | 2017-08-01        |


## Join duplications

```sql
SELECT *, (s.quantity * p.price) AS revenue 
FROM sales s
LEFT JOIN products p ON s.product = p.product;
```

produces this output:


|    date    |   product    | customer | quantity |   product    | price | creation_date_utc | revenue |
|------------|--------------|----------|---------:|--------------|------:|-------------------|--------:|
| 2017-07-01 | Stapler      | Alice    | 1        | Stapler      | 4.5   | 2017-07-01        | 4.5     |
| 2017-07-01 | Tissues      | James    | 3        | Tissues      | 3.0   | 2017-08-01        | 9.0     |
| 2017-07-05 | Soap         | Kevin    | 2        | Soap         | 3.5   | 2017-07-01        | 7.0     |
| 2017-07-06 | Tissues      | Kelly    | 2        | Tissues      | 3.0   | 2017-08-01        | 6.0     |
| 2017-07-06 | Pack of pens | Richard  | 3        | Pack of pens | 2.5   | 2017-07-01        | 7.5     |
| 2017-07-01 | Tissues      | James    | 3        | Tissues      | 2.75  | 2017-07-01        | 8.25    |
| 2017-07-06 | Tissues      | Kelly    | 2        | Tissues      | 2.75  | 2017-07-01        | 5.5     |


```sql
SELECT SUM(s.quantity * p.price) AS revenue 
FROM sales s
LEFT JOIN products p ON s.product = p.product;
```

produces the erroneous result:

| revenue |
|--------:|
| 47.75   |


## Join misses

```sql
CREATE OR REPLACE TABLE sales AS SELECT * FROM 'sales1.tsv';
CREATE OR REPLACE TABLE product_cost AS SELECT * FROM 'product_cost_code.tsv';
```

The SQL:

```sql
SELECT *, (quantity * product_cost) AS total_cost
FROM sales s
LEFT JOIN product_costs c ON s.product_cost_code = c.product_cost_code;
```
Produces the following


|    date    |   product    | product_cost_code | quantity | product_cost_code | product_cost |     total_cost     |
|------------|--------------|-------------------|---------:|-------------------|-------------:|-------------------:|
| 2017-07-01 | Stapler      | J                 | 1        | J                 | 1.8          | 1.8                |
| 2017-07-01 | Tissues      | T                 | 3        | T                 | 0.6          | 1.7999999999999998 |
| 2017-07-05 | Soap         | R                 | 2        | R                 | 2.1          | 4.2                |
| 2017-07-06 | Tissues      | T                 | 2        | T                 | 0.6          | 1.2                |
| 2017-07-06 | Pack of pens | X                 | 3        |                   |              |                    |
