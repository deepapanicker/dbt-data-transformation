# dbt Data Transformation Project

A dbt (data build tool) project for transforming data in your data warehouse. This project demonstrates best practices for building modular, testable, and documented data transformations using SQL and Jinja templating.

## 🎯 Features

- **Modular Transformations**: Reusable models and macros
- **Data Testing**: Built-in data quality tests
- **Documentation**: Auto-generated documentation
- **Incremental Models**: Efficient incremental loading strategies
- **Snapshots**: Track historical changes in source data
- **Multi-Environment**: Support for dev, staging, and production

## 📋 Prerequisites

- Python 3.8+
- dbt-core 1.0+
- Access to data warehouse (BigQuery, Redshift, Snowflake, etc.)

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/deepapanicker/dbt-data-transformation.git
cd dbt-data-transformation
```

### 2. Create virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure profiles

Edit `~/.dbt/profiles.yml`:

```yaml
data_warehouse:
  target: dev
  outputs:
    dev:
      type: bigquery  # or redshift, snowflake
      method: service-account
      project: your-project-id
      dataset: analytics_dev
      keyfile: /path/to/service-account.json
    prod:
      type: bigquery
      method: service-account
      project: your-project-id
      dataset: analytics_prod
      keyfile: /path/to/service-account.json
```

## 📁 Project Structure

```
dbt-data-transformation/
├── models/
│   ├── staging/          # Staging models (raw data cleanup)
│   │   ├── stg_customers.sql
│   │   └── stg_orders.sql
│   ├── intermediate/     # Intermediate transformations
│   │   ├── int_customer_metrics.sql
│   │   └── int_order_summary.sql
│   └── marts/           # Final business logic models
│       ├── customers.sql
│       ├── orders.sql
│       └── customer_orders.sql
├── macros/              # Reusable SQL macros
│   ├── generate_surrogate_key.sql
│   └── pivot_columns.sql
├── tests/               # Custom data tests
│   └── assert_positive_amount.sql
├── snapshots/           # Source data snapshots
│   └── customers_snapshot.sql
├── seeds/               # CSV seed files
│   └── country_codes.csv
├── dbt_project.yml      # Project configuration
└── README.md
```

## 🚀 Usage

### Run all models

```bash
dbt run
```

### Run specific models

```bash
dbt run --select customers orders
```

### Run tests

```bash
dbt test
```

### Generate documentation

```bash
dbt docs generate
dbt docs serve
```

### Run incremental models

```bash
dbt run --select +incremental_models
```

## 📊 Example Models

### Staging Model

```sql
-- models/staging/stg_customers.sql
{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw', 'customers') }}
),

cleaned as (
    select
        customer_id,
        trim(lower(email)) as email,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        date_of_birth,
        created_at,
        updated_at
    from source
    where email is not null
)

select * from cleaned
```

### Mart Model

```sql
-- models/marts/customers.sql
{{ config(materialized='table') }}

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_metrics as (
    select
        c.customer_id,
        c.email,
        c.first_name,
        c.last_name,
        count(o.order_id) as total_orders,
        sum(o.amount) as total_spent,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date
    from customers c
    left join orders o on c.customer_id = o.customer_id
    group by 1, 2, 3, 4
)

select * from customer_metrics
```

## 🧪 Testing

### Built-in Tests

```yaml
# dbt_project.yml
models:
  - name: customers
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
      - name: email
        tests:
          - not_null
          - unique
```

### Custom Tests

```sql
-- tests/assert_positive_amount.sql
select *
from {{ ref('orders') }}
where amount < 0
```

## 📝 Documentation

```yaml
# models/marts/customers.yml
version: 2

models:
  - name: customers
    description: "Customer metrics and aggregations"
    columns:
      - name: customer_id
        description: "Unique customer identifier"
      - name: total_orders
        description: "Total number of orders placed"
```

## 🔄 Incremental Models

```sql
-- models/marts/incremental_orders.sql
{{ config(
    materialized='incremental',
    unique_key='order_id',
    on_schema_change='append_new_columns'
) }}

select
    order_id,
    customer_id,
    order_date,
    amount,
    status
from {{ ref('stg_orders') }}

{% if is_incremental() %}
    where order_date > (select max(order_date) from {{ this }})
{% endif %}
```

## 📸 Snapshots

```sql
-- snapshots/customers_snapshot.sql
{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols=['email', 'first_name', 'last_name'],
    )
}}

select * from {{ source('raw', 'customers') }}

{% endsnapshot %}
```

## 🔧 Macros

```sql
-- macros/generate_surrogate_key.sql
{% macro generate_surrogate_key(field_list) %}
    {{ dbt_utils.generate_surrogate_key(field_list) }}
{% endmacro %}
```

## 📚 Best Practices

1. **Staging Layer**: Clean and standardize raw data
2. **Intermediate Layer**: Build reusable transformations
3. **Marts Layer**: Final business logic models
4. **Testing**: Test at every layer
5. **Documentation**: Document all models and columns
6. **Incremental**: Use incremental models for large tables
7. **Modularity**: Use macros for reusable logic

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📝 License

MIT License

## 👤 Author

**Deepa Govinda Panicker**

- GitHub: [@deepapanicker](https://github.com/deepapanicker)
- Portfolio: [deepapanicker.com](https://deepapanicker.com)

