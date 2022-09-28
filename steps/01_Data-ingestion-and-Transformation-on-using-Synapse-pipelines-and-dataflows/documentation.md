Data_transformation_using_pipeline_dataflow_dataset
Description:
This Lab gives you the option to implement as well as execute integration Pipeline by typical data integration scenario in which data flows in different stages.
At first extracts  Source data exists in the form of CSV files from the raw landing zone then  loads to a staging lake database (adworks) then  Data is transformed into a target database (adworkstarget)
Prerequisets:
1.	Add yourself as Active directory Admin to Synapse Workspace. 
 
2.	Add yourself as the Synapse Administrator
3.	
4.	Synapse workspace and Storage account would be existing under below resources
5.	Note down the Raw Storage Account name, this will be used later in the lab.
•	Primary Storage Account name starts with azwksdatalake
•	Raw Storage Account name starts with azrawdatalake
•	Curated Storage Account name starts with azrcurateddatalake
•	Synapse Workspace name starts with azsynapsewks
This lab automatically grant workspace identity data access to the workspace Data Lake Storage Gen2 account, using the Storage Blob Data Contributor role. 
Source Data:
•	This Lab uses Retail database as source  to quickly implement dataflows, datasets and integrate pipelines  for creating Facts and  dimensional tables.
Retail includes the following technical assets
•	Adventure Works sample CSV source files
•	Integration pipelines, Dataflows and datasets.
•	Staging and multi-dimensional lake databases
1.	Exercise to Data ingestion and transformation using Synapse pipelines and data flows
## Creating Data set from ADLS Gen2 storage

In this section, you will use ADLS Gen2 Storage to create datasets. These datasets will be used further for creating the Data Flows.

### Create Dataset-raw

1.	Go to *__Data__* -- > Select *__Linked__* -- > Select *__Integrated dataset__* . It will open New integration dataset.

    ![integratedDataset](./assets/07-raw-integrated-dataset.jpg "select integrated dataset")
    
1.	Select *__Azure Data Lake Storage Gen2__* --> *__Continue__* .

    ![rawdatastore](./assets/07-raw-data-store.jpg "raw data store")
    
1.	Select *__Delimited Text__* and press *__Continue__*.

    ![dataformat](./assets/07-raw-data-format.jpg "data format")

1.	Set properties by giving Name as **``raw``**  and select  *__azure raw data lake storage account__* as linked service.

1.	Set the  filepath to **``raw/SynapseRetailFiles``** and select **OK** .
    
    ![setProperties](./assets/07-raw-set-properties.jpg "set properties")

1.  **Clear** schema under section **_Schema_**.

    ![setProperties](./assets/07-adworks_raw_clear.jpg "set properties")   

1.	Select  **+** under Parameter section to create parameters.
    Create parameter with Name as *__folderPath__* with default value **``@dataset().folderPath``**.
    
    ![createParameter](./assets/07-raw-create-parameters.jpg "create parameter")
    
    
1. 	Under connections set folder path with  parameter value **``@dataset().folderPath``** and set ``first row as Header`` as **True**.

    ![setConnections](./assets/07-raw-set-connections.jpg "set connections")


### Create Dataset - adworksraw

1.	Go to *__Data__* -- > Select *__Linked__* -- > Select *__Integrated dataset__* . It will open New integration dataset.
    
    ![integratedDataset](./assets/07-adwork-integrated-dataset.jpg "select integrated dataset")

1.	Select *__Azure Data Lake Storage Gen2__* --> *__Continue__* .
    
    ![rawdatastore](./assets/07-adwork-data-store.jpg "raw data store")

1.	Select *__Delimited Text__* and press *__Continue__*.
    
    ![dataformat](./assets/07-adwork-data-format.jpg "data format")

1.	Set properties by giving Name as **``adworksraw``**  and select  *__azure raw data lake storage account__* as linked service.
    
     ![setProperties](./assets/07-adwork-set-properties.jpg "set properties")

1.	Set the  filepath to **``raw/SynapseRetailFiles``** and select **OK** .

1.  **Clear** schema under section **_Schema_**.

    ![setProperties](./assets/07-adworks_raw_clear.jpg "set properties")   

1.	Select **+** under Parameter section to create parameters
    Create below mentioned two parameter:
       i.	Name as **``folderPath``** with default value **``@dataset().fileName``**.
      ii.	Name as **``fileName``** with default value **``@dataset().folderPath``**.
    
    ![createParameter](./assets/07-adwork-create-parameters.jpg "create parameter")

1.  Under connections set folder path with  parameter value **``@dataset().folderPath``**.
    set filename as **``@dataset().fileName``** and set first row as Header as **``True``**.
    
    ![setConnections](./assets/07-adwork-set-connections.jpg "set connections")



3.	

