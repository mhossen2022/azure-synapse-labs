## Create parquet file in Data Lake Storage Gen2 (ADLS Gen2) using Open DataSet  with Synapse Spark

Azure Data Lake Storage Gen2 (ADLS Gen2) is used as the storage account associated with a Synapse workspace. A synapse workspace can have a default ADLS Gen2 storage account and additional linked storage accounts.
You can access data on ADLS Gen2 with Synapse Spark via the following URL:
abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/<path>
This notebook provides examples of how to write the output of Spark jobs directly into an ADLS Gen2 location.

Steps for creating notebook:
1.	In Synapse Studio, under Develop tab, click on the + (add new resource) icon, select Notebook.

2.	Select the Spark Pool in the ‘Attach To’ section. 
3.	In the properties section on the right pane , renaming the notebook as Open_DataSet_To_ADLS.
4.	Run the below scripts in the command cell. And use (+Code) icon for new cells.

Load sample data
Let's first load the public holidays of last 6 months from Azure Open datasets as a sample.

```python
 
from azureml.opendatasets import PublicHolidays

from datetime import datetime
from dateutil import parser
from dateutil.relativedelta import relativedelta

end_date = datetime.today()
start_date = datetime.today() - relativedelta(months=6)
hol = PublicHolidays(start_date=start_date, end_date=end_date)
hol_df = hol.to_spark_dataframe()

```

Displaying 5 rows
 
 ```python
 
 hol_df.show(5, truncate = False)
 ```
 
+---------------+-------------------------+-------------------------+-------------+-----------------+-------------------+
|countryOrRegion|holidayName              |normalizeHolidayName     |isPaidTimeOff|countryRegionCode|date               |
+---------------+-------------------------+-------------------------+-------------+-----------------+-------------------+
|Ukraine        |День незалежності України|День незалежності України|null         |UA               |2020-08-24 00:00:00|
|Norway         |Søndag                   |Søndag                   |null         |NO               |2020-08-30 00:00:00|
|Sweden         |Söndag                   |Söndag                   |null         |SE               |2020-08-30 00:00:00|
|England        |Late Summer Bank Holiday |Late Summer Bank Holiday |null         |null             |2020-08-31 00:00:00|
|Isle of Man    |Late Summer Bank Holiday |Late Summer Bank Holiday |null         |IM               |2020-08-31 00:00:00|
+---------------+-------------------------+-------------------------+-------------+-----------------+-------------------+
only showing top 5 rows
 
 Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
 
### Write data to the default ADLS Gen2 storage
We are going to write the spark dataframe to your default ADLS Gen2 storage account.
Note: 
Replace the "azrawStorageAccount" placeholder with the **Raw storage account** name before running the below code.

 ```python
 
 from pyspark.sql import SparkSession
from pyspark.sql.types import *

# Primary storage info
account_name = ' <azrawStorageAccount> ' # fill in your primary account name
container_name = 'raw' # fill in the container name
relative_path = ''

adls_path = 'abfss://%s@%s.dfs.core.windows.net/%s' % (container_name, account_name, relative_path)
print('Primary storage account path: ' + adls_path)

 ```
 
### Save a dataframe as Parquet
If you have a dataframe, you can save it to Parquet or JSON with the .write.parquet(), .write.json() and .write.csv() methods respectively.
 
Dataframes can be saved in any format, regardless of the input format.
 
But here in this lab, we have demonstrated with Parquet method only.
 
```python

 parquet_path = adls_path + 'holiday.parquet'

print('parquet file path: ' + parquet_path)

```
 
``parquet file path: abfss://raw@azwksdatalakejea3xm.dfs.core.windows.net/holiday.parquet``

```python

 hol_df.write.parquet(parquet_path, mode = 'overwrite')

 
```



 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
