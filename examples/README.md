# dbt Examples

This directory contains example scripts and models demonstrating dbt usage.

## Files

### `run_dbt_example.sh`
Bash script showing common dbt commands and workflows.

**Usage:**
```bash
chmod +x examples/run_dbt_example.sh
./examples/run_dbt_example.sh
```

### `incremental_model_example.sql`
Example of an incremental model that only processes new data.

**Key features:**
- Uses `is_incremental()` macro to detect incremental runs
- Filters data based on `_loaded_at` timestamp
- Uses merge strategy for updates

## Common dbt Commands

### Run Models
```bash
# Run all models
dbt run

# Run specific model
dbt run --select customers

# Run models with tag
dbt run --select tag:staging

# Run models and downstream dependencies
dbt run --select customers+
```

### Run Tests
```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test --select customers

# Run custom tests
dbt test --select test_type:custom
```

### Build (Run + Test)
```bash
# Run models and tests together
dbt build

# Build specific model
dbt build --select customers
```

### Documentation
```bash
# Generate documentation
dbt docs generate

# Serve documentation locally
dbt docs serve
```

### Snapshots
```bash
# Run snapshots
dbt snapshot

# Run specific snapshot
dbt snapshot --select customers_snapshot
```

### Seeds
```bash
# Load seed data
dbt seed

# Load specific seed
dbt seed --select country_codes
```

### Dependencies
```bash
# Install dbt packages
dbt deps
```

## Model Development Workflow

1. **Create staging models** - Clean and standardize raw data
2. **Create intermediate models** - Build business logic
3. **Create mart models** - Final business-ready tables
4. **Add tests** - Ensure data quality
5. **Generate documentation** - Document your models

## Best Practices

1. **Use tags** - Organize models with tags (staging, intermediate, marts)
2. **Add descriptions** - Document all models and columns
3. **Write tests** - Test data quality at every layer
4. **Use macros** - Reuse common SQL patterns
5. **Version control** - Commit dbt code to git
6. **Incremental models** - Use for large tables to save compute
7. **Snapshots** - Track historical changes to source data

