# Backend Services

This directory contains the backend services for the Content-to-Commerce platform.

## Services

- **PostgreSQL**: Main database (port 5432)
- **Redis**: Cache for Medusa (port 6379)
- **Medusa**: E-commerce backend (will be on port 9000)
- **Strapi**: Headless CMS (will be on port 1337)

## Quick Start

### 1. Start Database Services

```bash
cd apps/backend
docker-compose up -d
```

This will start PostgreSQL and Redis in the background.

### 2. Verify Services

```bash
docker-compose ps
```

You should see both `commerce-postgres` and `commerce-redis` running.

### 3. Stop Services

```bash
docker-compose down
```

## Database Connection

- **Host**: localhost
- **Port**: 5432
- **Database**: commerce_db
- **User**: commerce_user
- **Password**: commerce_pass

Connection string:
```
postgresql://commerce_user:commerce_pass@localhost:5432/commerce_db
```

## Next Steps

1. Initialize Medusa backend
2. Initialize Strapi CMS
3. Configure both to use the PostgreSQL database
