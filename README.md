# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc


#Algorithm Used
Algorithm used is simple conversion of short_url **id** (base10) into base64.

Pros:

1. Base62 is url friendly.
2. The number of characters only increase with increasing ids, thus insuring shortest urls

Cons:

1. It is easy to decipher. Someone can easy get the exact id of the record
2. Generates different url each time even for the same full_url

In real life scenarios: I will use a combination of MD5, random letters and id(encoded in base62)


###Things to Note:

1. I added public_attributes method. We could use it for as_json as well.
2. I could use ActiveModel Serializers as well instead of overriding as_json
