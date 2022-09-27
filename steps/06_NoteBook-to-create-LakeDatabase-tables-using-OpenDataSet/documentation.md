## Using Azure Open Datasets in Synapse - Enrich NYC Green Taxi Data with Holiday and Weather

Synapse has Azure Open Datasets package pre-installed. This notebook provides examples of how to enrich NYC Green Taxi Data with Holiday and Weather with focusing on:

       - Read Azure Open Dataset
       - Manipulate the data to prepare for further analysis, including column projection, filtering, grouping and joins etc.
       - Create a Spark table to be used in other notebooks for modeling training

### Steps for creating a notebook:

1.	In Synapse Studio, under **_Develop_** tab, click on the **_+(add new resource)_** icon, select Notebook.
       
       ![createNotebooks](./assets/06-create_notebook_dl.jpg "create notebook")
  
3.	Select the Spark Pool in the **_‘Attach To’_** section. 
3.	In the properties section on the right pane rename the notebook as ``ntb_Open_DataSet_To_LakeDB``
4.	Run the below code in the command cell. And use **_(+Code)_** icon for new cells.
       ![runNotebooks](./assets/06-run_notebook_dl.jpg "run notebook")
       
   

### Data loading

Let's first load the NYC green taxi trip records. The Open Datasets package contains a class representing each data source (NycTlcGreen for example) to easily filter date parameters before downloading.

**_In[1]:_**
```python
from azureml.opendatasets import NycTlcGreen
from datetime import datetime
from dateutil import parser

end_date = parser.parse('2018-06-06')
start_date = parser.parse('2018-05-01')

nyc_tlc = NycTlcGreen(start_date=start_date, end_date=end_date)
nyc_tlc_df = nyc_tlc.to_spark_dataframe()
```

Displaying 5 rows

**_In[2]:_** 
```python
nyc_tlc_df.show(5, truncate = False)
```

**_Out[2]:_**

``+--------+-------------------+-------------------+--------------+------------+------------+------------+---------------+--------------+----------------+---------------+----------+---------------+-----------+----------+-----+------+--------------------+---------+-----------+--------+-----------+--------+------+-------+ |vendorID|lpepPickupDatetime |lpepDropoffDatetime|passengerCount|tripDistance|puLocationId|doLocationId|pickupLongitude|pickupLatitude|dropoffLongitude|dropoffLatitude|rateCodeID|storeAndFwdFlag|paymentType|fareAmount|extra|mtaTax|improvementSurcharge|tipAmount|tollsAmount|ehailFee|totalAmount|tripType|puYear|puMonth| +--------+-------------------+-------------------+--------------+------------+------------+------------+---------------+--------------+----------------+---------------+----------+---------------+-----------+----------+-----+------+--------------------+---------+-----------+--------+-----------+--------+------+-------+ |2 |2018-06-02 14:10:02|2018-06-02 14:30:23|1 |2.5 |41 |247 |null |null |null |null |1 |N |1 |14.5 |0.0 |0.5 |0.3 |3.06 |0.0 |null |18.36 |1 |2018 |6 | |2 |2018-06-02 14:36:36|2018-06-02 14:41:11|1 |0.45 |42 |42 |null |null |null |null |1 |N |2 |5.0 |0.0 |0.5 |0.3 |0.0 |0.0 |null |5.8 |1 |2018 |6 | |2 |2018-06-04 11:18:01|2018-06-04 11:20:58|1 |0.8 |74 |74 |null |null |null |null |1 |N |2 |4.5 |0.0 |0.5 |0.3 |0.0 |0.0 |null |5.3 |1 |2018 |6 | |2 |2018-06-02 17:47:28|2018-06-02 18:01:06|1 |1.68 |74 |42 |null |null |null |null |1 |N |2 |10.5 |0.0 |0.5 |0.3 |0.0 |0.0 |null |11.3 |1 |2018 |6 | |1 |2018-06-02 17:24:06|2018-06-02 17:44:21|3 |6.9 |93 |131 |null |null |null |null |1 |N |1 |22.0 |0.0 |0.5 |0.3 |3.42 |0.0 |null |26.22 |1 |2018 |6 | +--------+-------------------+-------------------+--------------+------------+------------+------------+---------------+--------------+----------------+---------------+----------+---------------+-----------+----------+-----+------+--------------------+---------+-----------+--------+-----------+--------+------+-------+ only showing top 5 rows
``

Now that the initial data is loaded. Let's do some projection on the data to
•	Create new columns for the month number, day of month, day of week, and hour of day. These info is going to be used in the training model to factor in time-based seasonality.
•	Add a static feature for the country code to join holiday data.

**_In[3]_:**

```python
import pyspark.sql.functions as f
nyc_tlc_df_expand = nyc_tlc_df.withColumn('datetime',f.to_date('lpepPickupDatetime'))\
.withColumn('month_num',f.month(nyc_tlc_df.lpepPickupDatetime))\
.withColumn('day_of_month',f.dayofmonth(nyc_tlc_df.lpepPickupDatetime))\
.withColumn('day_of_week',f.dayofweek(nyc_tlc_df.lpepPickupDatetime))\
.withColumn('hour_of_day',f.hour(nyc_tlc_df.lpepPickupDatetime))\
.withColumn('country_code',f.lit('US'))
```

Remove some of the columns that won't be needed for modeling or additional feature building.

**_In[4]:_**
```python
columns_to_remove = ["lpepDropoffDatetime", "puLocationId", "doLocationId", "pickupLongitude", "pickupLatitude", "dropoffLongitude","dropoffLatitude" ,"rateCodeID", "storeAndFwdFlag","paymentType", "fareAmount", "extra", "mtaTax", "improvementSurcharge", "tollsAmount", "ehailFee", "tripType "]

nyc_tlc_df_clean = nyc_tlc_df_expand.select([column for column in nyc_tlc_df_expand.columns if column not in columns_to_remove])
```

Displaying 5 rows

**_In[5]:_**

```python
nyc_tlc_df_clean.show(5)
```

**_Out[5]:_**

``+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+----------+---------+------------+-----------+-----------+------------+ |vendorID| lpepPickupDatetime|passengerCount|tripDistance|tipAmount|totalAmount|tripType|puYear|puMonth| datetime|month_num|day_of_month|day_of_week|hour_of_day|country_code| +--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+----------+---------+------------+-----------+-----------+------------+ | 2|2018-06-02 14:10:02| 1| 2.5| 3.06| 18.36| 1| 2018| 6|2018-06-02| 6| 2| 7| 14| US| | 2|2018-06-02 14:36:36| 1| 0.45| 0.0| 5.8| 1| 2018| 6|2018-06-02| 6| 2| 7| 14| US| | 2|2018-06-04 11:18:01| 1| 0.8| 0.0| 5.3| 1| 2018| 6|2018-06-04| 6| 4| 2| 11| US| | 2|2018-06-02 17:47:28| 1| 1.68| 0.0| 11.3| 1| 2018| 6|2018-06-02| 6| 2| 7| 17| US| | 1|2018-06-02 17:24:06| 3| 6.9| 3.42| 26.22| 1| 2018| 6|2018-06-02| 6| 2| 7| 17| US| +--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+----------+---------+------------+-----------+-----------+------------+ only showing top 5 rows
``

### Enrich with holiday data

Now that we have taxi data downloaded and roughly prepared, add in holiday data as additional features. Holiday-specific features will assist model accuracy, as major holidays are times where taxi demand increases dramatically, and supply becomes limited.
Let's load the public holidays from Azure Open datasets.

**_In[6]:_**

```python
from azureml.opendatasets import PublicHolidays

hol = PublicHolidays(start_date=start_date, end_date=end_date)
hol_df = hol.to_spark_dataframe()

# Display data
hol_df.show(5, truncate = False)
```

**_Out[6]:_**

``+---------------+----------------------------+----------------------------+-------------+-----------------+-------------------+ |countryOrRegion|holidayName |normalizeHolidayName |isPaidTimeOff|countryRegionCode|date | +---------------+----------------------------+----------------------------+-------------+-----------------+-------------------+ |Argentina |Día del Trabajo [Labour Day]|Día del Trabajo [Labour Day]|null |AR |2018-05-01 00:00:00| |Austria |Staatsfeiertag |Staatsfeiertag |null |AT |2018-05-01 00:00:00| |Belarus |Праздник труда |Праздник труда |null |BY |2018-05-01 00:00:00| |Belgium |Dag van de Arbeid |Dag van de Arbeid |null |BE |2018-05-01 00:00:00| |Brazil |Dia Mundial do Trabalho |Dia Mundial do Trabalho |null |BR |2018-05-01 00:00:00| +---------------+----------------------------+----------------------------+-------------+-----------------+-------------------+ only showing top 5 rows
``

Rename the countryRegionCode and date columns to match the respective field names from the taxi data, and normalize the time so it can be used as a key.

**_In[7]:_**

```python
hol_df_clean = hol_df.withColumnRenamed('countryRegionCode','country_code')\
            .withColumn('datetime',f.to_date('date'))

hol_df_clean.show(5)
```

**_Out[7]:_**

``+---------------+--------------------+--------------------+-------------+------------+-------------------+----------+ |countryOrRegion| holidayName|normalizeHolidayName|isPaidTimeOff|country_code| date| datetime| +---------------+--------------------+--------------------+-------------+------------+-------------------+----------+ | Argentina|Día del Trabajo [...|Día del Trabajo [...| null| AR|2018-05-01 00:00:00|2018-05-01| | Austria| Staatsfeiertag| Staatsfeiertag| null| AT|2018-05-01 00:00:00|2018-05-01| | Belarus| Праздник труда| Праздник труда| null| BY|2018-05-01 00:00:00|2018-05-01| | Belgium| Dag van de Arbeid| Dag van de Arbeid| null| BE|2018-05-01 00:00:00|2018-05-01| | Brazil|Dia Mundial do Tr...|Dia Mundial do Tr...| null| BR|2018-05-01 00:00:00|2018-05-01| +---------------+--------------------+--------------------+-------------+------------+-------------------+----------+ only showing top 5 rows
``

Next, join the holiday data with the taxi data by performing a left-join. This will preserve all records from taxi data, but add in holiday data where it exists for the corresponding datetime and country_code, which in this case is always "US". Preview the data to verify that they were merged correctly.

**_In[8]:_**

```python
nyc_taxi_holiday_df = nyc_tlc_df_clean.join(hol_df_clean, on = ['datetime', 'country_code'] , how = 'left')

nyc_taxi_holiday_df.show(5)
```

**_Out[8]:_**

``+----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+-----------+--------------------+-------------+----+ | datetime|country_code|vendorID| lpepPickupDatetime|passengerCount|tripDistance|tipAmount|totalAmount|tripType|puYear|puMonth|month_num|day_of_month|day_of_week|hour_of_day|countryOrRegion|holidayName|normalizeHolidayName|isPaidTimeOff|date| +----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+-----------+--------------------+-------------+----+ |2018-06-02| US| 2|2018-06-02 14:10:02| 1| 2.5| 3.06| 18.36| 1| 2018| 6| 6| 2| 7| 14| null| null| null| null|null| |2018-06-02| US| 2|2018-06-02 14:36:36| 1| 0.45| 0.0| 5.8| 1| 2018| 6| 6| 2| 7| 14| null| null| null| null|null| |2018-06-04| US| 2|2018-06-04 11:18:01| 1| 0.8| 0.0| 5.3| 1| 2018| 6| 6| 4| 2| 11| null| null| null| null|null| |2018-06-02| US| 2|2018-06-02 17:47:28| 1| 1.68| 0.0| 11.3| 1| 2018| 6| 6| 2| 7| 17| null| null| null| null|null| |2018-06-02| US| 1|2018-06-02 17:24:06| 3| 6.9| 3.42| 26.22| 1| 2018| 6| 6| 2| 7| 17| null| null| null| null|null| +----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+-----------+--------------------+-------------+----+ only showing top 5 rows
``

Create a temp table and filter out non empty holiday rows

**_In[9]:_**

```python
nyc_taxi_holiday_df.createOrReplaceTempView("nyc_taxi_holiday_df")
spark.sql("SELECT * from nyc_taxi_holiday_df WHERE holidayName is NOT NULL ").show(5, truncate = False)
```

**_Out[9]:_**

``+----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+------------+--------------------+-------------+-------------------+ |datetime |country_code|vendorID|lpepPickupDatetime |passengerCount|tripDistance|tipAmount|totalAmount|tripType|puYear|puMonth|month_num|day_of_month|day_of_week|hour_of_day|countryOrRegion|holidayName |normalizeHolidayName|isPaidTimeOff|date | +----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+------------+--------------------+-------------+-------------------+ |2018-05-28|US |2 |2018-05-28 10:28:09|1 |2.01 |2.26 |13.56 |1 |2018 |5 |5 |28 |2 |10 |United States |Memorial Day|Memorial Day |true |2018-05-28 00:00:00| |2018-05-28|US |2 |2018-05-28 11:18:08|1 |1.23 |0.0 |7.3 |1 |2018 |5 |5 |28 |2 |11 |United States |Memorial Day|Memorial Day |true |2018-05-28 00:00:00| |2018-05-28|US |2 |2018-05-28 13:07:12|1 |71.23 |0.0 |181.8 |1 |2018 |5 |5 |28 |2 |13 |United States |Memorial Day|Memorial Day |true |2018-05-28 00:00:00| |2018-05-28|US |2 |2018-05-28 00:02:29|1 |0.87 |0.0 |6.8 |1 |2018 |5 |5 |28 |2 |0 |United States |Memorial Day|Memorial Day |true |2018-05-28 00:00:00| |2018-05-28|US |2 |2018-05-28 00:05:18|1 |6.54 |0.0 |24.3 |1 |2018 |5 |5 |28 |2 |0 |United States |Memorial Day|Memorial Day |true |2018-05-28 00:00:00| +----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+------------+--------------------+-------------+-------------------+ only showing top 5 rows
``

### Enrich with weather data

Now we append NOAA surface weather data to the taxi and holiday data. Use a similar approach to fetch the NOAA weather history data from Azure Open Datasets.

**_In[10]:_**

```python
from azureml.opendatasets import NoaaIsdWeather

isd = NoaaIsdWeather(start_date, end_date)
isd_df = isd.to_spark_dataframe()
```

**_In[11]:_**

```python
isd_df.show(5, truncate = False)
```

**_Out[11]:_**

``+------+-----+-------------------+--------+---------+---------+---------+---------+-----------+--------------+-------------+-----------------------+--------------------+----------+-----------+---------+-------------------------+---------------+------------+----+---+-------+-----+ |usaf |wban |datetime |latitude|longitude|elevation|windAngle|windSpeed|temperature|seaLvlPressure|cloudCoverage|presentWeatherIndicator|pastWeatherIndicator|precipTime|precipDepth|snowDepth|stationName |countryOrRegion|p_k |year|day|version|month| +------+-----+-------------------+--------+---------+---------+---------+---------+-----------+--------------+-------------+-----------------------+--------------------+----------+-----------+---------+-------------------------+---------------+------------+----+---+-------+-----+ |720602|00194|2018-05-08 12:35:00|33.25 |-81.383 |75.0 |40 |4.1 |18.0 |null |null |null |null |null |null |null |BARNWELL REGIONAL AIRPORT|US |720602-00194|2018|8 |1.0 |5 | |999999|94077|2018-05-04 20:00:00|42.425 |-103.736 |1343.0 |null |3.6 |21.5 |null |null |null |null |1.0 |0.0 |null |HARRISON 20 SSE |US |999999-94077|2018|4 |1.0 |5 | |727506|04952|2018-05-04 02:15:00|43.913 |-95.109 |430.0 |300 |2.1 |12.0 |null |null |null |null |null |null |null |WINDOM MUNICIPAL AIRPORT |US |727506-04952|2018|4 |1.0 |5 | |999999|03054|2018-05-11 15:45:00|33.956 |-102.774 |1141.0 |null |null |28.8 |null |null |null |null |null |null |null |MULESHOE 19 S |US |999999-03054|2018|11 |1.0 |5 | |039620|99999|2018-05-16 02:30:00|52.702 |-8.925 |14.0 |340 |3.6 |4.0 |null |null |null |null |null |null |null |SHANNON |EI |039620-99999|2018|16 |1.0 |5 | +------+-----+-------------------+--------+---------+---------+---------+---------+-----------+--------------+-------------+-----------------------+--------------------+----------+-----------+---------+-------------------------+---------------+------------+----+---+-------+-----+ only showing top 5 rows
``

Filter out weather info for new york city, remove the recording with null temperature

**_In[12]:_**

```python
weather_df = isd_df.filter(isd_df.latitude >= '40.53')\
                        .filter(isd_df.latitude <= '40.88')\
                        .filter(isd_df.longitude >= '-74.09')\
                        .filter(isd_df.longitude <= '-73.72')\
                        .filter(isd_df.temperature.isNotNull())\
                        .withColumnRenamed('datetime','datetime_full')
```

Remove unused columns

**_In[13]:_**

```python
columns_to_remove_weather = ["usaf", "wban", "longitude", "latitude"]
weather_df_clean = weather_df.select([column for column in weather_df.columns if column not in columns_to_remove_weather])\
                        .withColumn('datetime',f.to_date('datetime_full'))

weather_df_clean.show(5, truncate = False)
```

**_Out[13]:_**

``+-------------------+---------+---------+---------+-----------+--------------+-------------+-----------------------+--------------------+----------+-----------+---------+------------------------------------+---------------+------------+----+---+-------+-----+----------+ |datetime_full |elevation|windAngle|windSpeed|temperature|seaLvlPressure|cloudCoverage|presentWeatherIndicator|pastWeatherIndicator|precipTime|precipDepth|snowDepth|stationName |countryOrRegion|p_k |year|day|version|month|datetime | +-------------------+---------+---------+---------+-----------+--------------+-------------+-----------------------+--------------------+----------+-----------+---------+------------------------------------+---------------+------------+----+---+-------+-----+----------+ |2018-05-20 15:00:00|7.0 |230 |8.2 |23.9 |1014.3 |BKN |null |null |null |null |null |JOHN F KENNEDY INTERNATIONAL AIRPORT|US |744860-94789|2018|20 |1.0 |5 |2018-05-20| |2018-05-26 12:51:00|7.0 |220 |5.1 |23.9 |1010.6 |FEW |null |null |1.0 |0.0 |null |JOHN F KENNEDY INTERNATIONAL AIRPORT|US |744860-94789|2018|26 |1.0 |5 |2018-05-26| |2018-05-27 13:51:00|7.0 |80 |6.2 |17.2 |1015.9 |null |63 |null |1.0 |53.0 |null |JOHN F KENNEDY INTERNATIONAL AIRPORT|US |744860-94789|2018|27 |1.0 |5 |2018-05-27| |2018-05-17 11:49:00|7.0 |100 |2.6 |14.0 |null |null |61 |null |null |null |null |JOHN F KENNEDY INTERNATIONAL AIRPORT|US |744860-94789|2018|17 |1.0 |5 |2018-05-17| |2018-05-04 18:51:00|7.0 |170 |6.2 |22.8 |1011.9 |null |null |null |1.0 |0.0 |null |JOHN F KENNEDY INTERNATIONAL AIRPORT|US |744860-94789|2018|4 |1.0 |5 |2018-05-04| +-------------------+---------+---------+---------+-----------+--------------+-------------+-----------------------+--------------------+----------+-----------+---------+------------------------------------+---------------+------------+----+---+-------+-----+----------+ only showing top 5 rows
``

Next group the weather data so that you have daily aggregated weather values.

**_In[14]:_**

```python
#Enrich weather data with aggregation statistics
aggregations = {"snowDepth": "mean", "precipTime": "max", "temperature": "mean", "precipDepth": "max"}
weather_df_grouped = weather_df_clean.groupby("datetime").agg(aggregations)
```

**_In[15]:_**

```python
weather_df_grouped.show(5)
```

**_Out[15]:_**

``+----------+--------------+------------------+---------------+----------------+ | datetime|avg(snowDepth)| avg(temperature)|max(precipTime)|max(precipDepth)| +----------+--------------+------------------+---------------+----------------+ |2018-05-28| null| 15.33363636363636| 24.0| 2540.0| |2018-06-06| null| 21.4| 6.0| 0.0| |2018-05-26| null|26.072330097087377| 24.0| 2540.0| |2018-05-27| null|18.931365313653142| 24.0| 7648.0| |2018-06-03| null|18.242803030303037| 24.0| 2540.0| +----------+--------------+------------------+---------------+----------------+ only showing top 5 rows
``

Rename Columns

**_In[16]:_**

```python
weather_df_grouped = weather_df_grouped.withColumnRenamed('avg(snowDepth)','avg_snowDepth')\
                                       .withColumnRenamed('avg(temperature)','avg_temperature')\
                                       .withColumnRenamed('max(precipTime)','max_precipTime')\
                                       .withColumnRenamed('max(precipDepth)','max_precipDepth')
```

Merge the taxi and holiday data you prepared with the new weather data. This time you only need the datetime key, and again perform a left-join of the data. Run the describe() function on the new dataframe to see summary statistics for each field.

**_In[17]:_**

```python
# enrich taxi data with weather
nyc_taxi_holiday_weather_df = nyc_taxi_holiday_df.join(weather_df_grouped, on = 'datetime' , how = 'left')
nyc_taxi_holiday_weather_df.cache()
```

**_Out[17]:_**

``DataFrame[datetime: date, country_code: string, vendorID: int, lpepPickupDatetime: timestamp, passengerCount: int, tripDistance: double, tipAmount: double, totalAmount: double, tripType: int, puYear: int, puMonth: int, month_num: int, day_of_month: int, day_of_week: int, hour_of_day: int, countryOrRegion: string, holidayName: string, normalizeHolidayName: string, isPaidTimeOff: boolean, date: timestamp, avg_snowDepth: double, avg_temperature: double, max_precipTime: double, max_precipDepth: double]
``

**_In[18]:_**

```python
nyc_taxi_holiday_weather_df.show(5)
```

**_Out[18]:_**

``+----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+------------+--------------------+-------------+-------------------+-------------+-----------------+--------------+---------------+ | datetime|country_code|vendorID| lpepPickupDatetime|passengerCount|tripDistance|tipAmount|totalAmount|tripType|puYear|puMonth|month_num|day_of_month|day_of_week|hour_of_day|countryOrRegion| holidayName|normalizeHolidayName|isPaidTimeOff| date|avg_snowDepth| avg_temperature|max_precipTime|max_precipDepth| +----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+------------+--------------------+-------------+-------------------+-------------+-----------------+--------------+---------------+ |2018-05-28| US| 2|2018-05-28 10:28:09| 1| 2.01| 2.26| 13.56| 1| 2018| 5| 5| 28| 2| 10| United States|Memorial Day| Memorial Day| true|2018-05-28 00:00:00| null|15.33363636363636| 24.0| 2540.0| |2018-05-28| US| 2|2018-05-28 11:18:08| 1| 1.23| 0.0| 7.3| 1| 2018| 5| 5| 28| 2| 11| United States|Memorial Day| Memorial Day| true|2018-05-28 00:00:00| null|15.33363636363636| 24.0| 2540.0| |2018-05-28| US| 2|2018-05-28 13:07:12| 1| 71.23| 0.0| 181.8| 1| 2018| 5| 5| 28| 2| 13| United States|Memorial Day| Memorial Day| true|2018-05-28 00:00:00| null|15.33363636363636| 24.0| 2540.0| |2018-05-28| US| 2|2018-05-28 00:02:29| 1| 0.87| 0.0| 6.8| 1| 2018| 5| 5| 28| 2| 0| United States|Memorial Day| Memorial Day| true|2018-05-28 00:00:00| null|15.33363636363636| 24.0| 2540.0| |2018-05-28| US| 2|2018-05-28 00:05:18| 1| 6.54| 0.0| 24.3| 1| 2018| 5| 5| 28| 2| 0| United States|Memorial Day| Memorial Day| true|2018-05-28 00:00:00| null|15.33363636363636| 24.0| 2540.0| +----------+------------+--------+-------------------+--------------+------------+---------+-----------+--------+------+-------+---------+------------+-----------+-----------+---------------+------------+--------------------+-------------+-------------------+-------------+-----------------+--------------+---------------+ only showing top 5 rows
``

Run the describe() function on the new dataframe to see summary statistics for each field.

**_In[19]:_**

```python
display(nyc_taxi_holiday_weather_df.describe())
```

The summary statistics shows that the totalAmount field has negative values, which don't make sense in the context.

**_In[20]:_**

```python
# Remove invalid rows with less than 0 taxi fare or tip
final_df = nyc_taxi_holiday_weather_df.filter(nyc_taxi_holiday_weather_df.tipAmount > 0)\
                                      .filter(nyc_taxi_holiday_weather_df.totalAmount > 0)
```

### Cleaning up the existing Database

First we need to drop the tables since Spark requires that a database is empty before we can drop the Database.
Then we recreate the database and set the default database context to it.

**_In[21]:_**

```python
spark.sql("DROP TABLE IF EXISTS NYCTaxi.nyc_taxi_holiday_weather");
```

**_In[22]:_**

```python
spark.sql("DROP DATABASE IF EXISTS NYCTaxi"); 
spark.sql("CREATE DATABASE NYCTaxi"); 
spark.sql("USE NYCTaxi");
```

### Creating a new table

We create a nyc_taxi_holiday_weather table from the nyc_taxi_holiday_weather dataframe.

**_In[23]:_**

```python
from pyspark.sql import SparkSession
from pyspark.sql.types import *

final_df.write.saveAsTable("nyc_taxi_holiday_weather");
spark.sql("SELECT COUNT(*) FROM nyc_taxi_holiday_weather").show();
```

**_Out[23]:_**

``
+--------+
|count(1)|
+--------+
|  337444|
+--------+
``

## Steps for validating the table created in Lake database

1)	Once executing all the code cells. Click **_Validate All_** and **_Publish All_** at the top.
       ![publishNotebooks](./assets/06-publish_notebook_dl.jpg "publish notebook")
3)	Navigate to **_Data Tab_**. Under Workspace expand **_Lake database_**.
4)	Check for the **_NycTaxi database and expand it_**.
5)	Make sure you have **_nyc_taxi_holiday_weather table created_**.

       ![validateNotebooks](./assets/06-validate_notebook_dl.jpg "validate notebook")
