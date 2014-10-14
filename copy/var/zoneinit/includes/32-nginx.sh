#!/usr/bin/bash
# configure ssl for nginx

host=$(mdata-get sdc:hostname)
cert_dir='/opt/local/etc/nginx/ssl/'

# SSL
log "nginx ssl setup"
if mdata-get nginx_ssl 1>/dev/null 2>&1; then
  mkdir -p ${cert_dir} || true
  mdata-get nginx_ssl > ${cert_dir}nginx.pem
  chmod 400 ${cert_dir}nginx.pem

  log "switching jenkins site config"
  gsed -i \
          -e "s/jenkins.conf/jenkins_ssl.conf/" \
          /opt/local/etc/nginx/nginx.conf
fi

# Enable nginx
log "starting nginx"
svcadm enable svc:/pkgsrc/nginx:default
