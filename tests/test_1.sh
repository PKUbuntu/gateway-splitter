#!/bin/bash

curl -X POST http://localhost:8080/transform \
     -H "Content-Type: application/json" \
     -d '{ 
     	   "param_1": "value1", 
	   "param_2": 2, 
	   "param_3": [1, 2, 3], 
	   "param_4": {
	   	      "inner_param_1": "inner_1"
           }
	}'


