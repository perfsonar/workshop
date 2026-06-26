#
# Makefile for perfSONAR workshops
#


default: build

HOSTS := hosts.csv
$(HOSTS):
	@echo Hosts file $(HOSTS) is missing.
	@false
TO_DIST_CLEAN += $(HOSTS)

HOSTS_CLEAN := hosts-clean.csv
$(HOSTS_CLEAN): $(HOSTS)
	sed -e 's/#.*$$//g; /^\s*$$/d; s/"//g' $< > $@
TO_CLEAN += $(HOSTS_CLEAN)

MESH_SKELETON := mesh-skeleton.json
MESH := mesh.json
BUILDER := build-mesh.jq
$(MESH): $(HOSTS_CLEAN) $(MESH_SKELETON) $(BUILDER)
	jq \
		--rawfile hosts_clean "$(HOSTS_CLEAN)" \
		--slurpfile mesh "$(MESH_SKELETON)" \
		-f "$(BUILDER)" \
		"$(MESH_SKELETON)" \
		> $@
TO_CLEAN += $(MESH)



IP_AUTH_LIST := ip-auth
$(IP_AUTH_LIST): $(HOSTS_CLEAN)
	awk -F, '$$1 != "archive" { printf "Require ip %s\n", $$2 }' $< > $@
TO_CLEAN += $(IP_AUTH_LIST)


SSH_KEY := ssh-key
$(SSH_KEY):
	@echo SSH key file $(SSH_KEY) is missing.
	@false
TO_DIST_CLEAN += $(SSH_KEY)

build: $(MESH) $(IP_AUTH_LIST) $(SSH_KEY)
	@true

### INDEX_HTML := index.html
### WEB_ROOT := /var/www/html/lab
### 
### install-root:
### 	mkdir -p $(WEB_ROOT)
### 	install -644 $(MESH) $(WEB_ROOT)
### 	chown -R root:root $(WEB_ROOT)
### 	chcon unconfined_u:object_r:httpd_sys_content_t:s0 $(WEB_ROOT)/*
### 	@echo TODO: Add testpoint IPs to /etc/httpd/conf.d/apache-logstash.conf
### 	@echo TODO: Install SSH key in $(WEB_ROOT)
### 	/usr/sbin/setsebool httpd_can_network_connect true
### 	systemctl restart httpd
### 	psconfig remote add https://localhost/lab/mesh
### 
### install: build $(INDEX_HTML)
### 	@echo
### 	@echo WARNING: THIS IS UNTESTED.
### 	@echo
### 	sudo $(MAKE) $@-root



clean:
	rm -rf $(TO_CLEAN)
	find . -name "*~" | xargs rm -rf

distclean: clean
	rm -rf $(TO_DIST_CLEAN)
