# My Microservice Project

Django project with PostgreSQL database.

## Quick Start with Docker Compose

1. Make sure you have Docker and Docker Compose installed
2. Run the project:

   ```bash
   # For development (with logs visible)
   docker-compose up --build

   # For production (background mode)
   docker-compose up -d --build

   # Quick start (if images already built)
   docker-compose up -d
   ```

3. The application will be available at: http://localhost:8000

## Local Development

1. Create a virtual environment:

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Linux/Mac
   # or
   .venv\Scripts\activate  # Windows
   ```

2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Create a `.env` file with environment variables:

   ```
   POSTGRES_HOST=localhost
   POSTGRES_PORT=5432
   POSTGRES_DB=postgres
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=your_password
   ```

4. Run migrations:

   ```bash
   python manage.py migrate
   ```

5. Start the development server:
   ```bash
   python manage.py runserver
   ```

## Docker Commands

### Development

```bash
# Start with rebuild and show logs
docker-compose up --build

# Start without rebuild and show logs
docker-compose up
```

### Production

```bash
# Start in background with rebuild
docker-compose up -d --build

# Start in background without rebuild
docker-compose up -d
```

### Management

```bash
# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Environment Variables

- `POSTGRES_HOST` - PostgreSQL host (default: localhost)
- `POSTGRES_PORT` - PostgreSQL port (default: 5432)
- `POSTGRES_DB` - Database name (default: postgres)
- `POSTGRES_USER` - PostgreSQL user (default: postgres)
- `POSTGRES_PASSWORD` - PostgreSQL password (default: empty string)

## Project Structure

```
my-microservice-project/
├── config/                 # Django settings
│   ├── settings.py        # Main settings file
│   ├── urls.py           # URL configuration
│   └── wsgi.py           # WSGI configuration
├── Dockerfile            # Docker image configuration
├── docker-compose.yml    # Multi-container setup
├── requirements.txt      # Python dependencies
└── manage.py            # Django management script
```
