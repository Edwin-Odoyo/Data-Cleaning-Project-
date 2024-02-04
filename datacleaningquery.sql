--DATA CLEANING
SELECT *
FROM PortfolioProject..NashvilleHousingData

--Formating the SaleDate 

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousingData

Update PortfolioProject..NashvilleHousingData
set SaleDate = convert(Date, SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousingData
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousingData
set SaleDate = convert(Date, SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousingData

--Populate data on Property Address using a reference point since property address cannot be null

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousingData
--where PropertyAddress is null 
order by ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..NashvilleHousingData as A
join PortfolioProject..NashvilleHousingData as B 
on A.ParcelID = B.ParcelID
and A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress =	NULL 

UPDATE A
SET PropertyAddress= isnull (A.PropertyAddress, B.PropertyAddress)
FROM PortfolioProject..NashvilleHousingData as A
join PortfolioProject..NashvilleHousingData as B 
on A.ParcelID = B.ParcelID
and A.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress =	NULL 

--Address into individual colums i.e Address, City, State 

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousingData

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX (',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousingData

ALTER TABLE PortfolioProject..NashvilleHousingData
Add SeparatedPropertyAdress nvarchar (255);

Update PortfolioProject..NashvilleHousingData
set SeparatedPropertyAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX (',',PropertyAddress) -1) 

ALTER TABLE PortfolioProject..NashvilleHousingData
Add SeparatedPropertyCity nvarchar (255);

Update PortfolioProject..NashvilleHousingData
set SeparatedPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT SeparatedPropertyAdress 
FROM PortfolioProject..NashvilleHousingData

--alternative method

SELECT 
PARSENAME(replace (OwnerAddress,',', '.'), 3),
PARSENAME(replace (OwnerAddress,',', '.'), 2),
PARSENAME(replace (OwnerAddress,',', '.'), 1)
FROM PortfolioProject..NashvilleHousingData

--adding the  columns and values
ALTER TABLE PortfolioProject..NashvilleHousingData
Add OwnerPropertyState nvarchar (255);

ALTER TABLE PortfolioProject..NashvilleHousingData
Add OwnerPropertyCity nvarchar (255);

ALTER TABLE PortfolioProject..NashvilleHousingData
Add OwnerPropertyAddress nvarchar (255);


Update PortfolioProject..NashvilleHousingData
set OwnerPropertyState = PARSENAME(replace (OwnerAddress,',', '.'), 1)

Update PortfolioProject..NashvilleHousingData
set OwnerPropertyCity = PARSENAME(replace (OwnerAddress,',', '.'), 2)


Update PortfolioProject..NashvilleHousingData
set OwnerPropertyAddress =PARSENAME(replace (OwnerAddress,',', '.'), 3)


SELECT *
FROM PortfolioProject..NashvilleHousingData

--SoldasVacant altering yes and no to Y and N


SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousingData
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant, 
case when SoldAsVacant = 'Y'THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END 
FROM PortfolioProject..NashvilleHousingData


Update PortfolioProject..NashvilleHousingData
set SoldAsVacant = case when SoldAsVacant = 'Y'THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END 

--View updates

 SELECT *
	  FROM PortfolioProject..NashvilleHousingData

	  --Removing Duplicates 

	  with RowNumCTE AS (
SELECT *, 
 ROW_NUMBER () OVER (Partition by parcelID, 
									PropertyAdress, 
									SalePrice,
									SaleDate,
									LegalReference
			ORDER BY UniqueID ) row_num
 FROM PortfolioProject..NashvilleHousingData
 Order by ParcelID
  )
  select *
  from RowNumCTE 

--querying cte 


 with RowNumCTE AS (
SELECT *, 
 ROW_NUMBER () OVER (Partition by parcelID, 
									PropertyAdress, 
									SalePrice,
									SaleDate,
									LegalReference
			ORDER BY UniqueID ) row_num
 FROM PortfolioProject..NashvilleHousingData
 Order by ParcelID
  )
  select *
  from RowNumCTE 

  where row_num > 1
  Order by PropertyAddress 

 -- Delete Unused Columns 


  SELECT *
  FROM PortfolioProject..NashvilleHousingData

  Alter table PortfolioProject..NashvilleHousingData
  Drop Column OwnerAddress, TaxDistrict, PropertyAddress 

  Alter table PortfolioProject..NashvilleHousingData
  Drop Column SaleDate

  



 -- END

