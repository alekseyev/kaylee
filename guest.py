import sys

nginx_template = """
upstream app-upstream-{app_port} {{
    server localhost:{app_port};
}}

server {{
    server_name www.{app_host};
    return 301 $scheme://{app_host}$request_uri;
}}

server {{
    listen   80;
    server_name {app_host};
    location / {{
        proxy_pass          http://app-upstream-{app_port};
        proxy_connect_timeout 120s;
        proxy_read_timeout  240s;
        proxy_send_timeout  240s;
        proxy_redirect      off;
        proxy_buffering     off;

        proxy_set_header    Host            $http_host;
        proxy_set_header    X-Real-IP       $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Url-Scheme    $scheme;
    }}
}}
"""

def main(app_host, app_port):
    config = nginx_template.format(**locals())
    config_path = '/etc/nginx/conf.d/{app_host}.conf'.format(**locals())
    with open(config_path, 'w') as config_file:
        config_file.write(config)

if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])

