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

  def register_vendor(self, id):
    channel.queue_declare(exchange=config.EXCHANGE, type='direct')
    channel.queue_bind(exchange=config.EXCHANGE, queue=id)
    self.write(dumps({'error': 'OK'}))

  def check_queue_exists(self, id):
    print self
    b = True
    try:
      channel.queue_bind(exchange=config.EXCHANGE, queue='test')
    except Exception as ex:
      print ex
    return b





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
    ('/(.*)/(.*)', APIHandler),
  ], **settings)
  app.listen(config.PORT)

  ioloop.IOLoop.instance().start()


'''
class Q():
    private static $connection;
    private static $channel;
    private static $exchange = EXCHANGE;

    private static $mongo;
    private static $db;

    private $length;

    public function __construct() {
        self::$connection = new AMQPConnection(HOST, PORT, USER, PASS, VHOST);
        self::$channel = self::$connection->channel();
        self::$channel->exchange_declare(self::$exchange, "direct", false, true, false);

        self::$mongo = new Mongo();
        self::$db = self::$mongo->Q;
    }

    public function __destruct() {
        self::$channel->close();
        self::$connection->close();
    }

    public function registerMerchant($id) {
        self::$channel->queue_declare($id, false, true, false, false);
        self::$channel->queue_bind($id, self::$exchange, $id);
	return json_encode(array("Response" => "OK", "Result" => "Successfully added ".$id));
    }

    public function getMerchants() {
        $collection = self::$db->Merchants;
        $cursor = $collection->find();
        
        $result = array();

        foreach($cursor as $k) {
            if(isset($k["_id"])) {
                $k["_id"] = $k["_id"]->__toString();
            }
            $result[] = $k;
        }

        return json_encode($result);
    }

    private function checkQueueExists($id) {
        $b = true;

        try {
            self::$channel->queue_bind($id, self::$exchange, $id);
        } catch(AMQPChannelException $ex) {
            if($ex->getCode() === 404) $b = false;
        }

        return $b;
    }

    public function getLength($id) {
        $numInFront = array(0, -1);
        if($this->checkQueueExists($id)) {
            $numInFront = self::$channel->queue_declare($id, false, true, false, false);
        }
        $this->length = $numInFront[1];
        return json_encode(array("Response" => "OK", "numInFront" => $numInFront[1]));
    }

    public function add($id, $body) {
        $msg_body = json_encode(array("Test" => $body));
        $message = new AMQPMessage($msg_body, array("content_type" => "text/json", "delivery-mode" => 2));
        self::$channel->basic_publish($message, self::$exchange, $id);
        return json_encode(array("Response" => "OK"));
    }
    
    public function remove($id, $body) {
        $this->getLength($id);

        for($i=0; $i<$this->length; ++$i) {
            $msg = self::$channel->basic_get($id);
            $sourceBody = json_decode($msg->body);
            if($sourceBody->Test === $body) {
                self::$channel->basic_ack($msg->delivery_info['delivery_tag']);
            }
        }
    }
}
'''

