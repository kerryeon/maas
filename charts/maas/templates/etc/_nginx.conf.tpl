{{/* file location: /var/lib/maas/http/nginx.conf */}}
{{- $worker_processes := index .Values.conf.nginx "worker_processes" | default "auto" -}}
{{- $worker_connections := index .Values.conf.nginx "worker_connections" | default 768 -}}
pid /run/maas-http.pid;
worker_processes {{ $worker_processes }};

error_log /var/log/maas/http/error.log;

events {
    worker_connections {{ $worker_connections }};
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 10M;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/maas/http/access.log;

    gzip on;

    include /var/lib/maas/http/*.nginx.conf;

    # LP: #1796224 and #1869067 - Use different paths otherwise this will
    # conflict with the system's nginx daemon.
    client_body_temp_path /var/lib/maas/http/body;
    fastcgi_temp_path /var/lib/maas/http/fastcgi;
    proxy_temp_path /var/lib/maas/http/proxy;
    scgi_temp_path /var/lib/maas/http/scgi;
    uwsgi_temp_path /var/lib/maas/http/uwsgi;
}
