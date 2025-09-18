FROM postgres:latest

# Set the default environment variables
ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=admin123
ENV POSTGRES_DB=ASSESSMENT

# Copy initialization SQL script
COPY init.sql /docker-entrypoint-initdb.d/