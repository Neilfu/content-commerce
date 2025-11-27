# API Server

## Files
- `index.js` - Main server file with API endpoints
- `db.js` - Database initialization and schema
- `seed.js` - Initial data seeding
- `commerce.db` - SQLite database file (auto-generated)

## Database Schema

### Products Table
- id (TEXT, PRIMARY KEY)
- name (TEXT)
- description (TEXT)
- base_price (REAL)
- image (TEXT)
- category (TEXT)
- print_area (TEXT, JSON)
- stock (INTEGER)
- created_at (DATETIME)

### Orders Table
- id (TEXT, PRIMARY KEY)
- customer_name (TEXT)
- customer_email (TEXT)
- shipping_address (TEXT, JSON)
- total (REAL)
- status (TEXT)
- created_at (DATETIME)

### Order Items Table
- id (INTEGER, PRIMARY KEY AUTOINCREMENT)
- order_id (TEXT, FOREIGN KEY)
- product_id (TEXT, FOREIGN KEY)
- quantity (INTEGER)
- price (REAL)
- design_image (TEXT)
- size (TEXT)
- color (TEXT)

## Running the Server

```bash
npm run dev
```

The server will:
1. Initialize the SQLite database
2. Create tables if they don't exist
3. Seed initial product data (if database is empty)
4. Start listening on port 9000

## API Endpoints

- `GET /health` - Health check
- `GET /store/products` - Get all products
- `GET /store/products/:id` - Get product by ID
- `POST /store/orders` - Create new order
- `GET /store/orders` - Get all orders
- `GET /store/orders/:id` - Get order by ID
