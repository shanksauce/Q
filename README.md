Q
=

It waits in line so you don't have to.
--------------------------------------

This repository contains the PHP-based API and iOS client code for Q. It 
may make sense to split these into separate projects at some point.

The API uses php-amqplib and ClassLoader, respectively located at:

    https://github.com/videlalvaro/php-amqplib

and

    https://github.com/symfony/ClassLoader

Both projects have been included as submodules. You should be able to get 
away with running:
   
    git submodule init
    git submodule update
    
Q also requires RabbitMQ, which can be found at:

    http://www.rabbitmq.com/

Additionally, Q requires a MongoDB instance sitting somewhere to store a list of 
merchants/vendors that could utilize a queuing system.