/*
First look at the data

#use - to select DB
*/
use SQL_first_Practice
select *
from nashvilleHousing

-----------------------------------------------------------------------
/*
*Standardize data format*

#alter table - is used to add, delete or modify columns in an existing table
#update - is used to modify the existing records in a table
*/
alter table nashvilleHousing
add SaleDateConverted date

update nashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

select SaleDateConverted
from nashvilleHousing

--Delete saledate--

-----------------------------------------------------------------------
/*
Populate property address data
*/

select * 
from nashvilleHousing
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashvilleHousing a
join nashvilleHousing b on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashvilleHousing a
join nashvilleHousing b on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


-----------------------------------------------------------------------
/*
Breaking out address to Individual columns (State,City,address)

#substring - split(colunm name, side of split,by which index num)
*/
select PropertyAddress
from nashvilleHousing

select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from nashvilleHousing

alter table nashvilleHousing
add Property_split_Address Nvarchar

/*
SET ANSI_WARNINGS OFF;
alter table nashvilleHousing
drop column Property_split_Address
*/

update nashvilleHousing
set Property_split_Address = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress))

alter table nashvilleHousing
add Property_split_City Nvarchar

update nashvilleHousing
set Property_split_City = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

-----------------------------------------------------------------------
/*
Breaking out OwnerName to Individual columns (another way to split)

#PARSENAME(replace(OwnerAddress,',','.'),1) - split 
*/

select OwnerAddress
from nashvilleHousing

select PARSENAME(replace(OwnerAddress,',','.'),1) as country , 
PARSENAME(replace(OwnerAddress,',','.'),2) as city , 
PARSENAME(replace(OwnerAddress,',','.'),3) as street
from nashvilleHousing


alter table nashvilleHousing
add OwnerAddress_country nvarchar(255);
update nashvilleHousing
set OwnerAddress_country = PARSENAME(replace(OwnerAddress,',','.'),1)

alter table nashvilleHousing
add OwnerAddress_city nvarchar(255);
update nashvilleHousing
set OwnerAddress_city = PARSENAME(replace(OwnerAddress,',','.'),2)

alter table nashvilleHousing
add OwnerAddress_street nvarchar(255);
update nashvilleHousing
set OwnerAddress_street = PARSENAME(replace(OwnerAddress,',','.'),3)

-----------------------------------------------------------------------
/*
Change Y and N to Yes and No in "Sold as Vacant" field

# group by - group rows that have the same values into summary rows
# order by - sort the result-set in ascending or descending (number its by which column to sort)
*/

select distinct(SoldAsVacant), count(SoldAsVacant)
from nashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant, case when SoldAsVacant = 'N' then 'No' 
						  WHEN SoldAsVacant = 'Y' then 'Yes'
						  else SoldAsVacant
						  end
from nashvilleHousing

update nashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No' 
						  WHEN SoldAsVacant = 'Y' then 'Yes'
						  else SoldAsVacant
						  end
-----------------------------------------------------------------------
/*
Remove Duplicates

# Order by -  ORDER BY keyword is used to sort the result-set in ascending or descending order.
# with *table_name* AS - to create a new table 
# ROW_NUMBER() over(partition by...) - to identify same rows and index them
# delete - to delete rows
# drop column - to delete column
*/

with RowNumCTE AS (
select * , ROW_NUMBER() over(partition by ParcelID,PropertyAddress, SalePrice,SaleDate,LegalReference order by UniqueID ) as row_num
from nashvilleHousing)

delete 
from RowNumCTE
where row_num > 1



-----------------------------------------------------------------------
/*
Delete unused columns
# drop column - to delete column
*/

select *
from nashvilleHousing

alter table nashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate



-----------------------------------------------------------------------















