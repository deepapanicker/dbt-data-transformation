# dbt Data Transformation

A comprehensive dbt project for transforming raw data into analytics-ready models. This project demonstrates best practices for data transformation using dbt, including staging, intermediate, and mart models.

## 🎯 Features

- **Staging Models**: Clean and standardize raw data
- **Intermediate Models**: Build business logic and aggregations
- **Mart Models**: Final analytics-ready tables
- **Custom Macros**: Reusable SQL functions
- **Data Tests**: Ensure data quality at every layer
- **Snapshots**: Track historical changes to source data
- **Seeds**: Reference data management

## 📋 Prerequisites

- Python 3.8+
- dbt-core installed
- Database connection (PostgreSQL, BigQuery, Snowflake, Redshift, etc.)
- Access to source data tables

## 🛠️ Installation

### 1. Install dbt

```bash
pip install dbt-core
# For specific adapters:
pip install dbt-postgres  # PostgreSQL
pip install dbt-bigquery  # BigQuery
pip install dbt-snowflake # Snowflake
pip install dbt-redshift  # Redshift
```

### 2. Install dbt packages

```bash
dbt deps
```

### 3. Configure profiles

Copy `profiles.yml.example` to `~/.dbt/profiles.yml` and configure your database connection.

### 4. Install dependencies

```bash
dbt deps
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
│   ├── marts/           # Final business logic models
│   │   ├── customers.sql
│   │   ├── orders.sql
│   │   └── customer_orders.sql
│   ├── sources.yml      # Source table definitions
│   └── schema.yml       # Model documentation and tests
├── macros/              # Reusable SQL macros
│   ├── generate_surrogate_key.sql
│   └── pivot_columns.sql
├── tests/               # Custom data tests
│   └── assert_positive_amount.sql
├── snapshots/           # Source data snapshots
│   └── customers_snapshot.sql
├── seeds/               # CSV seed files
│   └── country_codes.csv
├── examples/            # Example scripts
│   ├── run_dbt_example.sh
│   ├── incremental_model_example.sql
│   └── README.md
├── dbt_project.yml      # Project configuration
├── profiles.yml.example # Database connection template
└── README.md
```

## 🚀 Quick Start

### 1. Run all models

```bash
dbt run
```

### 2. Run tests

```bash
dbt test
```

### 3. Build (run + test)

```bash
dbt build
```

### 4. Generate documentation

```bash
dbt docs generate
dbt docs serve
```

## 📊 Model Layers

### Staging Layer (`models/staging/`)

Staging models clean and standardize raw data:
- Data type conversions
- Field renaming and standardization
- Null handling
- Basic data quality checks

**Example:**
```sql
-- stg_customers.sql
select
    customer_id,
    trim(upper(first_name)) as first_name,
    trim(lower(email)) as email,
    date(created_at) as created_date
from {{ source('raw', 'customers') }}
```

### Intermediate Layer (`models/intermediate/`)

Intermediate models build business logic:
- Aggregations
- Joins between staging models
- Business metric calculations
- Complex transformations

**Example:**
```sql
-- int_customer_metrics.sql
select
    c.customer_key,
    count(distinct o.order_id) as total_orders,
    sum(o.total_amount) as total_revenue
from {{ ref('stg_customers') }} c
left join {{ ref('stg_orders') }} o
    on c.customer_id = o.customer_id
group by c.customer_key
```

### Mart Layer (`models/marts/`)

Mart models are final analytics-ready tables:
- Denormalized for easy querying
- Business-friendly column names
- Pre-calculated metrics
- Optimized for BI tools

**Example:**
```sql
-- customers.sql
select
    customer_key,
    full_name,
    customer_status,
    customer_segment,
    total_revenue,
    total_orders
from {{ ref('int_customer_metrics') }}
```

## 🔧 Macros

### `generate_surrogate_key`

Generate surrogate keys from field lists:

```sql
{{ generate_surrogate_key(['customer_id']) }} as customer_key
```

### `pivot_columns`

Pivot columns dynamically:

```sql
select
    customer_id,
    {{ pivot_columns('status', ['completed', 'cancelled'], 'count') }}
from orders
group by customer_id
```

## 🧪 Testing

### Built-in Tests

```yaml
models:
  - name: customers
    columns:
      - name: customer_key
        tests:
          - unique
          - not_null
      - name: email
        tests:
          - unique
```

### Custom Tests

```sql
-- tests/assert_positive_amount.sql
select * from {{ ref('orders') }}
where order_amount < 0
```

### Run Tests

```bash
# All tests
dbt test

# Specific model
dbt test --select customers

# Custom tests only
dbt test --select test_type:custom
```

## 📸 Snapshots

Track historical changes to source data:

```sql
{% snapshot customers_snapshot %}
    {{
        config(
            unique_key='customer_id',
            strategy='check',
            check_cols=['email', 'phone']
        )
    }}
    select * from {{ source('raw', 'customers') }}
{% endsnapshot %}
```

Run snapshots:
```bash
dbt snapshot
```

## 🌱 Seeds

Load reference data from CSV files:

```bash
dbt seed
```

## 📝 Examples

See the `examples/` directory for:
- Common dbt workflows (`run_dbt_example.sh`)
- Incremental model example (`incremental_model_example.sql`)
- Usage documentation (`README.md`)

## 🔍 Documentation

Generate and view documentation:

```bash
# Generate docs
dbt docs generate

# Serve docs locally
dbt docs serve
```

Documentation includes:
- Model lineage graphs
- Column descriptions
- Test results
- Source definitions

## 🏗️ Best Practices

1. **Layer Your Models**: Staging → Intermediate → Marts
2. **Use Tags**: Organize models with tags
3. **Document Everything**: Add descriptions to models and columns
4. **Test Early**: Write tests for data quality
5. **Use Macros**: Reuse common SQL patterns
6. **Version Control**: Commit all dbt code to git
7. **Incremental Models**: Use for large tables
8. **Snapshots**: Track historical changes

## 📚 Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [dbt Community](https://www.getdbt.com/community)

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
