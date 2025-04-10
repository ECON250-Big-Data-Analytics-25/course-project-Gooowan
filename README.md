## 🧠 Final Project Overview

This project is the culmination of an end-to-end dbt pipeline built on top of an e-commerce dataset (originally from Kaggle’s Brazilian Olist marketplace). It follows best practices in modern analytics engineering, including modular staging, testing, documentation, and analytical marts for business users.

---

### 📦 Data Flow Overview

```
Raw Sources (CSV files from Kaggle)
        ↓
  Sources Defined in dbt (`fp_sources.yml`)
        ↓
  Staging Layer (cleaned + typed `stg_fp_*` models)
        ↓
  Fact Layer (`fp_sales_full`): denormalized order-level dataset
        ↓
  Analytical Marts (`mart_*` models): metrics for business insight
        ↓
  Custom Tests + Documentation → BigQuery UI + dbt Docs
```

---

### ✅ Step-by-step Flow

#### 1. **Source Layer**
- All 9 source tables were declared in `fp_sources.yml` with detailed column descriptions from Kaggle.
- Source-level tests were added (e.g. `unique`, `not_null`) for key fields.

#### 2. **Staging Models (`stg_fp_*`)**
- Cleaned raw data, converted data types, handled missing values, and added derived columns (e.g. `is_delivered`, `order_delivery_delay`).
- Each staging model corresponds to one raw table and serves as a contract for downstream transformations.

#### 3. **Fact Table (`fp_sales_full`)**
- A fully denormalized model combining data from multiple sources at the **order level**.
- Uses:
  - `ARRAY<STRUCT>` to aggregate multi-row fields (e.g. payments, order items).
  - Derived fields for time and status logic.
  - Incremental strategy with partitioning on `order_purchase_timestamp`.
- Serves as a **single source of truth** for analytical marts.

#### 4. **Analytical Mart Models**
Each of these models answers specific business questions:

| Model                     | Purpose                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| `fp_fct_order_performance` | Track daily/monthly order count and revenue by status and category.     |
| `fp_fct_customer_behavior` | Identify new vs. returning customers, frequency, and customer value.     |
| `fp_fct_product_performance` | Show top-performing products by category, date, and revenue.            |
| `fp_fct_seller_analytics`  | Analyze seller sales volume and fulfillment delays by month.             |
| `fp_fct_payment_analysis`  | Examine payment type trends, average installments, and regional usage.   |

Each is materialized as a table and intended for reporting, dashboarding, or stakeholder review.

#### 5. **Custom Data Tests**
Two logic-driven tests were added to ensure cross-model consistency:
- Compare **total revenue** between `fp_sales_full` and `fp_fct_order_performance`.
- Check **order count consistency** between `fp_sales_full` and `fp_fct_customer_behavior`.

These tests are located in the `/tests` folder and run with every `dbt test`.

---

### 🚀 Summary

This project demonstrates:
- Clean and testable transformation pipelines
- Analytical modeling aligned with business needs
- Cross-model data validation
- Fully documented data assets for end users

It's production-ready and extensible for further exploration in areas like forecasting, segmentation, or cohort analysis.