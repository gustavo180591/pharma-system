# Pharma System

A modern pharmacy management system built with SvelteKit and Tailwind CSS

## Features

- Modern, responsive UI with dark mode support
- Built with SvelteKit and Tailwind CSS
- TypeScript support
- PostgreSQL database with Prisma ORM

```sh
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```sh
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.
=======
# PharmaSystem - Pharmacy Management System

A modern pharmacy management system built with SvelteKit, Tailwind CSS, Prisma, and PostgreSQL.

## Features

- 🏥 **Inventory Management** - Track products, batches, and stock levels
- 💊 **Prescription Management** - Handle electronic prescriptions and track medication dispensation
- 💰 **Sales & Billing** - Process sales, generate invoices, and manage payments
- 👥 **Customer Management** - Maintain customer records and purchase history
- 📊 **Reporting** - Generate sales reports, inventory status, and analytics
- 🔐 **Role-based Access Control** - Secure access control for different user roles

## Tech Stack

- **Frontend**: SvelteKit 2 + Svelte 5 (Runes)
- **Styling**: Tailwind CSS 4
- **Database**: PostgreSQL with Prisma ORM
- **Containerization**: Docker & Docker Compose
- **Authentication**: JWT with HTTP-only cookies

## Prerequisites

- Node.js 18+
- Docker & Docker Compose
- pnpm (recommended) or npm

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pharma-system.git
   cd pharma-system
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   # or
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Update the .env file with your configuration
   ```

4. **Start the development environment**
   ```bash
   # Start PostgreSQL and pgAdmin
   docker-compose up -d
   
   # Run database migrations
   pnpm db:migrate
   
   # Start the development server
   pnpm dev
   ```

5. **Access the application**
   - Web application: http://localhost:3000
   - Database admin (pgAdmin): http://localhost:5050
     - Email: admin@pharma.local
     - Password: admin

## Development

### Available Scripts

- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm preview` - Preview production build
- `pnpm db:migrate` - Run database migrations
- `pnpm db:studio` - Open Prisma Studio for database management
- `pnpm lint` - Run ESLint
- `pnpm format` - Format code with Prettier

### Project Structure

```
pharma-system/
├── prisma/           # Database schema and migrations
├── src/
│   ├── lib/
│   │   ├── server/   # Server-only utilities
│   │   └── shared/   # Shared utilities
│   ├── routes/       # Application routes
│   └── app.css       # Global styles
├── static/           # Static assets
└── tests/            # Test files
```

## Database Schema

The database schema is defined in `prisma/schema.prisma`. Key models include:

- **User** - System users with role-based access
- **Product** - Product catalog
- **Batch** - Product batches with expiration tracking
- **Sale** - Sales transactions
- **Customer** - Customer information
- **Prescription** - Medical prescriptions
- **Supplier** - Product suppliers

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Database
DATABASE_URL="postgresql://pharma_app:app123@localhost:5432/pharma_system?schema=public"

# App
NODE_ENV=development
PORT=3000

# Auth
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRES_IN=7d
COOKIE_SECRET=your_cookie_secret_here
```

## Deployment

### Production Build

1. Build the application:
   ```bash
   pnpm build
   ```

2. Start the production server:
   ```bash
   pnpm start
   ```

### Docker Deployment

1. Build the Docker image:
   ```bash
   docker build -t pharma-system .
   ```

2. Run the container:
   ```bash
   docker run -p 3000:3000 --env-file .env pharma-system
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

For support, please open an issue in the GitHub repository.

## Getting Started

1. Clone the repository
2. Install dependencies: `pnpm install`
3. Set up your database in `prisma/schema.prisma`
4. Run migrations: `pnpm db:migrate`
5. Start the development server: `pnpm dev`

## Built With

- [SvelteKit](https://kit.svelte.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Prisma](https://www.prisma.io/)
- [PostgreSQL](https://www.postgresql.org/)

---

Built with ❤️ for better pharmacy management
