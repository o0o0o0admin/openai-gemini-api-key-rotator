# Single-stage Dockerfile for openai-gemini-api-key-rotator (zero-dependency project)

FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Change ownership of app directory to non-root user
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port (will be overridden by environment variable)
EXPOSE 8990

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:${PORT:-8990}/admin', (res) => {if (res.statusCode !== 200) process.exit(1)})"

# Start the application
CMD ["node", "index.js"]
