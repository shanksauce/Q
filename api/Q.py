import os
import inspect
import config
import pika
from json import dumps
from uuid import uuid4
from pymongo import MongoClient
from pymongo import errors as pymongo_errors
from bson.json_util import dumps, loads
from bson.objectid import ObjectId
from tornado import web, ioloop
from base64 import standard_b64encode

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.exchange_declare(exchange=config.EXCHANGE, type='direct')

mongoClient = MongoClient(config.MONGO_CONNECTION_STRING)
db = mongoClient[config.MONGO_DATABASE]


class APIHandler(web.RequestHandler):
  def _validate_request(self, path):
    if path is None:
      return False
    methods = [x for x in dir(self) if x == path]
    if len(methods) != 1:
      return False
    else:
      return getattr(self, methods[0], None)

  def options(self, path=None, json=None):
    pass

  def post(self, path=None, json=None):
    method = self._validate_request(path)
    if not method:
      return
    payload = loads(self.request.body)
    if len([m for m in inspect.getargspec(method).args if m != 'self']) == 1:
      method(payload)

  def get(self, path=None, json=None):
    method = self._validate_request(path)
    if not method:
      return
    args = [] if json is None else loads(json)
    if len([m for m in inspect.getargspec(method).args if m != 'self']) == len(args):
      method(*args)
      
  def get_vendors(self):
    self.write(dumps(db['Merchants'].find()))

  def get_length(self, id):
    l = -1
    if self.check_queue_exists(id):
      q = channel.queue_declare(queue=id, durable=True)
      l = q.method.message_count
    self.write(dumps({'length': l, 'queue': id}))

  def add(self, id, message):
    channel.basic_publish(exchange=config.EXCHANGE, routing_key=id, body=message, properties=pika.BasicProperties(delivery_mode=2))
    self.write(dumps({'errors': 'OK'}))
  
  def remove(self, id, body):
    l = -1
    if self.check_queue_exists(id):
      q = channel.queue_declare(queue=id, durable=True)
      l = q.method.message_count
    if l != -1:
      for i in xrange(0,l):
        msg = channel.basic_get(queue=id, no_ack=True)
        print msg[0].delivery_tag
#        if msg[2] == body:
#          channel.basic_ack(delivery_tag=msg[0].delivery_tag);
  
  def register_vendor(self, id):
    channel.queue_declare(queue=id, durable=True)
    self.write(dumps({'error': 'OK'}))

  def check_queue_exists(self, id):
    b = True
    try:
      channel.queue_bind(exchange=config.EXCHANGE, queue=id)
    except Exception as ex:
      b = False
    return b

class NullHandler(web.RequestHandler):
  def initialize(self): 
    self.set_header('Connection', 'Close')
  def head(self): 
    pass
  def get(self): 
    pass

if __name__ == '__main__':
  print 'Starting...'
  base_dir = os.path.join(os.path.dirname(__file__), 'templates')
  settings = {
    'gzip': True,
    'debug': True
#    'template_path': base_dir,
#    'static_path': base_dir+'/static',
#    'cookie_secret': '47c8ec8a7c4c451fa18ea72e7146f34c6c6a61e5e911478d977ce776712d879a'
  }

  app = web.Application([
    ('/favicon.ico', NullHandler),
    ('/(.*)/(.*)', APIHandler),
  ], **settings)
  app.listen(config.PORT)

  ioloop.IOLoop.instance().start()


