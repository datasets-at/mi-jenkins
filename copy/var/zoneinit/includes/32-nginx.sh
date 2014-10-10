#!/usr/bin/bash
# configure ssl for nginx

cert_dir='/opt/local/etc/nginx/ssl/'

# SSL
if mdata-get nginx_ssl 1>/dev/null 2>&1; then
	# reconfigure jenkins to listen only on localhost
	log "reconfigure jenkins to listen only on localhost"
	svccfg -s jenkins:default setprop application/http_listen_address = astring: '127.0.0.1'
	svcadm refresh jenkins:default
	svcadm restart jenkins:default

	# copy mdata ssl certificate
	log "copy mdata ssl certificate"
	mdata-get nginx_ssl > ${cert_dir}nginx.pem
	chmod 400 ${cert_dir}nginx.pem

	# Enable nginx
	log "starting nginx"
	svcadm enable svc:/pkgsrc/nginx:default
else
	# reconfigure jenkins to listen only on localhost
	log "reconfigure jenkins to listen only on localhost"
	svccfg -s jenkins:default setprop application/http_listen_address = astring: '0.0.0.0'
	svcadm refresh jenkins:default
	svcadm restart jenkins:default

	# Disable nginx
	log "disable nginx"
	svcadm disable svc:/pkgsrc/nginx:default
fi

