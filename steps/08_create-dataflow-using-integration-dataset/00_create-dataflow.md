# Create Dataflow using the integration datasets

In this section, you will use integration datasets for creating a dataflow for loading data into lake database.

## Create Dataflow – adworks_DF

1.	Select “Develop” from menu then  click on “+”  and select option Dataflow and give name as “adworks_DF” under properties.

 ![Dataflow](./assets/df1.jpg "Create Dataflow")
 
 ![Dataflow](./assets/df2.jpg "Create Dataflow")
 
2.	Create new Parameter and name as “tableName”
 ![Dataflow](./assets/df1.jpg "Create Dataflow")
3.	Click on Add source, it will display prepopulated options. Then select “AddSource”.
4.	Under source settings give 
5.	Output stream name as “CSVSource”,
6.	 select sourcetype “integration dataset” 
7.	Select dataset  as “adworksraw” 
8.	Set below options as true
  I.	Allow schema drift
  II.	Infer drifted column types

  ![Dataflow](./assets/df1.jpg "Create Dataflow")
  
9.	Select “+” icon beside CSVSource and select “Sink” as source

  ![Dataflow](./assets/df1.jpg "Create Dataflow")
  
10.	Set output stream name as “adworksSink”
11.	Select incoming stream as “CSVSource”
12.	Select Sinktype as “WorkspaceDB”
13.	Select Database “adworks”
14.	Set Table as “ $tableName “ 

  ![Dataflow](./assets/df1.jpg "Create Dataflow")
  
15.	Select “Recreate table” as Table action under settings.

  ![Dataflow](./assets/df1.jpg "Create Dataflow")
 
16.	Select Mapping and select below checkboxes
    i.	Skip duplicate input column
    ii.	Skip duplicate output column
    
   ![Dataflow](./assets/df1.jpg "Create Dataflow")

     


