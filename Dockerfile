FROM nginx:1.9

#Install Curl
RUN apt-get update -qq && apt-get -y install wget unzip curl

#Install Consul Template
RUN wget https://releases.hashicorp.com/consul-template/0.18.0-rc1/consul-template_0.18.0-rc1_linux_amd64.zip && unzip consul-template_0.18.0-rc1_linux_amd64.zip -d /usr/local/bin

#Setup Consul Template Files
RUN mkdir /etc/consul-templates
COPY ./nginx.ctmpl /etc/consul-templates/app.conf

# Remove all other conf files from nginx
RUN rm /etc/nginx/conf.d/*

#Default Variables
ENV CONSUL 172.17.0.1:8500

CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf && /usr/local/bin/consul-template -consul=$CONSUL -template "/etc/consul-templates/app.conf:/etc/nginx/conf.d/app.conf:nginx -t && nginx -s reload || true" || true
