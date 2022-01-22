# Batch Data and Streaming Data

## Batch Data

Periodically transfer data to another database for analytical querying

## Streaming Data

Continuously calculate new analytical query results when data is added or updated

## Differences

### Batch Data

1. Executes on a schedule

2. All data is stored for analytical querying 

3. Query the data after loading

4. Easy joining of databases

5. Efficiency opportunities

6. Aligns with existing skills (with traditional database)


### Streaming Data

1. Executes near real-time

2. Only results are stored, no other data

3. Queries are predefined

4. Combining datasets is more difficult 


## How to do analysis by using Streaming  Data

![image-20211124120224213](C:\Users\qgu4\AppData\Roaming\Typora\typora-user-images\image-20211124120224213.png)

Azure SQL DB cannot stream updates into another system, while  stream analytics is not capable of polling an 

Azure SQL DB database for updates. So we need to change the architecture of the system.

![image-20211124120737715](C:\Users\qgu4\AppData\Roaming\Typora\typora-user-images\image-20211124120737715.png)

1. Send the new message to the event hub instead of sending it to Azure SQL DB directly
2. Event Hub will forward the messages in same order to multiple consumers (SQL DB and Stream Analytics)
3. The message sent to Azure SQL DB will make sure the original functionality is still there;
4. Since Stream Analytics only have the newly updated message not all data, so it has to retrieve data from Azure SQL Database (look up on reference data, data needed but not stored in Stream analytics)
5. Stream Analytics generates the results