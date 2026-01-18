FROM nginx:alpine

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy all HTML pages
COPY index.html /usr/share/nginx/html/
COPY app.html /usr/share/nginx/html/
COPY privacy.html /usr/share/nginx/html/
COPY support.html /usr/share/nginx/html/

# Copy logo and favicon files
COPY logo-128.png /usr/share/nginx/html/
COPY logo-192.png /usr/share/nginx/html/
COPY logo-512.png /usr/share/nginx/html/
COPY favicon-32.png /usr/share/nginx/html/
COPY favicon-64.png /usr/share/nginx/html/
COPY apple-touch-icon.png /usr/share/nginx/html/

# Copy SEO files (robots.txt, sitemaps)
COPY robots.txt /usr/share/nginx/html/
COPY sitemap.xml /usr/share/nginx/html/
COPY sitemap-*.xml /usr/share/nginx/html/

# Copy English article
COPY adelboden-giant-slalom-preview-2026/ /usr/share/nginx/html/adelboden-giant-slalom-preview-2026/

# Copy all language directories with articles
COPY de/ /usr/share/nginx/html/de/
COPY fr/ /usr/share/nginx/html/fr/
COPY it/ /usr/share/nginx/html/it/
COPY es/ /usr/share/nginx/html/es/
COPY pt/ /usr/share/nginx/html/pt/
COPY nl/ /usr/share/nginx/html/nl/
COPY ar/ /usr/share/nginx/html/ar/
COPY ja/ /usr/share/nginx/html/ja/
COPY zh/ /usr/share/nginx/html/zh/
COPY ko/ /usr/share/nginx/html/ko/

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1
