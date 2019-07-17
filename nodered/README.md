# Node Red Project for Medical API

## Project Description
Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways. The light-weight runtime is built on Node.js, taking full advantage of its event-driven, non-blocking model.
This project is designed for several APIs storing and retrieving various medical data.
The medical data is stored in Redis database which is the fastest database now.
This project is well-designed, easy to maintain and extend and well-documented as well.


## Overview of Approach

![NodeRed flow](/img/NodeRed_JSON_Redis_exp2.PNG)

## Project Flow Guide
```
  JSON-REDIS-SECOND-TAB holds main flow for API.
    The first 4 lines are for Create Action.
      First, it accepts "/patient/[patientID]/allergies(or medications or problems)" type URL with Http POST Request Node.
      Then, retrieve post params and generate data for Redis Command.
      After saving data to redis, the respond with sucess result.
    The next 4 lines are for Read Action.
      First, it accepts "/patient/[patientID]/allergies/[sourceID]" type URL with Http GET Request Node.
      And the these nodes are described in details in the previous version.
    The next 4 lines are for Update Action.
      First, it accepts "/patient/[patientID]/allergies/[sourceID]" type URL with Http PUT Request Node.
      It looks for redis database if the data is exist so that it could be updated.
      "Redis HEXISTS Params, Redis hexist, Check the Result" nodes are used for this operation.
      Once it's determined that the data exists in the database, update data with Redis HSET command.
      "Join Success Result, Redis HSET Params, Redis HSET" nodes are used for this operation.
    The next 4 lines are for Delete Action.
      First, it accepts "/patient/[patientID]/allergies/[sourceID]" type URL with Http DELETE Request node.
      Delete data from redis database using Redis HDEL command and check for result if the data is deleted successfully.
    The next 3 lines are for Synopsis Headings API.
      First, it accepts "/patient/[patientID]/synopsis/allergies(or medications or problems) type URL with Http GET Request node.
      It looks for redis database and retrieve all the data related to that patient and data type.
      "Redis HKEYS Params, Redis hkeys, Check the result" nodes are used for this operation.
      Then, it retrieves up to 4 datasets for related patient and datatype.
      "Join Keys data, Redis HMGET params, Redis hmget, Synopsis JSON string, Synopsis JSON object, Make synopsis Object" nodes are used for this operation.
      After that, it formats synopsis data to {"heading": "allegies", "synopsis":[], "token":''} type and respond.
    The next 4 lines are for Patient CRUD API.
      It accepts Http requests and manipulate data in the similar way as other CRUD Actions.
      However, in this case, you have to notice that the name table should be created automatically for user search.
  
  JSON-REDIS-TEST holds test flow for API.
      "Create Test" Line is for testing Create operation with random data.
      "Update Test" Line is for testing Update operation with some data which is described in "Generate Data for Update" node.
      "Delete Test" Line is for testing Delete operation with data which is described in "Generate Data for Delete" node.
      "Synopsis Test" Lines are for testing Synopsis Heading.
      "Data Test" Lines are for testing Read operations for specific data source.
      All the Test Nodes are injectable, which means it runs when you click on the left button on the node and you can see the result in the debug panel.
      "Patient Create, Update, Delete" Tests are for testing CRUD for Patients.
```

## Nodes Description in the flow
```
    Type                   Name                                         Description
    
    Http        [post] /patient/:ptId/allergies     For API post requests. You can simply add new API
                                                    routes for POST by adding this node and change the
                                                    URL property of the node.

    Http        [get] /patient/:ptId/allergies      For API get requests. You can simply add new API
                                                    routes for GET by adding this node and change the
                                                    URL property of the node.

    Change              PostParams                  This node accepts POST request parameters and
                                                    convert the datatype so that it can be used
                                                    for storing data in the redis database.
                                                    You have to add this node as well as  Http node when 
                                                    you add new API routes for POST. And then configure
                                                    the node using JSONata. Have a look at existing node
                                                    and get some ideas for configuring the node.

    Change              GetParams                   This node is almost same as PostParams node. It just
                                                    change datatype so that it can be used for retrieving
                                                    data from redis.

    Function         Redis HSET params              This node generates data for HSET command in redis. 
                                                    Return an array of parameters for HSET command. 
                                                    HSET command requires three parameters in array form.
                                                    [key, field, value]

    Function         Redis HGET params              This node generates data for HGET command in redis.
                                                    Return an array of parameters for HGET command.
                                                    HGET command requires two parameters in array form.
                                                    [key, field]

    Function         Transform method               This node extracts transform value from request query
                                                    parameters. It is used for transform of JSON data.

    Redis cmd           Redis hset                  Executes the HSET command in redis.
                                                    Have a look at node configuration.

    Redis cmd           Redis hget                  Executes the HGET command in redis.
                                                    Have a look at node configuration.

    Function            Result JSON                 JSON data for response when API Post request is successed.

  Http response        Post Success                 Makes an HTTP response with success info.

    Switch              switch                      Switch node for checking HGET result from redis.
                                                    If the return value is null, make a HTTP response promptly.
                                                    Otherwise, response with JSON data.

  Http response         GET No Data                 Makes an HTTP response with string 'null'

     JSON              Database JSON                The HGET result is string for JSON data.
                                                    We change the string to a JSON object using this node.

     JOIN           Add transform method            This node joins two objects, one is JSON object from database
                                                    and another one has transform method.

    Switch            Transform Switch              This switch is used for checking transform type. You can add
                                                    more transform type by editing this node.
                                                    Have a look at node configuration and get some idea.

    Change         TransformA-Allergy-UI2openEHR    These node apply transform to the JSON object retrieved
                                                    from database. If you want to add new transform,
                    TransformB-Allergy-UI2FHIR      add another node which is similar to this one
                                                    and configure the node. You can get idea for configuration
                                                    by looking at current configuration.

    Function            No Transform                This node removes transform property from JSON object.
                                                    This is needless for our results.

  Http response         GET success                 Makes an HTTP response with final result.
```
