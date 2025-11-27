import db from './db.js';

// Initial products data
const products = [
    {
        id: 'tshirt-white',
        name: '经典白T恤',
        description: '100%纯棉，舒适透气',
        base_price: 89,
        image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
        category: 'apparel',
        print_area: JSON.stringify({ left: 150, top: 200, width: 300, height: 400 }),
        stock: 100
    },
    {
        id: 'hoodie-black',
        name: '黑色连帽卫衣',
        description: '加厚保暖，街头风格',
        base_price: 199,
        image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&q=80',
        category: 'apparel',
        print_area: JSON.stringify({ left: 150, top: 250, width: 300, height: 350 }),
        stock: 50
    },
    {
        id: 'poster-a3',
        name: 'A3 艺术海报',
        description: '高品质印刷，适合装裱',
        base_price: 59,
        image: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=800&q=80',
        category: 'home',
        print_area: JSON.stringify({ left: 0, top: 0, width: 420, height: 594 }),
        stock: 200
    },
    {
        id: 'mug-white',
        name: '陶瓷马克杯',
        description: '耐高温，可微波',
        base_price: 49,
        image: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=800&q=80',
        category: 'home',
        print_area: JSON.stringify({ left: 50, top: 50, width: 200, height: 150 }),
        stock: 150
    }
];

// Check if products table is empty
const count = db.prepare('SELECT COUNT(*) as count FROM products').get();

if (count.count === 0) {
    console.log('📦 Seeding products...');

    const insert = db.prepare(`
    INSERT INTO products (id, name, description, base_price, image, category, print_area, stock)
    VALUES (@id, @name, @description, @base_price, @image, @category, @print_area, @stock)
  `);

    const insertMany = db.transaction((products) => {
        for (const product of products) {
            insert.run(product);
        }
    });

    insertMany(products);
    console.log(`✅ Seeded ${products.length} products`);
} else {
    console.log(`ℹ️  Database already has ${count.count} products`);
}

export default db;
