"-- Deep analysis
1. Top Reordered Products
2. Days Between Orders Per User
3. Frequently Bought Together
"

-- 1.  Top Reordered Products
""" Purpose: 
1. Inventory planning
2. Promotions for popular items
3. Loyalty program focus
"""

SELECT 
  p.product_name,
  COUNT(*) AS reorder_count
FROM order_products_prior opp
JOIN products p ON p.product_id = opp.product_id
WHERE opp.reordered = 1
GROUP BY p.product_name
ORDER BY reorder_count DESC
LIMIT 15;

-- 2. Days Between Orders Per User
"""
find the average time (in days) between each user's orders
Helpful for: what data tells you 
1. Purchase frequency
2. Customer engagement
3. Timing for marketing or reminders

Why It’s Useful - relevant for business value /actionable decisions
1. Identify loyal vs. inactive users
2. Time campaigns or push notifications based on personal order cycles
3. Segment users: e.g., weekly shoppers vs. monthly shoppers

"""

SELECT 
  user_id,
  AVG(days_since_prior_order) AS avg_days_between_orders
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY user_id
ORDER BY avg_days_between_orders;



-- 3. Frequently Bought Together
""" 
(Find top product pairs)
Selects two products from same order and counts how often that pair occurs. 
"""

SELECT 
  p1.product_id AS product_1,
  p2.product_id AS product_2,
  COUNT(*) AS pair_count

'''
→ Joins the table with itself to pair products from same order
→ p1.product_id < p2.product_id avoids duplicate/reversed pairs (e.g., A+B = B+A).
'''

FROM order_products_prior p1
JOIN order_products_prior p2 
  ON p1.order_id = p2.order_id AND p1.product_id < p2.product_id

'''→ Groups by product pairs, sorts by frequency, and returns top 20.'''

GROUP BY p1.product_id, p2.product_id
ORDER BY pair_count DESC
LIMIT 20;
