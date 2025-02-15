use [PRODUCT DATABASE]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_PRODUCTS_DATA_32_933578364__K1_K5] ON [dbo].[PRODUCTS_DATA]
(
	[ProductKey] ASC,
	[EnglishProductName] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

-------------------
CREATE STATISTICS [_dta_stat_997578592_2_1] ON [dbo].[SALES_DATA]([OrderDateKey], [ProductKey])
WITH AUTO_DROP = OFF

-------------------
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_TIME_DATA_32_901578250__K15_K14_K10_1] ON [dbo].[TIME_DATA]
(
	[CalendarYear] ASC,
	[CalendarQuarter] ASC,
	[EnglishMonthName] ASC
)
INCLUDE([TimeKey]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


-------------
CREATE STATISTICS [_dta_stat_901578250_1_15_14_10] ON [dbo].[TIME_DATA]([TimeKey], [CalendarYear], [CalendarQuarter], [EnglishMonthName])
WITH AUTO_DROP = OFF
