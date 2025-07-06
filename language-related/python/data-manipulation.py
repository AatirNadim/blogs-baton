# In your terminal: pip install pandas matplotlib
import pandas as pd
import matplotlib.pyplot as plt

# 1. Load Data
# pandas can read data from CSV, Excel, SQL databases, and more with one line.
raw_data = {
    'order_id': [1, 2, 3, 4, 5, 6],
    'product_category': ['Electronics', 'Groceries', 'Groceries', 'Toys', 'Electronics', 'Toys'],
    'price': [899.99, 15.50, 25.00, 39.95, 129.99, None], # Note the missing value
    'quantity': [1, 3, 2, 1, 1, 2]
}
df = pd.DataFrame(raw_data)
print("--- Raw Data ---")
print(df)

# 2. Clean Data
# A common task is handling missing values. We will remove rows with missing prices.
df.dropna(inplace=True)

# 3. Feature Engineering
# Create a new column 'total_sale' by multiplying price and quantity.
df['total_sale'] = df['price'] * df['quantity']
print("\n--- Cleaned & Enriched Data ---")
print(df)

# 4. Analyze & Aggregate
# Use `groupby` to calculate the total revenue per product category.
# Check out other such functions like `mean()`, `count()`, etc.
category_revenue = df.groupby('product_category')['total_sale'].sum().sort_values(ascending=False)
print("\n--- Revenue by Category ---")
print(category_revenue)

# 5. Visualize
# Create a bar chart of the results with a few lines of code.
plt.figure(figsize=(8, 5))
category_revenue.plot(kind='bar', color='skyblue')
plt.title('Total Revenue by Product Category')
plt.ylabel('Total Revenue ($)')
plt.xticks(rotation=0)
plt.tight_layout()
plt.show() # This will display a chart window
