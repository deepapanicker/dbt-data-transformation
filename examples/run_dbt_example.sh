#!/bin/bash

# Example script to run dbt commands
# This demonstrates common dbt workflows

echo "=========================================="
echo "dbt Data Transformation - Example Workflow"
echo "=========================================="
echo ""

# 1. Install dbt dependencies
echo "1. Installing dbt dependencies..."
dbt deps
echo ""

# 2. Run all models
echo "2. Running all models..."
dbt run
echo ""

# 3. Run tests
echo "3. Running tests..."
dbt test
echo ""

# 4. Run specific model
echo "4. Running specific model (customers)..."
dbt run --select customers
echo ""

# 5. Run models with specific tag
echo "5. Running staging models..."
dbt run --select tag:staging
echo ""

# 6. Run models and tests together
echo "6. Running models and tests..."
dbt build
echo ""

# 7. Generate documentation
echo "7. Generating documentation..."
dbt docs generate
echo ""

# 8. Serve documentation
echo "8. Documentation generated!"
echo "   Run 'dbt docs serve' to view documentation in browser"
echo ""

# 9. Run snapshots
echo "9. Running snapshots..."
dbt snapshot
echo ""

# 10. Seed data
echo "10. Loading seed data..."
dbt seed
echo ""

echo "=========================================="
echo "Workflow completed!"
echo "=========================================="

