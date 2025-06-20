# My Microservice Project

A Django project with PostgreSQL database and Nginx reverse proxy, containerized with Docker.

## Quick Start with Docker Compose

1. Make sure you have Docker and Docker Compose installed
2. Create environment file:
   ```bash
   cp env.example .env
   ```
3. Edit `.env` file with your database settings:
   ```env
   POSTGRES_HOST=db
   POSTGRES_PORT=5432
   POSTGRES_DB=postgres
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=postgres
   ```
4. Run the project:

   ```bash
   # For development (with logs visible)
   docker-compose up --build

   # For production (background mode)
   docker-compose up -d --build

   # Quick start (if images already built)
   docker-compose up -d
   ```

5. The application will be available at: http://localhost

## Project Architecture

The project consists of three main services:

- **Nginx** - Reverse proxy server (port 80)
- **Django** - Web application (port 8000, internal)
- **PostgreSQL** - Database (port 5432)

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

   ```env
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

# View logs for specific service
docker-compose logs -f web
docker-compose logs -f nginx
docker-compose logs -f db

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Django Management Commands

```bash
# Run Django commands in container
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py shell
docker-compose exec web python manage.py collectstatic
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
├── nginx/                 # Nginx configuration
│   └── default.conf      # Nginx server configuration
├── Dockerfile            # Docker image configuration
├── docker-compose.yml    # Multi-container setup
├── requirements.txt      # Python dependencies
├── env.example          # Environment variables template
├── .env                 # Environment variables (create from env.example)
└── manage.py            # Django management script
```

## Nginx Configuration

The Nginx configuration (`nginx/default.conf`) is set up as a reverse proxy:

- Listens on port 80
- Proxies all requests to Django application
- Sets proper headers for Django
- Handles client IP forwarding

## Database Access

- **From host machine**: `localhost:5432`
- **From Django container**: `db:5432`
- **Default credentials**: `postgres/postgres`

## Troubleshooting

### Nginx won't start

- Check if port 80 is available
- Verify nginx configuration syntax
- Check logs: `docker-compose logs nginx`

### Django can't connect to database

- Ensure `.env` file exists with correct database settings
- Check if PostgreSQL container is running
- Verify database credentials match in `.env` and docker-compose.yml

### Permission issues

- Make sure Docker has proper permissions
- Check file ownership for mounted volumes

## Development Tips

1. **Hot reload**: Code changes are automatically reflected due to volume mounting
2. **Database persistence**: Data is stored in Docker volumes
3. **Environment isolation**: Each service runs in its own container
4. **Easy scaling**: Services can be scaled independently

## Production Considerations

- Change default passwords
- Use environment-specific settings
- Configure proper logging
- Set up SSL/TLS certificates
- Use production-grade database
- Configure backup strategies
