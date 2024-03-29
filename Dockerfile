FROM gliderlabs/alpine:3.2
MAINTAINER Talha Korkmaz <mtk991@gmail.com>

# Update ca-certificates
RUN apk add --update ca-certificates && update-ca-certificates

# Install all the dependencies for Jekyll
RUN apk-install bash build-base libffi-dev zlib-dev libxml2-dev libxslt-dev ruby ruby-dev nodejs

# Install Jekyll
RUN gem install bundler jekyll --no-ri --no-rdoc

# Install nokogiri separately because it's special
RUN gem install nokogiri -v 1.6.7.2 -- --use-system-libraries

# Clean up
RUN rm -rf /var/cache/apk/* /tmp/*

# Copy the Gemfile and Gemfile.lock into the image and run bundle install in a
# way that will be cached
WORKDIR /tmp
ADD Gemfile Gemfile
RUN bundle install

# Copy source
RUN mkdir -p /src
VOLUME ["/src"]
WORKDIR /src
ADD . /src

# Jekyll runs on port 4000 by default
EXPOSE 4000

# Run jekyll serve
CMD ["./jekyll-serve.sh"]
