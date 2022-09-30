# Querying data using Synapse Dedicated Pool

## Description
Azure Synapse SQL is a big data analytic service that enables you to query and analyze your data using the T-SQL language. 
Dedicated SQL pool stores data in relational tables with columnar storage. This format significantly reduces the data storage costs, and improves query performance. Once data is stored, you can run analytics at massive scale

## Prerequisites


## Data Source

### Steps to create tables using dedicated SQL Pool

In this section, you will use dedicated SQL Pool to create tables.

## Steps to create script :

1.  In Synapse studio open **_Develop_** from the left side navigation.

3.  Click on  **SQL Script** to open new sql script file.

    ![openSQLScript](./assets/1_openSQLScript.JPG "Select resource groups")

3.  In the properties section rename the script to **_``create_table_dedicated``_** .

5.  Select the **_EnterpriseDW_** from the **_Connect to_** dropdown.

    ![openSQLScript](./assets/3_renameScript.JPG "rename sql script")

5.   For creating the **Date** table , run the below query.
   
     
   ``` sql
CREATE TABLE [dbo].[Date]
(
    [DateID] int NOT NULL,
    [Date] datetime NULL,
    [DateBKey] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DaySuffix] varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeek] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfQuarter] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfYear] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfMonth] varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Month] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Quarter] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [QuarterName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Year] char(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [YearName] char(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthYear] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MMYYYY] char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FirstDayOfMonth] date NULL,
    [LastDayOfMonth] date NULL,
    [FirstDayOfQuarter] date NULL,
    [LastDayOfQuarter] date NULL,
    [FirstDayOfYear] date NULL,
    [LastDayOfYear] date NULL,
    [IsHolidayUSA] bit NULL,
    [IsWeekday] bit NULL,
    [HolidayUSA] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

  ```
6.  For creating the **Geography** table run the below query.

``` sql
CREATE TABLE [dbo].[Geography]
(
    [GeographyID] int NOT NULL,
    [ZipCodeBKey] varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [County] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [City] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [State] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Country] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [ZipCode] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);
```

7. For creating the **HackneyLicense** table run the below query

``` sql
CREATE TABLE [dbo].[HackneyLicense]
(
    [HackneyLicenseID] int NOT NULL,
    [HackneyLicenseBKey] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HackneyLicenseCode] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);
```

8. For creating the **Medallion** table run the below query

``` sql
CREATE TABLE [dbo].[Medallion]
(
    [MedallionID] int NOT NULL,
    [MedallionBKey] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [MedallionCode] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);
```
9. For creating the **Time** table run the below query

``` sql
CREATE TABLE [dbo].[Time]
(
    [TimeID] int NOT NULL,
    [TimeBKey] varchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [HourNumber] tinyint NOT NULL,
    [MinuteNumber] tinyint NOT NULL,
    [SecondNumber] tinyint NOT NULL,
    [TimeInSecond] int NOT NULL,
    [HourlyBucket] varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [DayTimeBucketGroupKey] int NOT NULL,
    [DayTimeBucket] varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);
```
10. For creating the **Trip** table run the below query

``` sql
CREATE TABLE [dbo].[Trip]
(
    [DateID] int NOT NULL,
    [MedallionID] int NOT NULL,
    [HackneyLicenseID] int NOT NULL,
    [PickupTimeID] int NOT NULL,
    [DropoffTimeID] int NOT NULL,
    [PickupGeographyID] int NULL,
    [DropoffGeographyID] int NULL,
    [PickupLatitude] float NULL,
    [PickupLongitude] float NULL,
    [PickupLatLong] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DropoffLatitude] float NULL,
    [DropoffLongitude] float NULL,
    [DropoffLatLong] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [PassengerCount] int NULL,
    [TripDurationSeconds] int NULL,
    [TripDistanceMiles] float NULL,
    [PaymentType] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FareAmount] money NULL,
    [SurchargeAmount] money NULL,
    [TaxAmount] money NULL,
    [TipAmount] money NULL,
    [TollsAmount] money NULL,
    [TotalAmount] money NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);
```
11. For creating the **Weather** table run the below query

``` sql
CREATE TABLE [dbo].[Weather]
(
    [DateID] int NOT NULL,
    [GeographyID] int NOT NULL,
    [PrecipitationInches] float NOT NULL,
    [AvgTemperatureFahrenheit] float NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);
```
12. Publish the script for future references. 


## Validate Tables Created

1. In Workspace open **_Data_** from the left side navigation
2. Expand **SQL database**
3. Expand **EnterpriseDW (SQL)**
4. Expand **Tables**
5. Check the tables created.

  ![TablesCreated](./assets/2_validateTablesCreated.JPG "Select resource groups")


# SQL Script to load data using dedicated SQL Pool

In this section, you will use dedicated SQL Pool to load tables using the files stored in the ADLS Gen2 storage.

## Steps to Create Script:

1.  In Workspace open **_Develop_** from the left side navigation.

2.  Click on  **SQL Script** to open new sql script file.

  ![openSQLScript](./assets/1_openSQLScript.JPG "Select resource groups")

3.  In the properties section rename the script to **_``load_table_dedicated``_**.

4.  Select the **EnterpriseDW** from the Connect to dropdown.

  ![renameSQLScript](./assets/2_rename_load_script.JPG "rename script")

5.  Replace the **azrawStorageAccount** placeholder with the **_``Raw storage account``_** name before running the below sql script.

    ```sh
    eg. https://azrawdatalakefa256z.dfs.core.windows.net/raw/date.csv
    ```
	
6.  For loading the **Date** table run the below query.

``` sql
COPY INTO [dbo].[Date]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/date.csv'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Date] - Taxi dataset');

```

7.  For creating the **Geography** table run the below query.

``` sql
COPY INTO [dbo].[Geography]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/Geography.csv'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Geography] - Taxi dataset');
```

8. For creating the **HackneyLicense** table run the below query.

``` sql
COPY INTO [dbo].[HackneyLicense]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/HackneyLicense.csv'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[HackneyLicense] - Taxi dataset');
```

9. For creating the **Medallion** table run the below query.

``` sql
COPY INTO [dbo].[Medallion]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/Medallion.csv'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Medallion] - Taxi dataset');
```
10. For creating the **Time** table run the below query.

``` sql
COPY INTO [dbo].[Time]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/Time.csv'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Time] - Taxi dataset');
```

11. For creating the **Trip** table run the below query.

``` sql
COPY INTO [dbo].[Trip]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/Trip2013.csv'
WITH
(
   FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY : Load [dbo].[Trip] - Taxi dataset');
```

12. For creating the **Weather** table run the below query.

``` sql
COPY INTO [dbo].[Weather]
FROM 'https://<azrawStorageAccount>.dfs.core.windows.net/raw/Weather.csv'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
	
)
OPTION (LABEL = 'COPY : Load [dbo].[Weather] - Taxi dataset');
```
13. Publish the script for future reference.
 
## Validate loading data

1. In Workspace open **Data** from the left side navigation.
2. Expand **SQL database**.
3. Expand **EnterpriseDW (SQL)**.
4. Expand **Tables**.
5. Right click on any table then select **New SQL Script > Select TOP 100 Rows**.

   ![selecttop100](./assets/3_select_top100.JPG "Select top 100")

7. Run the script to check the data loaded in the table.

   ![RunQuery](./assets/4_query_result.JPG "run query")
   



