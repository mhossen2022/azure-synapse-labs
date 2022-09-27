# Create Dataflow – FactSales_DF

1.	Open FactSales_DF under **_Develop-> DataFlows -> FactSales_DF_**

![developDataflows](./assets/10-01_develop_dataflows.jpg "develop dataflows")

2.  Select AddSource  and name it as **_“SalesSource”_**,  add   sourcetype **_“adworks”_** and select  table **_“Sales”_**.

![addSource](./assets/10-02_add_source.jpg "add source")

![sourceSetting](./assets/10-03_source_setting.jpg "source setting")

3.  Select **“+”** of SalesSource  to add dervived column under section **_“schema modifier”_** and name it as **_“SalesderivedColumn”_**.

![schemaModifier](./assets/10-04_schema_modifier.jpg "schema modifier")

4.  Add column with  name **_“OrderDateId”_** and expression **_“toInteger(toString(OrderDate, "yyyyMMdd"))”_**

![derivedColumnSettings](./assets/10-05_derived_column_settttings.jpg "derived column settings")

6.	Add source **_“Filter”_** to SalesderivedColumn and name it as **_“ResellerFilter”_**

![sourceFilter](./assets/10-06_source_filter.jpg "source filter")

6.	Add **_“Filter on”_** expression as **_“!isNull(CustomerId)”_**

![filterOn](./assets/10-07_filter_on.jpg "filter on")

7.	Add Lookup to **_“ResellerFilter”_** by selecting LookUp  and Name it as **_“ResellerKeyLookup”_**.

![lookup](./assets/10-08_lookup.jpg "lookup")

8.	Select  Lookup stram as **_“ResellerCustomerSelect"_** from dropdown  and add lookup condition as **_“ResellerKeyLookup == ResellerId_lookup"_**

![lookupStream](./assets/10-09_lookup_stream.jpg "lookup stream")

9.	Add Lookup  to ResellerKeyLookup and name it as **_“ProductKeyLookup”_** and select Lookup stream as **_“DimProductSelect”_** and add lookup condition as **_“ProductId==ProductId"_**

![lookupReseller](./assets/10-10_lookup_reseller.jpg "lookup reseller")

10.	Add Lookup  to ProductKeyLookup and name it as **_“DimDateKeyLookup”_** and select Lookup stream as **_“DimDateSelect”_** and add lookup condition as **_“OrderDateId==Date_lookup”_**

![lookupProduct](./assets/10-11_lookup_product.jpg "lookup product")

11.	Add source as **_“Select”_** to DimDateKeyLookup and name it as **_“FactSalesSelect”_**

12.	Select options **_“Skip duplicate input columns”_** and **_“Skip duplicate output columns”_**

13.	Set input columns as below

![selectInput](./assets/10-12_select_input.jpg "select input")

14.	Addsource as **_“Sink”_** for destination to **_“FactSalesSelect”_** and name it as **_“FactSalesSink”_**

![sourceSink](./assets/10-13_source_sink.jpg "source sink")

15. Select **_“Sink type”_** as **_“WorkspaceDB”_**, Database **_“adworkstarget”_** from dropdown and mention Table as **_“FactSales”_**.

![sinkType](./assets/10-14_sink_type.jpg "sink type")

16.	Click on **_“Validate”_** to  validate dataflow.

![validate](./assets/10-15_validate.jpg "validate")

17. Once dataflow has been validated **_“Publish”_** dataflow.
