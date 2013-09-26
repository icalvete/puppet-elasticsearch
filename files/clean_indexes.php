<?php

function call_curl($url, $method='GET')
{
        // create a new cURL resource
        $ch = curl_init();

        // set URL and other appropriate options
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        if ($method == 'DELETE') {
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
        }
        // grab URL and pass it to the browser
        $res = curl_exec($ch);
        curl_close($ch);
        return $res;
}

function get_from_elasticsearch($url)
{
        return call_curl($url);
}

function del_to_elasticsearch($url)
{
        return call_curl($url, 'DELETE');
}

$node_status = get_from_elasticsearch('http://localhost:9200/_status');
$obj_node_status = json_decode($node_status);

$today=date('Y-m-d', time());
foreach ($obj_node_status->indices as $key => $value ) {
        preg_match('/^logstash-([0-9]{4})\.([0-9]{2})\.([0-9]{2})/', $key, $matches);
        $index = $matches[1].'-'.$matches[2].'-'.$matches[3];
        $index_date = date_create($index);
        $today_date = date_create($today);
        
	$interval = date_diff($index_date, $today_date);
	if ((int) $interval->format('%a') >= 10)
        {
                $url = "http://localhost:9200/$key/";
                del_to_elasticsearch($url);
        }
}

// close cURL resource, and free up system resources
?>
