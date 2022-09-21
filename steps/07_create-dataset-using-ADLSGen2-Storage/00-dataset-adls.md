## Creating Data set from ADLS Gen2 storage

In this section, you will use ADLS Gen2 Storage to create datasets. These datasets will be used further for creating the Data Flows.

### Create Dataset-raw

1.	Go to *__Data__* -- > Select *__Linked__* -- > Select *__Integrated dataset__* . It will open New integration dataset.

    ![integratedDataset](./assets/07-raw-integrated-dataset.jpg "select integrated dataset")
    
1.	Select Azure Data Lake Storage Gen2 --> Continue .

    ![rawdatastore](./assets/07-raw-data-store.jpg "raw data store")
    
1.	Select *__Delimited Text__* and press *__Continue*__

    ![dataformat](./assets/07-raw-data-format.jpg "data format")

1.	Set properties by giving Name as *__“raw”__*  and select  __“azure raw data lake storage account”__ as linked service.

1.	Set the  filepath to ``“raw/SynapseRetailFiles”`` and select **“OK” .
    
    ![setProperties](./assets/07-raw-set-properties.jpg "set properties")
    

1.	Select **“+”** under Parameter section to create parameters
    Create parameter with Name as *__“folderPath”__* with default value ``“@dataset().folderPath”``.
    
    ![createParameter](./assets/07-raw-create-parameters.jpg "create parameter")
    
    
1. 	Under connections set folder path with  parameter value ``“@dataset().folderPath”`` and set ``first row as Header`` as **“True”**.

    ![setConnections](./assets/07-raw-set-connections.jpg "set connections")


### Create Dataset - adworksraw

9.	Go to Data -> Select Linked - > Select Integrated dataset.

10.	It will open New integration dataset 

12.	Select Azure Data Lake Storage Gen2  Continue

12.	Select Delimited Text and press Continue

13.	Set properties by giving Name as “adworksraw”  and select  “azure raw data lake storage account” as linked service.

15.	Set the  filepath to “raw/SynapseRetailFiles” and select “OK”

15.	Select “+” under Parameter section to create parameters
    Create below mentioned two parameter 
i.	Name as “folderPath” with default value “@dataset().fileName”.
ii.	Name as “fileName” with default value “@dataset().folderPath”.

Under connections set folder path with  parameter value “@dataset().folderPath” , 
set filename as “@dataset().fileName” and set first row as Header as “True”






