# Create Dataflow – FactSales_DF

1.	Open FactSales_DF under **_Develop-> DataFlows -> FactSales_DF_**

1.  Select AddSource  and name it as “SalesSource”,  add   sourcetype “adworks” and select  table “Sales” .

1.  Select “+” of SalesSource  to add dervived column under section “schema modifier” and name it as “SalesderivedColumn”.

1.  4.	Add column with  name “OrderDateId” and expression “toInteger(toString(OrderDate, "yyyyMMdd"))”

5.	Add source “Filter” to SalesderivedColumn and name it as “ResellerFilter”
