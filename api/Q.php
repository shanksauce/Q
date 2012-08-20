<?php
//
//  Q API
//
//  Created by Ben Shank on 4/3/12.
//  Copyright (c) 2012 Aol. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  For the full copyright and license information, please view the 
//  LICENSE file that was distributed with this source code.
//

include("config.php");
use PhpAmqpLib\Connection\AMQPConnection;
use PhpAmqpLib\Message\AMQPMessage;
use PhpAmqpLib\Exception\AMQPChannelException;

class Q {
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
?>
