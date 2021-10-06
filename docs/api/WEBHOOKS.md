
# Webhooks


## Webhook

Allowed methods: GET, PUT, DELETE, OPTIONS

### GET

#### Request

Path: `/webhooks/:uuid`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "uuid": "d2181b32-8b03-4daf-8cc0-d9168b2f6fac",
  "description": "POST example.org",
  "consumer": {
    "name": "Foo"
  },
  "provider": {
    "name": "Bar"
  },
  "enabled": true,
  "request": {
    "method": "POST",
    "url": "http://example.org",
    "headers": {
      "Content-Type": "application/json"
    }
  },
  "events": [
    {
      "name": "contract_content_changed"
    }
  ],
  "createdAt": "2021-09-01T10:00:00+00:00",
  "_links": {
    "self": {
      "title": "POST example.org",
      "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac"
    },
    "pb:execute": {
      "title": "Test the execution of the webhook with the latest matching pact or verification by sending a POST request to this URL",
      "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac/execute"
    },
    "pb:consumer": {
      "title": "Consumer",
      "name": "Foo",
      "href": "http://example.org/pacticipants/Foo"
    },
    "pb:provider": {
      "title": "Provider",
      "name": "Bar",
      "href": "http://example.org/pacticipants/Bar"
    },
    "pb:pact-webhooks": {
      "title": "All webhooks for consumer Foo and provider Bar",
      "href": "http://example.org/webhooks/provider/Bar/consumer/Foo"
    },
    "pb:webhooks": {
      "title": "All webhooks",
      "href": "http://example.org/webhooks"
    }
  }
}
```



## Pact triggered webhooks

Allowed methods: GET, OPTIONS

### GET

#### Request

Path: `/pacts/provider/:provider_name/consumer/:consumer_name/version/:consumer_version_number/triggered-webhooks`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_embedded": {
    "triggeredWebhooks": [
      {
        "name": "POST example.org",
        "status": "not_run",
        "attemptsMade": 1,
        "attemptsRemaining": 6,
        "triggerType": "resource_creation",
        "eventName": "contract_content_changed",
        "triggeredAt": "2021-09-01T10:00:00+00:00",
        "_links": {
          "pb:logs": {
            "href": "http://example.org/triggered-webhooks/6cd5cc48-db3c-4a4c-a36d-e9bedeb9d91e/logs",
            "title": "Webhook execution logs",
            "name": "POST example.org"
          },
          "pb:webhook": {
            "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac",
            "title": "Webhook",
            "name": "POST example.org"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "title": "Webhooks triggered by the publication of the pact between Foo (2) and Bar",
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/version/2/triggered-webhooks"
    }
  }
}
```



## Webhooks

Allowed methods: GET, POST, OPTIONS

### GET

#### Request

Path: `/webhooks`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_links": {
    "self": {
      "title": "Webhooks",
      "href": "http://example.org/webhooks"
    },
    "pb:create": {
      "title": "POST to create a webhook",
      "href": "http://example.org/webhooks"
    },
    "pb:webhooks": [
      {
        "title": "A webhook for the pact between Foo and Bar",
        "name": "POST example.org",
        "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac"
      }
    ],
    "curies": [
      {
        "name": "pb",
        "href": "http://example.org/doc/webhooks-{rel}",
        "templated": true
      }
    ]
  }
}
```



## Pact webhooks

Allowed methods: POST, GET, OPTIONS

### GET

#### Request

Path: `/pacts/provider/:provider_name/consumer/:consumer_name/webhooks`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_links": {
    "self": {
      "title": "Pact webhooks",
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/webhooks"
    },
    "pb:create": {
      "title": "POST to create a webhook",
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/webhooks"
    },
    "pb:webhooks": [
      {
        "title": "A webhook for the pact between Foo and Bar",
        "name": "POST example.org",
        "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac"
      }
    ],
    "curies": [
      {
        "name": "pb",
        "href": "http://example.org/doc/webhooks-{rel}",
        "templated": true
      }
    ]
  }
}
```



## Webhooks for consumer and provider

Allowed methods: POST, GET, OPTIONS

### GET

#### Request

Path: `/webhooks/provider/:provider_name/consumer/:consumer_name`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_links": {
    "self": {
      "title": "Webhooks",
      "href": "http://example.org/webhooks/provider/Bar/consumer/Foo"
    },
    "pb:create": {
      "title": "POST to create a webhook",
      "href": "http://example.org/webhooks/provider/Bar/consumer/Foo"
    },
    "pb:webhooks": [
      {
        "title": "A webhook for the pact between Foo and Bar",
        "name": "POST example.org",
        "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac"
      }
    ],
    "curies": [
      {
        "name": "pb",
        "href": "http://example.org/doc/webhooks-{rel}",
        "templated": true
      }
    ]
  }
}
```



## Triggered webhook logs

Allowed methods: GET, OPTIONS

### GET

#### Request

Path: `/triggered-webhooks/:trigger_uuid/logs`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"text/plain;charset=utf-8"}`<br/>
Body:

```
logs
```



## Verification webhooks

Allowed methods: GET, OPTIONS

### GET

#### Request

Path: `/pacts/provider/:provider_name/consumer/:consumer_name/pact-version/:pact_version_sha/verification-results/:verification_number/triggered-webhooks`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_embedded": {
    "triggeredWebhooks": [

    ]
  },
  "_links": {
    "self": {
      "title": "Webhooks triggered by the publication of verification result 1",
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/pact-version/3e193ecb37ad04b43ce974a38352c704b2e0ed6b/verification-results/1/triggered-webhooks"
    }
  }
}
```



## Webhooks status

Allowed methods: GET, OPTIONS

### GET

#### Request

Path: `/pacts/provider/:provider_name/consumer/:consumer_name/webhooks/status`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "summary": {
    "successful": 0,
    "failed": 0,
    "notRun": 1
  },
  "_embedded": {
    "triggeredWebhooks": [
      {
        "name": "POST example.org",
        "status": "not_run",
        "attemptsMade": 1,
        "attemptsRemaining": 6,
        "triggerType": "resource_creation",
        "eventName": "contract_content_changed",
        "triggeredAt": "2021-09-01T10:00:00+00:00",
        "_links": {
          "pb:logs": {
            "href": "http://example.org/triggered-webhooks/6cd5cc48-db3c-4a4c-a36d-e9bedeb9d91e/logs",
            "title": "Webhook execution logs",
            "name": "POST example.org"
          },
          "pb:webhook": {
            "href": "http://example.org/webhooks/d2181b32-8b03-4daf-8cc0-d9168b2f6fac",
            "title": "Webhook",
            "name": "POST example.org"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/webhooks/status",
      "title": "Webhooks status"
    },
    "pb:error-logs": [

    ],
    "pb:pact-webhooks": {
      "title": "Webhooks for the pact between Foo and Bar",
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/webhooks"
    },
    "pb:pact-version": {
      "href": "http://example.org/pacts/provider/Bar/consumer/Foo/version/2",
      "title": "Pact",
      "name": "Pact between Foo (2) and Bar"
    },
    "pb:consumer": {
      "href": "http://example.org/pacticipants/Foo",
      "title": "Consumer",
      "name": "Foo"
    },
    "pb:provider": {
      "href": "http://example.org/pacticipants/Bar",
      "title": "Provider",
      "name": "Bar"
    }
  }
}
```



## Webhooks for consumer

Allowed methods: POST, GET, OPTIONS

### GET

#### Request

Path: `/webhooks/consumer/:consumer_name`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_links": {
    "self": {
      "title": "Webhooks",
      "href": "http://example.org/webhooks/consumer/Foo"
    },
    "pb:create": {
      "title": "POST to create a webhook",
      "href": "http://example.org/webhooks/consumer/Foo"
    },
    "pb:webhooks": [

    ],
    "curies": [
      {
        "name": "pb",
        "href": "http://example.org/doc/webhooks-{rel}",
        "templated": true
      }
    ]
  }
}
```



## Executing a saved webhook

Allowed methods: POST, OPTIONS

### POST

#### Request

Path: `/webhooks/:uuid/execute`<br/>
Headers: `{"Content-Type":"application/json","Accept":"application/hal+json"}`<br/>

#### Response

Status: `404`<br/>
Headers: `{"Content-Type":"text/html"}`<br/>
Body:

```
<!DOCTYPE html><html>
 <head><title>404 Not Found</title></head>
 <body><h1>404 Not Found</h1>
 <p>The requested document was not found on this server.</p>
 <address>Webmachine-Ruby/1.6.0 server</address></body></html>

```



## Webhooks for a provider

Allowed methods: POST, GET, OPTIONS

### GET

#### Request

Path: `/webhooks/provider/:provider_name`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "_links": {
    "self": {
      "title": "Webhooks",
      "href": "http://example.org/webhooks/provider/Bar"
    },
    "pb:create": {
      "title": "POST to create a webhook",
      "href": "http://example.org/webhooks/provider/Bar"
    },
    "pb:webhooks": [

    ],
    "curies": [
      {
        "name": "pb",
        "href": "http://example.org/doc/webhooks-{rel}",
        "templated": true
      }
    ]
  }
}
```



## Logs of triggered webhook for webhook

Allowed methods: GET, OPTIONS

### GET

#### Request

Path: `/triggered-webhooks/:uuid/logs`<br/>
Headers: `{"Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"text/plain;charset=utf-8"}`<br/>
Body:

```
logs
```



## Executing an unsaved webhook

Allowed methods: POST, OPTIONS

### POST

#### Request

Path: `/webhooks/execute`<br/>
Headers: `{"Content-Type":"application/json","Accept":"application/hal+json"}`<br/>

#### Response

Status: `200`<br/>
Headers: `{"Content-Type":"application/hal+json;charset=utf-8"}`<br/>
Body:

```
{
  "request": {
    "headers": {
      "accept": "application/json",
      "user-agent": "Pact Broker v2.87.0",
      "authorization": "**********"
    },
    "body": {
      "a": "body"
    },
    "url": "/post"
  },
  "response": {
    "status": 200,
    "headers": {
    },
    "body": ""
  },
  "logs": "[2021-09-01T10:07:21Z] DEBUG: Webhook context {\"base_url\":\"http://example.org\",\"event_name\":\"test\"}\n[2021-09-01T10:07:21Z] INFO: HTTP/1.1 POST https://postman-echo.com/post\n[2021-09-01T10:07:21Z] INFO: accept: application/json\n[2021-09-01T10:07:21Z] INFO: user-agent: Pact Broker v2.87.0\n[2021-09-01T10:07:21Z] INFO: authorization: **********\n[2021-09-01T10:07:21Z] INFO: {\"a\":\"body\"}\n[2021-09-01T10:07:21Z] INFO: HTTP/1.0 200 \n[2021-09-01T10:07:21Z] INFO: \n",
  "success": true,
  "_links": {
  }
}
```


