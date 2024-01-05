SELECT SaleDate,CONVERT(Date,SaleDate) FROM [Portfolio Project].[dbo].[Portfolio Project]

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
ADD SaleDate1 Date

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET SaleDate1 = CONVERT(Date, SaleDate)

SELECT SaleDate1 FROM [Portfolio Project].[dbo].[Portfolio Project]
SELECT * FROM [Portfolio Project].[dbo].[Portfolio Project]

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


SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM  [Portfolio Project].[dbo].[Portfolio Project]

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
ADD PropertyAddress1 varchar(50),PropertyCity varchar(50)

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET PropertyAddress1 = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



SELECT a.ParcelID,a.OwnerAddress,b.ParcelID,b.OwnerAddress--,ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM [Portfolio Project].[dbo].[Portfolio Project] AS a
JOIN [Portfolio Project].[dbo].[Portfolio Project] AS b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID!=b.UniqueID
WHERE a.OwnerAddress IS NULL

--SELECT SUBSTRING(OwnerAddress,CHARINDEX(OwnerAddress,',')+1,CHARINDEX(OwnerAddress,',')-1)
--from [Portfolio Project].[dbo].[Portfolio Project]

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
ADD OwnerAddress1 varchar(50), OnwerCity varchar(50), OwnerState varchar(50);

UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET OnwerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
UPDATE [Portfolio Project].[dbo].[Portfolio Project]
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

ALTER TABLE [Portfolio Project].[dbo].[Portfolio Project]
CHANGE COLUMN OnwerCity TO OwnerCity

sp_rename '[Portfolio Project].[dbo].[Portfolio Project].OnwerCity','OwnerCity','COLUMN';

SELECT DISTINCT SoldAsVacant,COUNT(SoldAsVacant)
FROM [Portfolio Project].[dbo].[Portfolio Project]
GROUP BY SoldAsVacant
ORDER BY 2  --ORDER BY COUNT(SOLDaSvACANT)

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

SELECT SoldAsVacant, REPLACE(SoldAsVacant,'Y','Yes'),REPLACE(SoldAsVacant,'N','No')
FROM [Portfolio Project].[dbo].[Portfolio Project]

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