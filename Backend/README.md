# CLMS Backend - Computer Lab Management System

## Tech Stack

- **Runtime**: Node.js >= 18
- **Framework**: Express.js
- **ORM**: Prisma
- **Database**: MySQL
- **Auth**: JWT (Access Token + Refresh Token)
- **API Docs**: Swagger UI

## Folder Structure

```
Backend/
├── prisma/
│   └── schema.prisma    # Prisma schema (MySQL)
├── sql/
│   ├── schema.sql       # Raw MySQL schema
│   └── seed.sql        # Seed data
├── src/                  # TODO: Implement after scaffolding
├── .env.example
└── package.json
```

## Setup

### 1. Prerequisites

- Node.js >= 18
- MySQL >= 8.0
- npm or yarn

### 2. Database Setup

```bash
# Create MySQL database
mysql -u root -p < sql/schema.sql
mysql -u root -p clms_db < sql/seed.sql
```

### 3. Install & Run

```bash
cd Backend
npm install

# Copy and configure environment variables
cp .env.example .env
# Edit .env with your MySQL credentials

# Generate Prisma client
npx prisma generate

# Push schema to database
npx prisma db push

# Start server
npm run dev
```

### 4. Demo Accounts

| Username | Password    | Role        |
|----------|-------------|-------------|
| admin    | Admin@1234  | System Admin |
| staff1   | Test@1234   | Lab Staff   |
| user1    | Test@1234   | Customer    |

## Environment Variables

```env
PORT=5000
NODE_ENV=development
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=clms_db
DATABASE_URL="mysql://root:your_password@localhost:3306/clms_db"
JWT_ACCESS_SECRET=your_access_secret_key
JWT_REFRESH_SECRET=your_refresh_secret_key
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
ALLOWED_ORIGINS=http://localhost:5173
```

## API Endpoints

| Group | Base Path |
|-------|-----------|
| Auth | `/api/auth` |
| Users | `/api/users` |
| Lab Rooms | `/api/lab-rooms` |
| Workstations | `/api/workstations` |
| Reservations | `/api/reservations` |
| Incidents | `/api/incidents` |
| Reports | `/api/reports` |

Swagger Docs: http://localhost:5000/api/docs
