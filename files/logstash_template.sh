#!/bin/bash
curl -XPUT http://localhost:9200/_template/logstash_per_index -d '
{
	"template" : "logstash*",
        "settings" : {
                "index.store.compress.stored" : "true",
                "index.cache.field.type" : "soft"
        },
        "mappings" : {
                "_default_" : {
                        "_all" : {"enabled" : false},
			"_source": { "compress": true },
                        "properties" : {
                                "@fields" : {
                                        "type" : "object",
                                        "dynamic": true,
                                        "path": "full",
                                        "properties" : {
                                                "errnum" : { "type": "integer"}
                                        }
                                },

				"@message": { "type": "string", "index": "analyzed" },
				"@source": { "type": "string", "index": "not_analyzed" },
				"@source_host": { "type": "string", "index": "not_analyzed" },
				"@source_path": { "type": "string", "index": "not_analyzed" },
				"@tags": { "type": "string", "index": "not_analyzed" },
				"@timestamp": { "type": "date", "index": "not_analyzed" },
				"@type": { "type": "string", "index": "not_analyzed" }
                        }
                }
        }
}
'
