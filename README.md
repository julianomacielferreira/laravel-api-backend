# Simple API using Laravel Lumen

This project is based on the tutorials:

- [Building a API with Lumen - A PHP framework](https://www.youtube.com/watch?v=6Oxfb_HNY0U) 
- [Laravel RESTFul API with JSON Web Token JWT](https://www.youtube.com/watch?v=jF9wdF0sViI) 
- [AUTENTICAÇÃO EM API REST UTILIZANDO JWT | LARAVEL TIPS #018](https://www.youtube.com/watch?v=Ri-DLFeepbM) 
- [Build a JWT Authenticated API with Lumen(v5.8)](https://dev.to/ndiecodes/build-a-jwt-authenticated-api-with-lumen-2afm)

It's using [Lumen PHP Framework](https://lumen.laravel.com/).

## Database Model

The model is like a 'blueprint' that presents the representation of the entities that make up the database with their properties, relationships, restrictions, etc.

![](DB_MODEL_LARAVEL_API.png)

# Build Docker Image

**[Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) must be installed.**

The file structure for docker configuration files are:

```
.
├── docker
│   ├── Dockerfile
│   ├── mysql
│   │   ├── conf.d
│   │   │   └── my.cnf
│   │   └── data
│   ├── nginx
│   │   └── laravel-api-backend.localhost.conf
│   └── php
│       ├── 99-xdebug.ini
│       └── php.ini

```

First create a directory called **data** in the root project folder:

```bash
$ mkdir -p docker/mysql/data
```

Give write permission to storage folder:

```bash
$ chmod 777 -R storage
```

Build the docker image (it will be using the Dockerfile in docker directory for the php 7.4):

```bash
$ docker-compose build
```

Fire up the container:

```bash
$ docker-compose up
```

Or simple run the [docker-start.sh](https://github.com/julianomacielferreira/laravel-api-backend/blob/main/docker-start.sh) script:

```bash
$ ./docker-start.sh
```

Obs.: If the script is not executable, run:

```bash
$ chmod +x docker-start.sh
```

To stop the container before moving on:

```bash
$ docker-compose stop
```

or

```bash
$ docker-compose down
```

See the [references section](#references) to know more or take a look at [MySQL Docker Documentation](https://docs.docker.com/samples/library/mysql/).

# Composer dependencies

Check if the containers are running:

```bash
$ docker ps
```

The output should be something like:

![](docker-ps-output.png)

Enter in the **php74-fpm** container with the following command:

```bash
$ docker exec -it php74-fpm bash
```

And install the laravel composer dependencies:

```bash
$ composer install
```

Generate the random **APP_KEY** running the following command (remember to copy the output):

```bash
$ php -r "echo md5(uniqid()).\"\n\";"
```

and copy the output.

Generate a secret key **JWT_SECRET** with the artisan command (remember to copy the output):

```bash
$ php artisan jwt:secret
```

The two configuration options above should be created inside the docker container **php74-fpm** and will be different in your environment (see [Laravel Docs](https://lumen.laravel.com/docs/8.x) to know more about).

# .ENV Settings

The files that must be changed for the system to be configured on the server are:

- Rename the file [.env.example](https://github.com/julianomacielferreira/laravel-api-backend/blob/main/.env.example) to **.env**

```bash
APP_NAME=Simple_Laravel_API
APP_ENV=local
APP_KEY= # use the output of the `php -r "echo md5(uniqid()).\"\n\";" command`
APP_DEBUG=true
APP_URL=http://localhost
APP_TIMEZONE=UTC

LOG_CHANNEL=stack
LOG_SLACK_WEBHOOK_URL=

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_api
DB_USERNAME=laravel
DB_PASSWORD=password

CACHE_DRIVER=file
QUEUE_CONNECTION=sync

JWT_SECRET= # use the output of the `php artisan jwt:secret` command
```

# Creating the Database

Enter inside the **php74-fpm** container with the following command:

```bash
$ docker exec -it php74-fpm bash
```

Run the migration command:

```bash
$ php artisan migrate
```

Or run (i.e, import) the following DDL instructions in the file [db_schema.sql](https://github.com/julianomacielferreira/laravel-api-backend/blob/main/db_schema.sql) directed into the database:

```sql
-- DROP AND RECREATE DATABASE
DROP DATABASE IF EXISTS `laravel_api`;
CREATE DATABASE `laravel_api`;
USE `laravel_api`;

--
-- Table structure for table `users`
--
CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

--
-- Table structure for table `article`
--
CREATE TABLE IF NOT EXISTS `article` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT(20) UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `article_user_id_foreign` (`user_id` ASC) VISIBLE,
  CONSTRAINT `article_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

--
-- Table structure for table `migrations`
--
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` VARCHAR(255) NOT NULL,
  `batch` INT(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
```

# Add Project Localhost URL to /etc/hosts

Alter the file hosts on /etc directory:

```bash
$ sudo nano /etc/hosts
```

Adding the following entry:

```bash
# APIs and Projects
127.0.0.1	laravel-api-backend.localhost
```

This is because the nginx config file [laravel-api-backend.localhost.conf](https://github.com/julianomacielferreira/laravel-api-backend/blob/main/docker/nginx/laravel-api-backend.localhost.conf) (on line 3) configure the server name directive to:

```
server_name laravel-api-backend.localhost;
```

# Access the microservice

If all the configuration above was successfull you should access [http://laravel-api-backend.localhost/](http://laravel-api-backend.localhost/) on your browser and see:

```
Lumen (7.2.2) (Laravel Components ^7.0)
``` 

To create some entries simple run the [curl-test.sh](https://github.com/julianomacielferreira/laravel-api-backend/blob/main/curl-test.sh) script:

```bash
$ ./curl-test.sh
```

The output should see something like:

```bash
$ ./curl-test.sh 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   317    0   188  100   129   1435    985 --:--:-- --:--:-- --:--:--  2438
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   478    0   412  100    66   3375    540 --:--:-- --:--:-- --:--:--  3950
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   168    0   168    0     0   3076      0 --:--:-- --:--:-- --:--:--  3111
...
```

# Endpoints

### Create User (POST): 

- **/api/register**

Example:

```bash
$ curl -d '{"name": "Juliano Maciel", "email":"ju.maciel.ferreira@gmail.com", "password": "password", "password_confirmation": "password"}' \
-H "Content-Type: application/json" \ 
-X POST http://laravel-api-backend.localhost/api/register
```

The output:

```json
{
    "user": {
        "name":"Juliano Maciel",
        "email":"ju.maciel.ferreira1@gmail.com",
        "updated_at":"2020-11-06T12:43:48.000000Z",
        "created_at":"2020-11-06T12:43:48.000000Z",
        "id":3
    },
    "message": "CREATED"
}
```

### User Login (POST): 

- **/api/login**

Example:

```bash
$ curl -d '{"email":"ju.maciel.ferreira@gmail.com", "password": "password"}' \
-H "Content-Type: application/json" \
-X POST http://laravel-api-backend.localhost/api/login
```

The output:

```json
{
    "message": "Authorized",
    "token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type":"bearer",
    "expires_in":3600
}
```

### User Logout (POST): 

- **/api/logout**
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X POST http://laravel-api-backend.localhost/api/logout
```

The output:

```json
{
    "message":"Successfully logged out"
}
```

### Refresh Token (POST): 

- **/api/refresh**
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X POST http://laravel-api-backend.localhost/api/refresh
```

The output:

```json
{
    "token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type":"bearer",
    "expires_in":3600
}
```

### Retrieve Logged User (GET): 

- **/api/profile**
- **Needs token.**

Example:

```bash
$ curl -H 'Accept: application/json' \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X GET http://laravel-api-backend.localhost/api/profile
```

The output:

```json
{
    "user":{
        "id":20,
        "name":"Juliano Maciel",
        "email":"ju.maciel.ferreira56@gmail.com",
        "created_at":"2020-11-06T14:44:59.000000Z",
        "updated_at":"2020-11-06T14:44:59.000000Z"
    }
}
```

### Retrieve User by Id (GET): 

- **/api/users/{id}**
- **id**: number representing the primary key
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X GET http://laravel-api-backend.localhost/api/users/1
```

The output:

```json
{
    "user":{
        "id":1,
        "name":"Juliano Maciel",
        "email":"ju.maciel.ferreira@gmail.com",
        "created_at":"2020-11-06T00:39:50.000000Z",
        "updated_at":"2020-11-06T00:39:50.000000Z"
    }
}
```

or:

```json
{
    "message":"user not found!"
}
```

### List all Users (GET): 

- **/api/users**
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X GET http://laravel-api-backend.localhost/api/users
```

The output:

```json
{
    "users":[
        {
            "id":1,
            "name":"Juliano Maciel",
            "email":"ju.maciel.ferreira@gmail.com",
            "created_at":"2020-11-06T00:39:50.000000Z",
            "updated_at":"2020-11-06T00:39:50.000000Z"
            },
        {
            "id":2,
            "name":"Juliano Maciel",
            "email":"ju.maciel.ferreira98@gmail.com",
            "created_at":"2020-11-06T12:24:20.000000Z",
            "updated_at":"2020-11-06T12:24:20.000000Z"
        }
    ]
}
```

### List all Articles (GET): 

- **/api/articles**
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X GET http://laravel-api-backend.localhost/api/articles/
```

The output:

```json
{ 
    "articles": 
    [
        {
            "id":1,
            "user_id":1,
            "title":"Title",
            "description":"Description",
            "status":1,
            "created_at":"2020-11-04T15:12:49.000000Z",
            "updated_at":"2020-11-04T15:12:49.000000Z"
        },{
            "id":2,
            "user_id":1,    
            "title":"Title",
            "description":"Description",
            "status":1,
            "created_at":"2020-11-04T15:12:50.000000Z",
            "updated_at":"2020-11-04T15:12:50.000000Z"
        }
    ]
}
```

### List all Articles By User (GET): 

- **/api/articles/by-user/{user_id}**
- **user_id**: number representing the foreign key
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X GET http://laravel-api-backend.localhost/articles/by-user/1
```

The output:

```json
{ 
    "articles": 
    [
        {
            "id":1,
            "user_id":1,
            "title":"Title",
            "description":"Description",
            "status":1,
            "created_at":"2020-11-04T15:12:49.000000Z",
            "updated_at":"2020-11-04T15:12:49.000000Z"
        },{
            "id":2,
            "user_id":1,    
            "title":"Title",
            "description":"Description",
            "status":1,
            "created_at":"2020-11-04T15:12:50.000000Z",
            "updated_at":"2020-11-04T15:12:50.000000Z"
        }
    ]
}
```

### Retrieve Article by Id (GET):

- **/api/articles/{id}**
- **id**: number representing the primary key
- **Needs token.**

Example:

```bash
$ curl -H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X GET http://laravel-api-backend.localhost/api/articles/1
```

The output:

```json
{
    "article": {
        "id":2,
        "user_id":1,
        "title":"Title New",
        "description":"Description New",
        "status":1,
        "created_at":"2020-11-06T00:06:37.000000Z",
        "updated_at":"2020-11-06T00:06:37.000000Z"
    }
}
```

### Create an Article (POST): 

- **/api/articles**
- **Needs token.**

Example:

```bash
$ curl -d '{"user_id":1,"title":"Title New","description":"Description New","status":1}' \
-H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X POST http://laravel-api-backend.localhost/api/articles
```

The output:

```json
{
    "article": {
        "user_id":1,
        "title":"Title New",
        "description":"Description New",
        "status":"1",
        "updated_at":"2020-11-06T12:27:00.000000Z",
        "created_at":"2020-11-06T12:27:00.000000Z",
        "id":800
    },
    "message":"CREATED"
}
```

### Update an Article by Id (PUT): 

- **/api/articles/{id}**
- **id**: number representing the primary key
- **Needs token.**

Example:

```bash
$ curl -d '{"user_id":1,"id":1, "title":"Title Updated","description":"Description Updated","status":1}' \
-H "Content-Type: application/json" \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X PUT http://laravel-api-backend.localhost/api/articles/19
```

The output:

```json
{
    "article":{
        "id":19,
        "user_id":1,
        "title":"Title Update",
        "description":"Description Update",
        "status":"1",
        "created_at":"2020-11-06T00:06:39.000000Z",
        "updated_at":"2020-11-06T00:06:48.000000Z"
    },
    "message":"UPDATED"
}
```

### Delete an Article (DELETE): 

- **/api/articles/{id}**
- **id**: number representing the primary key
- **Needs token.**

Example:

```bash
$ curl \
-H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
-X DELETE http://laravel-api-backend.localhost/api/articles/19
```

The output:

```json
{
    "message": "DELETED"
}
```

## Lumen PHP Framework

[![Build Status](https://travis-ci.org/laravel/lumen-framework.svg)](https://travis-ci.org/laravel/lumen-framework)
[![Total Downloads](https://poser.pugx.org/laravel/lumen-framework/d/total.svg)](https://packagist.org/packages/laravel/lumen-framework)
[![Latest Stable Version](https://poser.pugx.org/laravel/lumen-framework/v/stable.svg)](https://packagist.org/packages/laravel/lumen-framework)
[![License](https://poser.pugx.org/laravel/lumen-framework/license.svg)](https://packagist.org/packages/laravel/lumen-framework)

Laravel Lumen is a stunningly fast PHP micro-framework for building web applications with expressive, elegant syntax. We believe development must be an enjoyable, creative experience to be truly fulfilling. Lumen attempts to take the pain out of development by easing common tasks used in the majority of web projects, such as routing, database abstraction, queueing, and caching.

## Official Documentation

Documentation for the framework can be found on the [Lumen website](https://lumen.laravel.com/docs).

## Contributing

Thank you for considering contributing to Lumen! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Security Vulnerabilities

If you discover a security vulnerability within Lumen, please send an e-mail to Taylor Otwell at taylor@laravel.com. All security vulnerabilities will be promptly addressed.

## License

The Lumen framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## References

- [Laravel](https://laravel.com/)
- [The Lumen framework](https://lumen.laravel.com/)
- [vendor:publish for Lumen framework](https://github.com/laravelista/lumen-vendor-publish)
- [JSON Web Token Authentication for Laravel & Lumen](https://jwt-auth.readthedocs.io/en/develop/)
- [Build a JWT Authenticated API with Lumen(v5.8)](https://dev.to/ndiecodes/build-a-jwt-authenticated-api-with-lumen-2afm)
- [AUTENTICAÇÃO EM API REST UTILIZANDO JWT | LARAVEL TIPS #018](https://www.youtube.com/watch?v=Ri-DLFeepbM)
- [Fix Error “CORS” For Laravel Lumen Application](https://medium.com/@afrimadonidinata/fix-error-cors-for-laravel-lumen-application-8ac24d85ea71)
- [MySQL](https://mysql.com)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [nginx](https://nginx.org/)
- [Xdebug](https://xdebug.org/)