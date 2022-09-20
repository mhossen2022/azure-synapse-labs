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
