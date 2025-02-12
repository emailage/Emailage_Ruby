FROM ruby:3.4

# Install dependencies
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy the Gemfile and gemspec into the image
COPY Gemfile emailage.gemspec ./

# Copy the lib directory into the image
COPY lib/ lib/

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Command to run the application
CMD ["bash"]

# docker build -t emailageDev .
# docker run -it -v $(pwd):/app emailageDev bash