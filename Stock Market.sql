
---Average Closing Price by Symbol:

SELECT
    symbol,
    AVG([close]) AS average_close
FROM
    ['S&P 500 Stock Prices 2014-2017$']
GROUP BY
    symbol;



---	Total Volume Traded by Symbol:

SELECT
    symbol,
    SUM(volume) AS total_volume
FROM
    ['S&P 500 Stock Prices 2014-2017$']
GROUP BY
    symbol;



	---Highest Closing Price for Each Symbol:

	SELECT
    symbol,
    MAX([close]) AS highest_close
FROM
    ['S&P 500 Stock Prices 2014-2017$']
GROUP BY
    symbol;


	----Symbols with the Largest Daily Price Change:

SELECT
    symbol,
    date,
    [close],
    [close] - LAG([close]) OVER (PARTITION BY symbol ORDER BY date) AS price_change
FROM
  ['S&P 500 Stock Prices 2014-2017$'];


 ---- Average Closing Price per Year for  AAPL


 SELECT
    symbol,
    YEAR(date) AS year,
    AVG([close]) AS average_close
FROM
    ['S&P 500 Stock Prices 2014-2017$']
WHERE
    symbol = 'AAPL'
GROUP BY
    symbol, YEAR(date);



---Identify Days where Closing Price Increased:

	WITH PriceChanges AS (
    SELECT
        symbol,
        date,
        [close],
        LAG([close]) OVER (PARTITION BY symbol ORDER BY date) AS prev_close
    FROM
['S&P 500 Stock Prices 2014-2017$'])
SELECT
    symbol,
    date,
    [close]
FROM
    PriceChanges
WHERE
    [close] > prev_close OR prev_close IS NULL;


	----Calculate Total Volume Traded for Each Stock:

	SELECT
    symbol,
    SUM(volume) AS total_volume
FROM
    ['S&P 500 Stock Prices 2014-2017$']
GROUP BY
    symbol;



	---Identify Days where Closing Price Increased:


	WITH PriceChanges AS (
    SELECT
        symbol,
        date,
        [close],
        LAG([close]) OVER (PARTITION BY symbol ORDER BY date) AS prev_close
    FROM
        ['S&P 500 Stock Prices 2014-2017$']
)
SELECT
    symbol,
    date,
    [close]
FROM
    PriceChanges
WHERE
    [close] > prev_close OR prev_close IS NULL;



	---Calculate the Daily Price Change for Each Stock:

	SELECT
    symbol,
    date,
    [close],
    [close] - LAG([close]) OVER (PARTITION BY symbol ORDER BY date) AS price_change
FROM
    ['S&P 500 Stock Prices 2014-2017$'];


	---Identify Stocks with the Highest Daily Trading Volume:


	WITH VolumeRanking AS (
    SELECT
        symbol,
        date,
        volume,
        RANK() OVER (PARTITION BY date ORDER BY volume DESC) AS volume_rank
    FROM
        ['S&P 500 Stock Prices 2014-2017$']
)
SELECT
    symbol,
    date,
    volume
FROM
    VolumeRanking
WHERE
    volume_rank = 1;


	---Calculate the Percentage Change in Closing Price Compared to the First Day for Each Stock:

	WITH FirstDayClosing AS (
    SELECT
        symbol,
        [close] AS first_day_close
    FROM
        ['S&P 500 Stock Prices 2014-2017$']
    WHERE
        date = (SELECT MIN(date) FROM ['S&P 500 Stock Prices 2014-2017$'])
)
SELECT
    s.symbol,
    s.date,
    s.[close],
    ((s.[close] - f.first_day_close) / f.first_day_close) * 100 AS percent_change
FROM
    ['S&P 500 Stock Prices 2014-2017$'] s
JOIN
    FirstDayClosing f ON s.symbol = f.symbol;


	---Find the Average Closing Price for Each Month:

	SELECT
    symbol,
    FORMAT(date, 'yyyy-MM') AS month,
    AVG([close]) AS average_close_price
FROM
    ['S&P 500 Stock Prices 2014-2017$']
GROUP BY
    symbol, FORMAT(date, 'yyyy-MM');


	----Identify Stocks that Had a Significant Percentage Drop in Closing Price on a Specific Day:


	WITH PercentageDrop AS (
    SELECT
        symbol,
        date,
        [close],
        LAG([close]) OVER (PARTITION BY symbol ORDER BY date) AS prev_close,
        (([close] - LAG([close]) OVER (PARTITION BY symbol ORDER BY date)) / LAG([close]) OVER (PARTITION BY symbol ORDER BY date)) * 100 AS percent_change
    FROM
        ['S&P 500 Stock Prices 2014-2017$']
)
SELECT
    symbol,
    date,
    [close],
    percent_change
FROM
    PercentageDrop
WHERE
    percent_change < -5; 






