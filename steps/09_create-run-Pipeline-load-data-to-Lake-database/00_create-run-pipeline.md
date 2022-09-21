# Create and run pipeline using the Data flow for loading the data to Lake database

In this section, you will use data flow for creating a pipeline for loading data into lake database.

## Create Pipeline

1.	Select integrate then  “+” icon and select  Pipeline, Name it as “Load CSV data to adworks”

 ![pipeline](./assets/pl1.png "Create pipeline")
 
Select Variable to create below pipeline variables 
  i.	Give name as “adworksSourceFolderPath” with default value “SynapseRetailFiles” (foldername where csv files are located)
  ii.	Create one more variable with name “tableName” with empty default value.
  
  
  2.	Go to pipeline Activities then select and drage “GetMetadata” under “General” section 
   
   ![pipeline](./assets/pl2.png "Create pipeline")
   
  3.	Click on “Get Metadata” to set below settings
  
  4.	Select General section and give name as **"Get File List"**  and Timeout **""7.00:00:00"**
  
  ![pipeline](./assets/pl3.png "Create pipeline")
  
  5.	Select “Settings” and set dataset name as “raw”. 
  6.	After selecting dataset it will be populated with Dataset Properties.
  7.	Set folderPath to “@variables('adworksSourceFolderPath')”
  8.	Add FieldList by click on “+New” and select “ChildItem” from selection.
  
  ![pipeline](./assets/pl4.png "Create pipeline")
  
  9.	Add Output source as Foreach activity from Iteration & conditionals
  
  ![pipeline](./assets/pl5.png "Create pipeline")
     
   10.	Give name to foreach activity under section “General.
       Select Section and select Sequential as True and  mention Items as    “@activity('Get File List').output.childItems”
   11.	Double click on “Foreach” activity  to add activities.
   12.	Drag “Set Variable” activity from General activities and name it as “Set tableName”
   13.	Select Variables section and give Name as “tableName” and value as “@replace(item().name,'.csv','')”
   
   ![pipeline](./assets/pl6.png "Create pipeline")
      
   14.	Add output source to “set variable” by click on “” and add “Dataflow”activity  and name it as “Load adworks” , set Timeout to “1.00:00:00”
   
   ![pipeline](./assets/pl7.png "Create pipeline")
       
   15.	 Select Section “Settings” and select dataflow as “adworks_DF”
   16.	Set CSVSourceParamters as below
        •	Filename as “@item().name”
        •	Folderpath as “@variables('adworksSourceFolderPath')”
        
        ![pipeline](./assets/pl8.png "Create pipeline")
        
     
    17.	Set parameter tableName value as “@variables('tableName')
    
    ![pipeline](./assets/pl9.png "Create pipeline")


