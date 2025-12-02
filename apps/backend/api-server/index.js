import express from 'express';
import cors from 'cors';
import db from './db.js';
import './seed.js'; // Run seed on startup

const app = express();
const PORT = 9001; // Changed from 9000 to avoid conflict with Medusa

// Middleware
app.use(cors());
app.use(express.json());

// API Routes

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Get all products
app.get('/store/products', (req, res) => {
    try {
        const products = db.prepare('SELECT * FROM products').all();

        // Parse print_area JSON
        const formattedProducts = products.map(p => ({
            id: p.id,
            name: p.name,
            description: p.description,
            basePrice: p.base_price,
            image: p.image,
            category: p.category,
            printArea: JSON.parse(p.print_area),
            stock: p.stock
        }));

        res.json({ products: formattedProducts });
    } catch (error) {
        console.error('Error fetching products:', error);
        res.status(500).json({ error: 'Failed to fetch products' });
    }
});

// Get product by ID
app.get('/store/products/:id', (req, res) => {
    try {
        const product = db.prepare('SELECT * FROM products WHERE id = ?').get(req.params.id);

        if (!product) {
            return res.status(404).json({ error: 'Product not found' });
        }

        const formattedProduct = {
            id: product.id,
            name: product.name,
            description: product.description,
            basePrice: product.base_price,
            image: product.image,
            category: product.category,
            printArea: JSON.parse(product.print_area),
            stock: product.stock
        };

        res.json({ product: formattedProduct });
    } catch (error) {
        console.error('Error fetching product:', error);
        res.status(500).json({ error: 'Failed to fetch product' });
    }
});

// Create order
app.post('/store/orders', (req, res) => {
    try {
        const { items, customer, shipping_address } = req.body;

        // Generate order ID
        const orderId = `order_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

        // Calculate total
        const total = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);

        // Start transaction
        const insertOrder = db.transaction(() => {
            // Insert order
            db.prepare(`
        INSERT INTO orders (id, customer_name, customer_email, shipping_address, total, status)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(
                orderId,
                customer?.name || 'Guest',
                customer?.email || '',
                JSON.stringify(shipping_address || {}),
                total,
                'pending'
            );

            // Insert order items
            const insertItem = db.prepare(`
        INSERT INTO order_items (order_id, product_id, quantity, price, design_image, size, color)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `);

            for (const item of items) {
                insertItem.run(
                    orderId,
                    item.productId,
                    item.quantity,
                    item.price,
                    item.designImage || null,
                    item.size || 'L',
                    item.color || 'White'
                );
            }
        });

        insertOrder();

        // Fetch created order
        const order = db.prepare('SELECT * FROM orders WHERE id = ?').get(orderId);
        const orderItems = db.prepare('SELECT * FROM order_items WHERE order_id = ?').all(orderId);

        res.status(201).json({
            order: {
                id: order.id,
                customer: {
                    name: order.customer_name,
                    email: order.customer_email
                },
                shipping_address: JSON.parse(order.shipping_address),
                total: order.total,
                status: order.status,
                created_at: order.created_at,
                items: orderItems
            }
        });
    } catch (error) {
        console.error('Error creating order:', error);
        res.status(500).json({ error: 'Failed to create order' });
    }
});

// Get all orders
app.get('/store/orders', (req, res) => {
    try {
        const orders = db.prepare('SELECT * FROM orders ORDER BY created_at DESC').all();

        const formattedOrders = orders.map(order => {
            const items = db.prepare('SELECT * FROM order_items WHERE order_id = ?').all(order.id);

            return {
                id: order.id,
                customer: {
                    name: order.customer_name,
                    email: order.customer_email
                },
                shipping_address: JSON.parse(order.shipping_address),
                total: order.total,
                status: order.status,
                created_at: order.created_at,
                items
            };
        });

        res.json({ orders: formattedOrders });
    } catch (error) {
        console.error('Error fetching orders:', error);
        res.status(500).json({ error: 'Failed to fetch orders' });
    }
});

// Get order by ID
app.get('/store/orders/:id', (req, res) => {
    try {
        const order = db.prepare('SELECT * FROM orders WHERE id = ?').get(req.params.id);

        if (!order) {
            return res.status(404).json({ error: 'Order not found' });
        }

        const items = db.prepare('SELECT * FROM order_items WHERE order_id = ?').all(order.id);

        res.json({
            order: {
                id: order.id,
                customer: {
                    name: order.customer_name,
                    email: order.customer_email
                },
                shipping_address: JSON.parse(order.shipping_address),
                total: order.total,
                status: order.status,
                created_at: order.created_at,
                items
            }
        });
    } catch (error) {
        console.error('Error fetching order:', error);
        res.status(500).json({ error: 'Failed to fetch order' });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 API Server running on http://localhost:${PORT}`);
    console.log(`📦 Products endpoint: http://localhost:${PORT}/store/products`);
    console.log(`🛒 Orders endpoint: http://localhost:${PORT}/store/orders`);
    console.log(`💾 Database: SQLite (commerce.db)`);
});
