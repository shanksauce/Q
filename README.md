Q - It waits in line so you don't have to.

This repository contains the PHP-based API and iOS client code for Q. It 
may make sense to split these into separate projects at some point.

The API uses php-amqplib and ClassLoader, respectively located at:

  https://github.com/videlalvaro/php-amqplib

and

  https://github.com/symfony/ClassLoader

Both projects should be cloned into the api directory.

It also requires RabbitMQ, which can be found at:

  http://www.rabbitmq.com/

You might also want to have a MongoDB instance sitting somewhere to
store a list of merchants/vendors that could utilize a queuing system.
