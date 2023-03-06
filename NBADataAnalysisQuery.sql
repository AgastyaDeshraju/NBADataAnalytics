
--Checking to see if all the tables are loaded correctly
SELECT 
	*
FROM
	ThreePoint


SELECT 
	*
FROM
	Assists


SELECT 
	*
FROM
	Efficiency


SELECT 
	*
FROM
	FreeThrows


SELECT 
	*
FROM
	Minutes


SELECT 
	*
FROM
	Points


SELECT 
	*
FROM
	Rebounds


SELECT 
	*
FROM
	StealsBlocks



--Doing further analysis on the data

--Rlayoff points leader since 2012-13
SELECT 
	 Season_type, Player_ID, Player, Sum(GP) as Total_Games_Played, Position, Round(Avg (Pts),2) as Points_Average
FROM
	Points
WHERE 
	Season_type = 'Playoffs'
GROUP BY
	 Player_ID, Season_type, Player,  Position
ORDER BY 
	Points_Average DESC


--Regular season points leader since 2012-13
SELECT 
	 Season_type, Player_ID, Player, Sum(GP) as Total_Games_Played, Position, Round(Avg (Pts),2) as Points_Average
FROM
	Points
WHERE 
	Season_type = 'Regular Season'
GROUP BY
	 Player_ID, Season_type, Player,  Position
ORDER BY 
	Points_Average DESC


--Comparing averages of guards, forwards and centers in the points, rebounds and assists columns
SELECT
	P.Player_ID, P.Position, Points.PTS, Assists.AST
FROM
	Points P 
LEFT JOIN Assists A
ON P.Player_ID = A.Player_ID
WHERE 
	P.Year='2012-13'
--This code doesn't work as the player_id keeps repeating throughout the dataset for different years and different season types





--Lets form tables to store the aggregated values for all the different conditions

--Creating table for points

	--Regular Season
	CREATE TABLE AggregatedPointsRS
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

	SELECT * FROM AggregatedPointsRS
	ORDER BY PointsRS DESC

	--Playoffs
	CREATE TABLE AggregatedPointsP
	(
		Player_Id numeric,
		Player nvarchar(255),
		Position nvarchar(255),
		GamesPlayedP numeric,
		PointsP float,
		FGMP float,
		FGAP float,
		FG_PCTP float
	)
	INSERT INTO AggregatedPointsP
	SELECT
		P.PLAYER_ID, P.PLAYER, P.POSITION, SUM(P.GP), ROUND(AVG(P.PTS),1),ROUND(AVG(P.FGM),2), ROUND(AVG(P.FGA),2), ROUND(AVG(P.FG_PCT),2)
	FROM Points P
	WHERE
		SEASON_TYPE = 'Playoffs'
	GROUP BY
		P.PLAYER_ID, P.PLAYER, P.POSITION
	ORDER BY 
		avg(PTS) desc

	SELECT * FROM AggregatedPointsP
	ORDER BY PointsP DESC



--Creating table for assists

	--Regular Season
	CREATE TABLE AggregatedAssistsRS
	(
		Player_Id numeric,
		Player nvarchar(255),
		Position nvarchar(255),
		GamesPlayedRS numeric,
		AssistsRS float,
		TovRS float,
		Ast_TovRS float,
	)
	INSERT INTO AggregatedAssistsRS
	SELECT
		A.PLAYER_ID, A.PLAYER, A.POSITION, SUM(A.GP), ROUND(AVG(A.AST),1),ROUND(AVG(A.TOV),1), ROUND(AVG(A.AST_TOV),2)
	FROM Assists A
	WHERE
		SEASON_TYPE = 'Regular Season'
	GROUP BY
		A.PLAYER_ID, A.PLAYER, A.POSITION
	ORDER BY 
		avg(AST) desc

	SELECT * FROM AggregatedAssistsRS
	ORDER BY AssistsRS DESC

	--Playoffs
	CREATE TABLE AggregatedAssistsP
	(
		Player_Id numeric,
		Player nvarchar(255),
		Position nvarchar(255),
		GamesPlayedP numeric,
		AssistsP float,
		TovP float,
		Ast_TovP float,
	)
	INSERT INTO AggregatedAssistsP
	SELECT
		A.PLAYER_ID, A.PLAYER, A.POSITION, SUM(A.GP), ROUND(AVG(A.AST),1),ROUND(AVG(A.TOV),1), ROUND(AVG(A.AST_TOV),2)
	FROM Assists A
	WHERE
		SEASON_TYPE = 'Playoffs'
	GROUP BY
		A.PLAYER_ID, A.PLAYER, A.POSITION
	ORDER BY 
		avg(AST) desc

	SELECT * FROM AggregatedAssistsP
	ORDER BY AssistsP DESC

--CREATING TABLES FOR REBOUNDS
	--Regular Season
		CREATE TABLE AggregatedReboundsRS
	(
		Player_Id numeric,
		Player nvarchar(255),
		Position nvarchar(255),
		GamesPlayedRS numeric,
		ReboundsRS float,
		OffensiveRS float,
		DefensiveRS float,
	)
	INSERT INTO AggregatedReboundsRS
	SELECT
		R.PLAYER_ID, R.PLAYER, R.POSITION, SUM(R.GP), ROUND(AVG(R.REB),1),ROUND(AVG(R.OREB),1), ROUND(AVG(R.DREB),1)
	FROM Rebounds R
	WHERE
		SEASON_TYPE = 'Regular Season'
	GROUP BY
		R.PLAYER_ID, R.PLAYER, R.POSITION
	ORDER BY 
		avg(REB) desc

	SELECT * FROM AggregatedReboundsRS
	ORDER BY ReboundsRS DESC

		--Regular Season
		CREATE TABLE AggregatedReboundsP
	(
		Player_Id numeric,
		Player nvarchar(255),
		Position nvarchar(255),
		GamesPlayedP numeric,
		ReboundsP float,
		OffensiveP float,
		DefensiveP float,
	)
	INSERT INTO AggregatedReboundsP
	SELECT
		R.PLAYER_ID, R.PLAYER, R.POSITION, SUM(R.GP), ROUND(AVG(R.REB),1),ROUND(AVG(R.OREB),1), ROUND(AVG(R.DREB),1)
	FROM Rebounds R
	WHERE
		SEASON_TYPE = 'Playoffs'
	GROUP BY
		R.PLAYER_ID, R.PLAYER, R.POSITION
	ORDER BY 
		avg(REB) desc

	SELECT * FROM AggregatedReboundsP
	ORDER BY ReboundsP DESC


--Joining the points, assists and rebounds
SELECT P.Player_Id, P.Player, P.Position, P.PointsRS, A.AssistsRS, R.ReboundsRS
FROM AggregatedPointsRS P
LEFT JOIN AggregatedAssistsRS A
ON P.Player_Id = A.Player_Id
LEFT JOIN AggregatedReboundsRS R
ON P.Player_Id = R.Player_Id
ORDER BY PointsRS DESC

--Grouping by the player's position to find out if different positions have different stats 
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
ORDER BY 
	Average_Points_Position DESC

--Creating a view for the above analysis to easily copy for visualization
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



--Finding Regular Season vs Playoffs Stats per year
	
	--Points
	CREATE TABLE PointsYears
	(
		Year nvarchar(255),
		Season_type nvarchar(255),
		PointsPerYear float
	)
	INSERT INTO PointsYears
	SELECT
		YEAR,SEASON_TYPE, ROUND(AVG(PTS),2)
	FROM Points
	GROUP BY
		YEAR, SEASON_TYPE

	SELECT * FROM PointsYears
	ORDER BY YEAR, Season_type

	--Assists
	CREATE TABLE AssistsYears
	(
		Year nvarchar(255),
		Season_type nvarchar(255),
		AssistsPerYear float
	)
	INSERT INTO AssistsYears
	SELECT
		YEAR,SEASON_TYPE, ROUND(AVG(AST),2)
	FROM Assists
	GROUP BY
		YEAR, SEASON_TYPE

	SELECT * FROM AssistsYears
	ORDER BY YEAR, Season_type


	--Rebounds
	CREATE TABLE ReboundsYears
	(
		Year nvarchar(255),
		Season_type nvarchar(255),
		ReboundsPerYear float
	)
	INSERT INTO ReboundsYears
	SELECT
		YEAR,SEASON_TYPE, ROUND(AVG(REB),2)
	FROM Rebounds
	GROUP BY
		YEAR, SEASON_TYPE

	SELECT * FROM ReboundsYears
	ORDER BY YEAR, Season_type

GO
CREATE VIEW SeasonDistributionStats AS
SELECT P.Year, P.Season_Type, P.PointsPerYear, R.ReboundsPerYear, A.AssistsPerYear
FROM PointsYears P
LEFT JOIN AssistsYears A
ON P.Year = A.Year AND P.Season_type = A.Season_type
LEFT JOIN ReboundsYears R
ON P.Year = R.Year AND P.Season_type = R.Season_type


--Observing trend in 3 point attempts over the years per player
SELECT
	YEAR, SEASON_TYPE, ROUND(AVG(THREEPFGM),1) AS ThreePointMade, ROUND(AVG(THREEPFGA),1) AS ThreePointAttempts, ROUND(AVG(THREEPFG_PCT), 2) AS ThreePointPercentage
FROM
	ThreePoint
GROUP BY YEAR, SEASON_TYPE
ORDER BY YEAR ASC, SEASON_TYPE DESC


--Creating a view
GO
CREATE VIEW ThreePointTrendPlayer AS
SELECT
	YEAR, SEASON_TYPE, ROUND(AVG(THREEPFGM),1) AS ThreePointMade, ROUND(AVG(THREEPFGA),1) AS ThreePointAttempts, ROUND(AVG(THREEPFG_PCT), 2) AS ThreePointPercentage
FROM
	ThreePoint
GROUP BY YEAR, SEASON_TYPE



--Observing tren in three point attempts per team over the years
SELECT
	YEAR, TEAM, ROUND(SUM(THREEPFGM),1) AS ThreePointMade, ROUND(SUM(THREEPFGA),1) AS ThreePointAttempts, ROUND(AVG(THREEPFG_PCT), 2) AS ThreePointPercentage
FROM
	ThreePoint
GROUP BY YEAR, TEAM
ORDER BY YEAR ASC

--Creating a view
GO
CREATE VIEW ThreePointTrendTeam AS
SELECT
	YEAR, TEAM, ROUND(SUM(THREEPFGM),1) AS ThreePointMade, ROUND(SUM(THREEPFGA),1) AS ThreePointAttempts, ROUND(AVG(THREEPFG_PCT), 2) AS ThreePointPercentage
FROM
	ThreePoint
GROUP BY YEAR, TEAM;



--Shot distribution over the years per player
--Using Common Table Expressions (CTEs) to show the distribution utilizing 3 different tables
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
	G.YEAR
ORDER BY 
	YEAR
--

--Creating a view for the above data
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


--Analysing the effectiveness and true shooting percentage of a player vs their total attempts (field goal attempts and free throw attempts)
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

--Creating a view for the above data

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


--Checking all the data in the views

SELECT * FROM EfficiencyTable

SELECT * FROM POSITION_DISTRIBUTION

SELECT * FROM SeasonDistributionStats

SELECT * FROM ShotDistribution

SELECT * FROM ThreePointTrendPlayer

SELECT * FROM ThreePointTrendTeam