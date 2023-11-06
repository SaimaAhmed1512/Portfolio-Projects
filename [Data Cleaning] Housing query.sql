SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project Data Cleaning (Housing)].[dbo].[Nashville Housing]

Select * 
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

select saledate, convert(date,saledate)
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

update [Nashville Housing]
set saledate = convert(date,saledate)

alter table [Nashville Housing]
Add SaleDateConverted Date; 

Update [Nashville Housing]
set SaleDateConverted = Convert(date,saledate)

select saledateconverted, convert(date,saledate)
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

select *
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]
where PropertyAddress is null

select *
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]
order by ParcelID

select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing] a
Join [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID] 
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing] a
Join [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID] 
where a.PropertyAddress is null

Select PropertyAddress 
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]
where PropertyAddress is null

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address
, substring(PropertyAddress, charindex(',', PropertyAddress) + 1, Len(PropertyAddress)) as City
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

alter table [Nashville Housing]
Add PropertyRoad Nvarchar(255); 

Update [Nashville Housing]
set PropertyRoad = substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

alter table [Nashville Housing]
Add PropertyCity Nvarchar(255); 

Update [Nashville Housing]
set PropertyCity = substring(PropertyAddress, charindex(',', PropertyAddress) + 1, Len(PropertyAddress)) 

Select OwnerAddress
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

Select
Parsename(replace(OwnerAddress, ',', '.'), 3)
, Parsename(replace(OwnerAddress, ',', '.'), 2)
, Parsename(replace(OwnerAddress, ',', '.'), 1)
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

alter table [Nashville Housing]
Add OwnerRoad Nvarchar(255); 

Update [Nashville Housing]
set OwnerRoad = Parsename(replace(OwnerAddress, ',', '.'), 3)

alter table [Nashville Housing]
Add OwnerCity Nvarchar(255); 

Update [Nashville Housing]
set OwnerCity = Parsename(replace(OwnerAddress, ',', '.'), 2)

alter table [Nashville Housing]
Add OwnerState Nvarchar(255); 

Update [Nashville Housing]
set OwnerState = Parsename(replace(OwnerAddress, ',', '.'), 1)

Select distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]
Group by SoldAsVacant
order by 2 

Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]

Update [Nashville Housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end


WITH RowNumCTE AS(
select * ,
	ROW_NUMBER() over (
	Partition By ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by 
					UniqueID
					) row_num
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]
)
Delete
from RowNumCTE
where row_num > 1 

Alter table [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select * 
from [Portfolio Project Data Cleaning (Housing)].dbo.[Nashville Housing]




