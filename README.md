# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
Ruby 3.4.9
Rails 8.1.3

* System dependencies

* Configuration

* Database creation


* Database initialization
bin/rails db:migrate:status
bin/rails db:migrate

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

## Deployment instructions
```
# Make User
adduser username
usermod -aG sudo username
su - username
```

#### Install system dependencies
```
# Update system
apt update && apt upgrade -y

# Nginx
sudo apt install -y nginx

# Ruby dependency
apt install -y git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev

# Postgres
apt install -y postgresql postgresql-contrib libpq-dev

# Install Node.js (for esbuild/JS bundling)
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install Yarn alternative (npm is fine with Rails 8)
npm install -g esbuild

# Install rbenv + ruby-build
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby 3.3
rbenv install 3.4.9
rbenv global 3.4.9
ruby -v  # should show 3.4.9
```
#### Setup Postgres
```
# Switch to postgres user and create a DB user
sudo -u postgres psql

# In the PostgreSQL console:
CREATE USER priclip WITH PASSWORD 'your_secure_password_here';
ALTER USER priclip CREATEDB;
\q
```

#### Clone app
```
# Create a deploy directory
mkdir -p /var/www
cd /var/www

# Clone from your GitHub repo (push your code there first)
git clone https://github.com/YOUR_USERNAME/clipsync.git
cd clipsync

# Install bundler and gems
gem install bundler
bundle install

# if error
sudo chown -R pris:pris /var/www/priclip-ror
```

#### Configure production database
```
# config/database.yml
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
  database: clipsync_production
  username: clipsync
  password: <%= ENV["CLIPSYNC_DATABASE_PASSWORD"] %>
```

#### Set environment variabel
```
# Create a .env.production file (or use systemd env)
cat > /var/www/clipsync/.env.production << 'EOF'
RAILS_ENV=production
PRICLIP_DATABASE_PASSWORD=your_secure_password_here
EOF

# Generate and set the secret key base
echo "SECRET_KEY_BASE=$(bundle exec rails secret)" >> /var/www/priclip-ror/.env.production
```

####  Precompile asset & migrate
```
# Load environment variables
export $(cat .env.production | xargs)

# Setup database
bin/rails db:create RAILS_ENV=production
bin/rails db:migrate RAILS_ENV=production

# Precompile CSS/JS assets
npm install @hotwired/turbo-rails @hotwired/stimulus
npm install tailwindcss @tailwindcss/cli
npm install esbuild

bin/rails assets:precompile
```

#### Puma config
```
config/puma.rb
# config/puma.rb
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!

plugin :tmp_restart
```

#### Setup service for puma
```
cat > /etc/systemd/system/clip.service << 'EOF'
[Unit]
Description=ClipSync Puma Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/priclip-ror
EnvironmentFile=/var/www/priclip-ror/.env.production
ExecStart=/home/pris/.rbenv/shims/bundle exec puma -C config/puma.rb
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl enable clip
sudo systemctl start clip
sudo systemctl status clip
```

#### Nginx config
```
# /etc/nginx/sites-available/clip:
server {
    listen 80;
    server_name YOUR_DOMAIN_OR_IP;

    root /var/www/priclip-ror/public;
    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    client_max_body_size 10M;
}

# Enable the site
sudo ln -s /etc/nginx/sites-available/clip /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test and restart
sudo nginx -t
sudo systemctl restart nginx
```

## Link to custom domain with subdomain
