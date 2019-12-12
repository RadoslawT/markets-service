# README

## API docs
Markets: https://app.swaggerhub.com/apis-docs/radoslawt5/alerts-app#/markets  

## Consumers

### AlertSet
Topic: `alerts-alert`  
Name: `alert_set`  
Params:

| Param name       | Param type |
| ------------- |-------------:|
| alert_uuid       | string |
| user_uuid        | string |
| market_uuid      | string |
| activation_price | float  |
| trigger_price    | float  |

## Events

### MarketTaskCompleted
Topic: `market-task-completed`  
Name: `market_task_completed`  
Params:

| Param name       | Param type |
| ------------- |-------------:|
| market_uuid      | string |
| completion_price | float  |
| type             | string |
