Supabase Database Guide --- Agent Instructions
This file is the database source of truth for the Flutter
grocery-store app.
Read this file before creating or modifying database-related code.
1. Supabase Configuration
Project URL:
https://ojtnqpisiienkvxhhwwy.supabase.co
Use the existing Supabase client/configuration in the project.
Use the publishable key only on the client.
NEVER: - use a service_role key in Flutter - use a Supabase secret
key in Flutter - create a direct PostgreSQL connection from Flutter -
bypass RLS
Authentication is already implemented. Do not create or replace the
authentication system unless explicitly instructed.
Use the existing supabase_flutter client:
final supabase = Supabase.instance.client;
All database operations must use this client.
2. Data API
Supabase Data API base URL:
https://ojtnqpisiienkvxhhwwy.supabase.co/rest/v1/
Current database resources:
/rest/v1/ProductTable
/rest/v1/category_table
/rest/v1/product_category
In Flutter, prefer the Supabase SDK:
supabase.from('ProductTable').select();
Do not manually construct REST requests unless explicitly required.
3. Database Security
The database is protected by PostgreSQL Row Level Security (RLS).
Authentication and authorization are different:
- Authentication determines whether the user is signed in.
- RLS determines what the signed-in user can do.
Never rely on Flutter-side checks for database security.
Customer app permissions
The customer-facing Flutter app is read-only for the catalog:
  Table                SELECT             INSERT   UPDATE   DELETE
  ProductTable       ✅ authenticated   ❌       ❌       ❌
  category_table     ✅ authenticated   ❌       ❌       ❌
  product_category   ✅ authenticated   ❌       ❌       ❌
Do not create application code that inserts, updates, or deletes records
in these tables.
Do not add FOR ALL policies for the customer role.
Do not disable RLS to fix a permission error.
If a database operation is rejected, investigate authentication, RLS
policies, and grants instead of bypassing security.
4. ProductTable
Exact table name:
ProductTable
Columns:
  Column                  Type          Description
  product_id            uuid          Primary key
  product_name          text          Product name
  metric                text          Product measurement/unit
  product_size          bigint        Product size
  qty_available         bigint        Available quantity
  thumbnail_image_url   text          Product thumbnail Storage path/URL
  listed_price          bigint        Original/listed price
  final_price           bigint        Final selling price
  discount_percent      integer       Discount percentage
  in_stock              boolean       Whether product is in stock
  is_visible            boolean       Whether product is visible to customers
  variants              text\(\)      Existing variant values
  rating                integer       Product rating
  rated_by              bigint        Number of ratings
  is_veg                boolean       Vegetarian indicator
  created_at            timestamptz   Creation timestamp
Primary key:
product_id
Important
ProductTable does not contain category_id.
Do not add category_id to ProductTable.
Product/category relationships must use product_category.
5. category_table
Exact table name:
category_table
Columns:
  Column                 Type   Description
  category_id          uuid   Primary key
  category_name        text   Category name
  category_image_url   text   Category image Storage path/URL
Primary key:
category_id
6. product_category
Exact table name:
product_category
Purpose:
Junction table for the many-to-many relationship between products and
categories.

Columns:
  Column          Type          Description
  product_id    uuid          FK → ProductTable.product_id
  category_id   uuid          FK → category_table.category_id
  created_at    timestamptz   Relationship creation time
Composite primary key:
(product_id, category_id)
Foreign keys:
product_id → ProductTable.product_id
category_id → category_table.category_id
Both foreign keys use:
ON DELETE CASCADE
Relationship
ProductTable
    │
    │ product_id
    ▼
product_category
    ▲
    │ category_id
    │
category_table
A product can belong to multiple categories.
A category can contain multiple products.
Never represent this relationship using an array or a category_id
column inside ProductTable.
7. Product Visibility
Customer product queries should normally only return products where:
is_visible = true
Example:
final products = await supabase
    .from('ProductTable')
    .select()
    .eq('is_visible', true);
For normal customer-facing product lists, also respect:
in_stock
when the feature requires only currently available products.
Do not silently change the meaning of is_visible or in_stock.
8. Common Queries
Fetch categories
final categories = await supabase
    .from('category_table')
    .select();
Fetch visible products
final products = await supabase
    .from('ProductTable')
    .select()
    .eq('is_visible', true);
Fetch visible products in stock
final products = await supabase
    .from('ProductTable')
    .select()
    .eq('is_visible', true)
    .eq('in_stock', true);
Fetch product-category relationships
final relationships = await supabase
    .from('product_category')
    .select();
Do not assume ProductTable.category_id exists.
9. Supabase Storage
There is one Supabase Storage bucket:
kolkata_mart
Current folder structure:
kolkata_mart/
├── category_image/
├── main_images/
└── thumbnail_images/
Category images
kolkata_mart/category_image/<file>
Database field:
category_table.category_image_url
Product main images
kolkata_mart/main_images/<file>
Product thumbnails
kolkata_mart/thumbnail_images/<file>
Database field:
ProductTable.thumbnail_image_url
Do not store image binary data in PostgreSQL.
Use Supabase Storage for images.
Storage authorization is separate from database-table RLS.
Do not add upload/delete/update functionality for customers unless
explicitly requested.
10. Agent Database Rules
When implementing features:
1. Use the existing Supabase client.
2. Preserve the existing authentication system.
3. Treat this file as the source of truth for the current schema.
4. Use exact table and column names documented here.
5. Do not invent database columns or tables.
6. Do not add category_id to ProductTable.
7. Use product_category for product/category relationships.
8. Do not add customer INSERT/UPDATE/DELETE operations to catalog
   tables.
9. Never disable RLS.
10. Never bypass RLS with a service-role/secret key.
11. Never put a service-role/secret key in Flutter code.
12. Do not modify the database schema unless explicitly requested.
13. If a requested feature requires a schema change, explain the
    required schema change before implementing it.
14. When querying products for customers, respect is_visible.
15. Treat Supabase Storage policies separately from database RLS.
16. If an operation fails because of permissions, diagnose the existing
    auth/RLS configuration rather than weakening security.
11. Current Schema Summary
ProductTable
├── product_id PK
├── product_name
├── metric
├── product_size
├── qty_available
├── thumbnail_image_url
├── listed_price
├── final_price
├── discount_percent
├── in_stock
├── is_visible
├── variants[]
├── rating
├── rated_by
├── is_veg
└── created_at

category_table
├── category_id PK
├── category_name
└── category_image_url

product_category
├── product_id PK/FK
├── category_id PK/FK
└── created_at

Composite PK:
(product_id, category_id)
This schema is authoritative unless the user explicitly requests a
change.