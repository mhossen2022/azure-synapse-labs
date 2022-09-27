# Relationship between dimension and fact tables

1) User has to navigate to the synapse workspace.

3) On the left hand side , locate and click on the **Data** tab . Under workspace section you will find the lake databases.
4) You need to select the **_adworkstarget_** database to create the relationship.
5) To open the **adworkstarget** lake database , right click on **adworkstarget** database and click on open.
6) To view all the tables , expand the _Other_ section under Tables.
7) You can select **_FactSales_** table on the canvas. It opens the table properties pane with 3 tabs i.e General, Columns, and Relationships.
8) The Relationships tab lists the incoming and outgoing relationships of the table with other tables on the canvas.
9) Now you need to map a column from one table to column of another table.
10)Using the check boxes next to each relationship in the relationship tab, select **from table** option.
11)For FactSales you need to create a relationship.Select a column OrderDateKey from dropdown for FactSales tables and map it with DateKey column of DimTable( To Table) .
12)Repeat step 9 and 10 to create relationships for FactSales.
13)Make sure you create all the 5 relationships as mentioned in below snapshot. 
14) After successful creation of relationships make sure you Validate by clicking on Publishing.
15) Once published the workspace is saved and relationships between the fact and dim tables are seen on the Develop pane with lines attached between tables.
 
