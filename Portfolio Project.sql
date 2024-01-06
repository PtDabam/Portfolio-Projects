Cleaning data via SQL queries
Link to he dataset: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx
------------------------------------------------------------------------------------------------------------------------------------------
--Using the CONVERT() function to change the SalaDate column data type to the date type
SELECT SaleDate,CONVERT(Date,SaleDate) FROM [Portfolio Project].[dbo].[Portfolio Project]

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
ADD SaleDate1 Date

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET SaleDate1 = CONVERT(Date, SaleDate)

SELECT SaleDate1 FROM [Portfolio Project].[dbo].[Portfolio Project]
SELECT * FROM [Portfolio Project].[dbo].[Portfolio Project]

--This is a self join ie joining a table to itself. This helped me to deal with nulls by findind records that had thesame ParceID but different uniqueID
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM [Portfolio Project].[dbo].[Portfolio Project] AS a
JOIN [Portfolio Project].[dbo].[Portfolio Project] AS b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID!=b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].[dbo].[Portfolio Project] AS a
JOIN [Portfolio Project].[dbo].[Portfolio Project] AS b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID!=b.UniqueID
WHERE a.PropertyAddress IS NULL

SELECT * FROM [Portfolio Project].[dbo].[Portfolio Project]
WHERE PropertyAddress IS NULL

--Splitting the PropertyAddress column into three new columns 

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM  [Portfolio Project].[dbo].[Portfolio Project]

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
ADD PropertyAddress1 varchar(50),PropertyCity varchar(50)

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET PropertyAddress1 = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--Trying to find out if there are similar records with same ParceID inorder to deal with nulls in the OwnwerAddress column 
SELECT a.ParcelID,a.OwnerAddress,b.ParcelID,b.OwnerAddress--,ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM [Portfolio Project].[dbo].[Portfolio Project] AS a
JOIN [Portfolio Project].[dbo].[Portfolio Project] AS b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID!=b.UniqueID
WHERE a.OwnerAddress IS NULL

--SELECT SUBSTRING(OwnerAddress,CHARINDEX(OwnerAddress,',')+1,CHARINDEX(OwnerAddress,',')-1)
--from [Portfolio Project].[dbo].[Portfolio Project]

--Breaking the Owner address column into three new columns
ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
ADD OwnerAddress1 varchar(50), OnwerCity varchar(50), OwnerState varchar(50);

--Using the PARSENAME() and REPLACE() functionS to split a string at the delimiter, period
UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET OnwerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
CHANGE COLUMN OnwerCity TO OwnerCity

--Using sp_rename to change a column name
sp_rename '[Portfolio Project].[dbo].[Portfolio Project].OnwerCity','OwnerCity','COLUMN';

SELECT DISTINCT SoldAsVacant,COUNT(SoldAsVacant)
FROM [Portfolio Project].[dbo].[Portfolio Project]
GROUP BY SoldAsVacant
ORDER BY 2  --ORDER BY COUNT(SoldAsVacant)

--Using CASE ststements to standardize the SoldAsVacant column
SELECT
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
     WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
end
from [Portfolio Project].[dbo].[Portfolio Project]

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET SoldAsVacant =CASE WHEN SoldAsVacant='Y' THEN 'Yes'
	 WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
end

--Try and error code. MEant to serve same purpose as the code immediately above
SELECT SoldAsVacant, REPLACE(SoldAsVacant,'Y','Yes'),REPLACE(SoldAsVacant,'N','No')
FROM [Portfolio Project].[dbo].[Portfolio Project]


--Using a CTE an ROW_NUMBER() and PARTITION BY to deal with duplicates
WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
ORDER BY UniqueID) AS row_num
From [Portfolio Project].[dbo].[Portfolio Project]
)
SELECT *
From RowNumCTE
Where row_num > 1

SELECT * FROM [Portfolio Project].[dbo].[Portfolio Project]

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
