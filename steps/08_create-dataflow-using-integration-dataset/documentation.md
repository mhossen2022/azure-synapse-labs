# Create Dataflow using the integration datasets

In this section, you will use integration datasets for creating a dataflow for loading data into lake database.

## Create Dataflow – adworks_DF

1.	Select **_Develop_** from menu then  click on **+**  and select option **_Dataflow_** and give name as **_``adworks_DF``_** under properties.

 ![Dataflow](./assets/df1.jpg "Create Dataflow")
 
 ![Dataflow](./assets/df2.jpg "Create Dataflow")
 
2.	Create new Parameter and name as **_``tableName``_**.

 ![Dataflow](./assets/df3.jpg "Create Dataflow")
 
3.	Click on **Add source**, it will display prepopulated options. Then select **AddSource**.

 ![Dataflow](./assets/df4.jpg "Create Dataflow")

4.	Under source settings give 

5.	Output stream name as **_``CSVSource``_**.

6.	Select sourcetype **_integration dataset_** .

7.	Select dataset  as **_adworksraw_**.

8.	Set below options as **true**.

   i.	 Allow schema drift
  ii.  Infer drifted column types

  ![Dataflow](./assets/df5.jpg "Create Dataflow")
  
9.	Select **+** icon beside CSVSource and select **_Sink_** as source.

  ![Dataflow](./assets/df6.jpg "Create Dataflow")
  
10.	Set output stream name as **_``adworksSink``_**.

11.	Select incoming stream as **_CSVSource_**.

12.	Select Sinktype as **_WorkspaceDB_**.

13.	Select Database **_adworks_**.

14.	Set Table as **_``$tableName``_**.

  ![Dataflow](./assets/df7.jpg "Create Dataflow")
  
15.	Select **_Recreate table_** as Table action under settings.

  ![Dataflow](./assets/df9.jpg "Create Dataflow")
 
16.	Select **_Mapping_** and select below checkboxes
    
    i.	 Skip duplicate input column
    
   ii.  Skip duplicate output column
    
   ![Dataflow](./assets/df8.jpg "Create Dataflow")

     


