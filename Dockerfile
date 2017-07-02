FROM ruby:2.3

LABEL maintainer="kamynina.d@gmail.com"

WORKDIR /

VOLUME /var/piggly/result

COPY ./piggly.sh /piggly.sh

RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates git build-essential libgmp3-dev && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* && \
  gem install treetop && \
  gem install pg && \
  gem install activerecord && \
  git clone git://github.com/kputnam/piggly.git && \
  cd /piggly && \
  bundle install && \
  bundle exec rake spec && \
  chmod +x /piggly/bin/piggly && \
  chmod +x /piggly.sh


CMD ["./piggly.sh"]
ENTRYPOINT ["./piggly.sh"]
