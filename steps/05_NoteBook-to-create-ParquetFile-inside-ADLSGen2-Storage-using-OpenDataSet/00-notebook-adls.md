## Create Parquet file in Data Lake Storage Gen2 (ADLS Gen2) using Open DataSet with Synapse Spark

Azure Data Lake Storage Gen2 (ADLS Gen2) is used as the storage account associated with a Synapse workspace. A synapse workspace can have a default ADLS Gen2 storage account and additional linked storage accounts.
You can access data on ADLS Gen2 with Synapse Spark via the following URL:

``abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/<path>``
 
This notebook provides examples of how to write the output of Spark jobs directly into an ADLS Gen2 location.

**Steps for creating notebook:**

1.	In Synapse Studio, under **_Develop_** tab, click on the **_+(add new resource)_**  icon, select **_Notebook_**.
 
 ![addSqlScript](./assets/05-create_notebook_adls.jpg "create notebook adls")
 
2.	Select the Spark Pool in the **_‘Attach To’_** section. 
3.	In the properties section on the right pane , renaming the notebook as ``Open_DataSet_To_ADLS``.
4.	Run the below scripts in the command cell. And use **_(+Code)_** icon for new cells.
 
 ![addSqlScript](./assets/05-run_notebook_adls.jpg "run notebook adls")

### Load sample data

Let's first load the public holidays of last 6 months from Azure Open datasets as a sample.

**_In[1]:_**

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

**_In[2]:_**

```python
hol_df.show(5, truncate = False)
```
**_Out[2]:_**

``
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
``

### Write data to the default ADLS Gen2 storage

We are going to write the spark dataframe to your default ADLS Gen2 storage account.

### Note: 
Replace the **"azrawStorageAccount"** placeholder with the **Raw storage account** name before running the below code.

**_In[3]:_**

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

**_In[4]:_**

```python
parquet_path = adls_path + 'holiday.parquet'

print('parquet file path: ' + parquet_path)
```
 
**_Out[4]:_** 

``
parquet file path: abfss://raw@azwksdatalakejea3xm.dfs.core.windows.net/holiday.parquet
``

**_In[5]:_**

```python
hol_df.write.parquet(parquet_path, mode = 'overwrite')
```
 
### Save a dataframe as text files
 
If you have a dataframe that you want to save as text file, you must first covert it to an RDD and then save that RDD as a text file.

**_In[6]:_**

```python
# Define the text file path
text_path = adls_path + 'holiday.txt'
print('text file path: ' + text_path)
```
 
**_Out[6]:_**
 
``
text file path: abfss://sandpit@azwksdatalakejea3xm.dfs.core.windows.net/holiday.txt
``

**_In[7]:_**

```python
# Covert spark dataframe into RDD 
hol_RDD = hol_df.rdd
type(hol_RDD)
```
 
If you have an RDD, you can convert it to a text file like the following:

**_In[8]:_**

```python
#Save RDD as text file
hol_RDD.saveAsTextFile(text_path)
```
 
### Validate file created in ADLS Gen2 storage
 
Create a dataframe from parquet files

**_In[9]:_**

```python
df_parquet = spark.read.parquet(parquet_path)
```

**_In[10]:_**

```python
#Displaying 5 records
df_parquet.show(5, truncate = False)
```

**_Out[10]:_** 

``
+---------------+------------------------------+------------------------------+-------------+-----------------+-------------------+ |countryOrRegion|holidayName |normalizeHolidayName |isPaidTimeOff|countryRegionCode|date | +---------------+------------------------------+------------------------------+-------------+-----------------+-------------------+ |Belarus |День женщин |День женщин |null |BY |2022-03-08 00:00:00| |Ukraine |Міжнародний жіночий день |Міжнародний жіночий день |null |UA |2022-03-08 00:00:00| |Norway |Søndag |Søndag |null |NO |2022-03-13 00:00:00| |Sweden |Söndag |Söndag |null |SE |2022-03-13 00:00:00| |Hungary |Nemzeti ünnep előtti pihenőnap|Nemzeti ünnep előtti pihenőnap|null |HU |2022-03-14 00:00:00| +---------------+------------------------------+------------------------------+-------------+-----------------+-------------------+ only showing top 5 rows
``

Once executing all the code cells. Click **_Validate All_** and **_Publish All_** at the top.

![addSqlScript](./assets/05-publish_notebook_adls.jpg "publish notebook adls")
