relationship between dimension and fact tables

1) User has to navigate to the synapse workspace.
2) Locate the **Data** tab . Under the workspace section you will find the lake database.
3) You need to select the adworkstarget database to create the relationship.
4) To open the adworkstarget lake database , right click on adworkstarget database and click on open.
5) To view all the tables , expand the other section under Tables.
6) You can select **_FactSales_** table on the canvas. It opens the table properties pane with the tabs General, Columns, and Relationships.
7) The Relationships tab lists the incoming and outgoing relationships of the table with other tables on the canvas.
8) Now you need to map a column from table to column of another table.
9)Using the check boxes next to each relationship in the relationship tab, select **from table** option.
10)For FactSales you need to create a relationship.Select a column OrderDateKey from dropdown for FactSales tables and map it with DateKey column of DimTable( To Table) .
11)Repeat step 9 and 10 to create relationships for FactSales.
12)Make sure you create all the 5 relationships as mentioned in below snapshot. 
13) After successful creation of relationships make sure you Validate by clicking on Publishing.
14) Once published the workspace is saved and relationships between the fact and dim tables are seen on the Develop pane with lines attached between tables.
 
