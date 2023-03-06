# Webscraping NBA Data and performing analysis

## Introduction

The project is designed to scrape data from the official [NBA website](https://www.nba.com). Webscraping was performed using Python and Jupyter Notebooks. After scraping the initial data, there was a realization that the data on the NBA website did not contain the positions of each player. As that is a key metric that was used in the Data Analyis, a dataset with every player's name and position was found on Kaggle and mapped onto each players name using Pandas.

This data was then exported to Excel as a .xlsx file. Some rudimentary data cleaning was performed, as well as a calculation to find the true shooting percentage of each player.

```math
TS\% = {{PTS}\over{(2*(FGA+0.44*FTA))}}
```

The dataset was then split into different files. This was done to make the data analysis in SQL less complicated. Analysis was performed using a variety of SQL functions including JOINs, VIEWs, CTEs, Temp Tables, etc. VIEWs were created for certain analyses, that were then brought into Tableau to visualize the data. A publicly available [interactive dashboard](https://public.tableau.com/app/profile/agastya.deshraju/viz/NBADataAnalytics/Dashboard1) was then created.


## Web Scraping

The first step of the project was web scraping. The link to the jupyter notebook used to scrape the data is [this](https://github.com/AgastyaDeshraju/NBADataAnalytics/blob/main/NBA%20Player%20Data%20Web%20Scraping%20Code.ipynb) The data was scraped from the [stats](https://www.nba.com/stats) page of nba.com. The library used to perform the web scraping is ``` requests ```.
 
* First, I needed to make sure whether the requests package is installed or not.
    
```python 
!pip install requests
```

* After the requests package is installed, we can begin to import all the necessary packages used in webscraping.


```python
import pandas as pd
import requests
pd.set_option('display.max_columns', None)
import time
import numpy as np
```

* Then, I conducted a test to figure out the part of the url from the website that affects different fields in the webpage. The main fields we had to control were the Season Type(Regular Season/Playoffs) and the Years(2012-13 to 2021-22). This was done by inspecting the webpage and finding the name of the network which corresponded to the data we wanted to scrape. 
![image](https://user-images.githubusercontent.com/82213456/223009218-aa2acf8f-0af4-43c6-be28-270947532564.png)


```python
test_url = 'https://stats.nba.com/stats/leagueLeaders?LeagueID=00&PerMode=PerGame&Scope=S&Season=2021-22&SeasonType=Regular%20Season&StatCategory=PTS'
r = requests.get(test_url).json()
```

* From the link above we can notice a certain pattern, the season year is contained in the ``` Season= ``` section of the url, whereas the season type is contained in the ``` SeasonType= ``` section of the url.


* ``` requests.get(url).json() ``` is used to send a request to the webpage for certain data that the url contains. In our case it returned the different field of the data are interested in.


```
{'resource': 'leagueleaders',
 'parameters': {'LeagueID': '00',
  'PerMode': 'PerGame',
  'StatCategory': 'PTS',
  'Season': '2021-22',
  'SeasonType': 'Regular Season',
  'Scope': 'S',
  'ActiveFlag': None},
 'resultSet': {'name': 'LeagueLeaders',
  'headers': ['PLAYER_ID',
   'RANK',
   'PLAYER',
   'TEAM_ID',
   'TEAM',
   'GP',
   'MIN',
   'FGM',
   'FGA',
   'FG_PCT',
   'FG3M',
   'FG3A',
   'FG3_PCT',
   'FTM',
   'FTA',
   'FT_PCT',
   'OREB',
   'DREB',
   'REB',
   'AST',
   'STL',
   'BLK',
   'TOV',
   'PTS',
   'EFF'],
  'rowSet':
  ```
  
  
* The rowSet contains the data for each player in each field listed in the headers. The headers were stored and used as column names of the dataframe we form later.
 
* The headers from the url were stored in a dictionary, as it can often be used by the webpage to authorize the scraping process.


```python
headers = {
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.9,es;q=0.8',
    'Connection': 'keep-alive',
    'Host': 'stats.nba.com',
    'If-Modified-Since': 'Thu, 2 Mar 2022 18:52:53 GMT',
    'Origin': 'https://www.nba.com',
    'Referer': 'https://www.nba.com/',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': "Windows",
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-site',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'
}
```

* The last step in the webscraping process was to actually scrape the data. From the test url we were able to figure out what part of the url contains the season year and type. A list was created for both the values, year from 2012-13 to 2013-14 and type containing Regular Season and Playoffs.

* A nested for loop was created to iterate through both the values, formatting the url to include them in the correct sections and sending a request to the webpage to scrape the data. A time lag was also added at random intervals, as often times when data is scraped in succession a webpage might ban the user's IP address as it might be under the impression that the user is a bot.

* The data was stored in DataFrames using the Pandas library


```python
season_types = ['Regular%20Season','Playoffs']
years = ['2012-13','2013-14','2014-15','2015-16','2016-17','2017-18','2018-19','2019-20','2020-21','2021-22']

begin_loop = time.time()

for y in years:
    
    for s in season_types:
        
        api_url = 'https://stats.nba.com/stats/leagueLeaders?LeagueID=00&PerMode=PerGame&Scope=S&Season='+y+'&SeasonType='+s+'&StatCategory=PTS'
        r = requests.get(url = api_url, headers = headers).json()
        temp_df1 = pd.DataFrame(r['resultSet']['rowSet'], columns = table_headers)
        temp_df2 = pd.DataFrame({'Year':[y for i in range(len(temp_df1))], 
                                 'Regular/Playoffs':[s for i in range(len(temp_df1))]})
        temp_df3 = pd.concat([temp_df2, temp_df1], axis = 1)
        
        df = pd.concat([df,temp_df3], axis=0)
        
        print(f'Finished scraping data for the {y} {s}.')
        
        lag=np.random.uniform(low=5,high=40)
        
        print(f'...waiting {round(lag,1)} seconds')
        
        time.sleep(lag) #creating a lag so that we don't get rate limited while scraping data from nba.com
  

print(f'Process completed. Total run time: {round((time.time()-begin_loop)/60,2)} minutes')
```


* The resulting dataset looked like:
![image](https://user-images.githubusercontent.com/82213456/223012181-32c62c09-e1c0-40e2-b709-df0ef3698389.png)


* This data does not contain the player's position, which is a key metric. A player's position determines what role they play on a team, therefore I thought it was necessary to include the data in my project. 
* NBA.com does not really have a database of player's info, and the one it does have blocks any attempts at scraping
* I started looking for other ways to find this data, Kaggle turned out to be the best option. After downloading the dataset and reading it into my code using pandas, and isolating the columns which I required, which were the player's name and their position.


```python
player_info = pd.read_csv('player_info.csv')
player_position = player_info[['name','position']]
```

* After that, a dictionary was created using these values, which would then be used to map the data on to the intial webscraped data.


```python
mapping_position = dict(player_position.values) #creating a dictionary using the name and the position from the nba_info dataset
player_data['POSITION'] = player_data['PLAYER'].map(mapping_position) #mapping the dictionary onto the original dataset
```


* There seemed to be some information missing in the dataset downloaded from Kaggle, around 440 players. It would not affect the analysis that much, so I chose to drop those values.

* The final dataset was then exported into an Excel file

```python
player_data.to_excel('nba_player_data_with_positions.xlsx', index=False) #Exporting the final dataset to Excel for further cleaning
```


## Data Cleaning in Excel

* The data we received from the webscraping was mostly clean, except for one problem. The position that we mapped onto the data had some ambiguous values. There are certain players in the NBA that are capable of playing more than one position, and the data contained these values as well (F-G, F-C, etc. instead of just G, F and C). Through some previous knowledge I was able to figure out that the value given first in the pair, is the player's more common position.
![Screenshot (206)](https://user-images.githubusercontent.com/82213456/223014049-cde3c92c-6a0a-4b4a-abf4-df367fe28be1.png)



* Using the =LEFT function I was able to seperate the values.
![Screenshot (208)](https://user-images.githubusercontent.com/82213456/223014070-0cc6ce7d-3a4d-466b-bd48-fd8f5a0cd712.png)

* The column was then moved close to the player's name, team, and other useful information
![image](https://user-images.githubusercontent.com/82213456/223014226-24d805a6-ee24-4507-9106-666cf5090c90.png)


* Another column was added to the dataset, for True Shooting Percentage. It is a valuable metric that can be used to calculate the efficiency for a player. The formula used to calculate the True Shooting Percentage is:

```math
TS\% = {{PTS}\over{(2*(FGA+0.44*FTA))}}
```


* After that, the whole dataset was split into multiple tables, to make it less complex during analysis in SQL.
![image](https://user-images.githubusercontent.com/82213456/223014530-8ae746eb-58a0-4a89-8518-2561c1f8ef2a.png)


## Data Analysis using SQL

* All the different tables from excel were imported into Microsoft SQL Server.

* Made temporary tables to aggregate the points, rebounds and assists of each position. This was done for both the regular season and playoffs.

```sql
	CREATE TABLE #AggregatedPointsRS
	(
		Player_Id numeric,
		Player nvarchar(255),
		Position nvarchar(255),
		GamesPlayedRS numeric,
		PointsRS float,
		FGMRS float,
		FGARS float,
		FG_PCTRS float
	)
	INSERT INTO AggregatedPointsRS
	SELECT
		P.PLAYER_ID, P.PLAYER, P.POSITION, SUM(P.GP), ROUND(AVG(P.PTS),1),ROUND(AVG(P.FGM),2), ROUND(AVG(P.FGA),2), ROUND(AVG(P.FG_PCT),2)
	FROM Points P
	WHERE
		SEASON_TYPE = 'Regular Season'
	GROUP BY
		P.PLAYER_ID, P.PLAYER, P.POSITION
	ORDER BY 
		avg(PTS) desc
```


* This code shows the aggregated for the regular season and the points field, this was done 5 more times to cover the playoffs as well as assists and rebounds per position.

* After that, the tables for the regular season were joined and aggregated by position, taking averages of each player's stats. A view was created of this table to allow for easy access to the data later on.

```sql
GO
CREATE VIEW POSITION_DISTRIBUTION AS
SELECT 
	P.Position, Round(Avg(P.PointsRS),2) as Average_Points_Position, Round(Avg(A.AssistsRS),2) as Average_Assists_Position, Round(Avg(R.ReboundsRS),2) as Average_Rebounds_Position
FROM 
	AggregatedPointsRS P
LEFT JOIN AggregatedAssistsRS A
ON P.Player_Id = A.Player_Id
LEFT JOIN AggregatedReboundsRS R
ON P.Player_Id = R.Player_Id
GROUP BY 
	P.Position

SELECT * FROM POSITION_DISTRIBUTION
```

* Then, the data was aggregated by the year and the season type, to see if there are any changes in the 3 basic stats over the past 10 years.

* The same aggregation was done but this time the data was grouped by the year and the season type

* After that another view was created with this data.

```sql
GO
CREATE VIEW SeasonDistributionStats AS
SELECT P.Year, P.Season_Type, P.PointsPerYear, R.ReboundsPerYear, A.AssistsPerYear
FROM PointsYears P
LEFT JOIN AssistsYears A
ON P.Year = A.Year AND P.Season_type = A.Season_type
LEFT JOIN ReboundsYears R
ON P.Year = R.Year AND P.Season_type = R.Season_type
```

* A view was created to observe the trend in the increase of 3 point attempts over the past 10 years


```sql
GO
CREATE VIEW ThreePointTrendTeam AS
SELECT
	YEAR, TEAM, ROUND(SUM(THREEPFGM),1) AS ThreePointMade, ROUND(SUM(THREEPFGA),1) AS ThreePointAttempts, ROUND(AVG(THREEPFG_PCT), 2) AS ThreePointPercentage
FROM
	ThreePoint
GROUP BY YEAR, TEAM;
```


* Using multiple CTEs (Common Table Expressions), I was able to calculate the number of 2 point field goal attempts and makes and joined this data along with free throw stats, grouping it by player and year.


```sql
GO
CREATE VIEW ShotDistribution AS
WITH 
	FGS AS
		(
			SELECT P.PLAYER AS PLAYER, P.YEAR AS YEAR, ROUND(AVG(P.FGM),2) AS FGM, ROUND(AVG(P.FGA),2) AS FGA, ROUND(AVG(T.THREEPFGM),2) AS THREPFGM, ROUND(AVG(T.THREEPFGA),2) AS THREPFGA, ROUND(AVG(P.FGM-T.THREEPFGM),2) AS TWOPFGM, ROUND(AVG(P.FGA-T.THREEPFGA),2) AS TWOPFGA
			FROM Points P
			LEFT JOIN ThreePoint T ON P.Player_ID = T.PLAYER_ID
			LEFT JOIN ThreePoint ON P.YEAR = T.YEAR
			GROUP BY P.PLAYER, P.YEAR
		),

	FTS AS
		(
			SELECT PLAYER AS PLAYER, YEAR AS YEAR, ROUND(AVG(FTM),2) AS FTM, ROUND(AVG(FTA),2) AS FTA
			FROM FreeThrows 
			GROUP BY PLAYER, YEAR
		)
SELECT 
	G.YEAR, ROUND(AVG(G.FGM),2) AS FGM, ROUND(AVG(G.FGA),2) AS FGA, ROUND(AVG(G.THREPFGM),2) AS FGM3, ROUND(AVG(G.THREPFGA),2) AS FGA3, ROUND(AVG(G.TWOPFGM),2) AS FGM2, ROUND(AVG(G.TWOPFGA),2) AS FGA2, ROUND(AVG(T.FTM),2) AS FTM, ROUND(AVG(T.FTA),2) AS FTAttempts,
	(ROUND(AVG(G.FGM + T.FTM),2)) AS TotalMakes, (ROUND(AVG(G.FGA + T.FTA),2)) AS TotalAttempts
FROM 
	FGS G
LEFT JOIN 
	FTS T
ON G.PLAYER = T.PLAYER
GROUP BY 
	G.YEAR;
```


* The last analysis relates to the efficienct of a player. CTEs were again used to join the dataset containing the True shooting percentage and the field goal  and free throw attempts of a player. The final view was created to store this data in an easily accessible way.

```sql
GO
CREATE VIEW EfficiencyTable AS 
WITH 
	FGSFTS AS
		(
			SELECT P.PLAYER AS PLAYER, ROUND(AVG(P.FGM),2) AS FGM, ROUND(AVG(P.FGA),2) AS FGA, ROUND(AVG(T.FTM),2) AS FTM, ROUND(AVG(T.FTA),2) AS FTA, ROUND(AVG(P.FGM+T.FTM),2) AS SumOfMakes, ROUND(AVG(P.FGA+T.FTA),2) AS SumOfAttempts
			FROM Points P
			LEFT JOIN FreeThrows T ON P.Player_ID = T.PLAYER_ID
			GROUP BY P.PLAYER
		),
	TSPER AS
		(
			SELECT PLAYER AS PLAYER, ROUND(AVG(EFF),2) AS EFF, ROUND(AVG(TSPER),2) AS TSPER
			FROM Efficiency 
			GROUP BY PLAYER
		)
	SELECT F.PLAYER, F.SumOfMakes, F.SumOfAttempts, T.EFF, T.TSPER
	FROM FGSFTS F
	LEFT JOIN TSPER T ON F.Player = T.Player;
```

* All the views created were then executed to copy the data onto Excel. This data was then fed into Tableau for visualization.


```sql
SELECT * FROM EfficiencyTable

SELECT * FROM POSITION_DISTRIBUTION

SELECT * FROM SeasonDistributionStats

SELECT * FROM ShotDistribution

SELECT * FROM ThreePointTrendPlayer

SELECT * FROM ThreePointTrendTeam
```


## Data Visualization in Tableau

All the data was then visualized on Tableau, and a dashboard was created [LINK](https://public.tableau.com/app/profile/agastya.deshraju/viz/NBADataAnalytics/Dashboard1)
![image](https://user-images.githubusercontent.com/82213456/223018791-24dc4fb4-cb17-4310-9955-2491be99333c.png)








