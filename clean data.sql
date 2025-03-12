select * from [NashvilleHousing ]
--Định dạng lại date fomat

select SaleDateConverted, CONVERT(date, SaleDate)
from [NashvilleHousing ]


UPDATE [NashvilleHousing ]
set SaleDate = CONVERT(date, SaleDate)

ALTER TABLE [NashvilleHousing ]
add SaleDateConverted date


UPDATE [NashvilleHousing ]
set SaleDateConverted = CONVERT(date, SaleDate)

-- tìm giá trị null trong PropertyAddress
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [NashvilleHousing ] a 
join [NashvilleHousing ] b 
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL

UPDATE a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [NashvilleHousing ] a 
join [NashvilleHousing ] b 
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL

--Tách riêng address, city, state ở cột PropertyAddress
SELECT PropertyAddress
from [NashvilleHousing ]

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as City
from [NashvilleHousing ]

--Thêm cột Address
ALTER TABLE [NashvilleHousing ]
add Address NVARCHAR(200)

UPDATE [NashvilleHousing ]
set Address  = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

-- Thêm cột City
ALTER TABLE [NashvilleHousing ]
add City NVARCHAR(200)

UPDATE [NashvilleHousing ]
set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))


select *
from [NashvilleHousing ]


--Tách riêng address, city, state ở cột OwnerAddress

select OwnerAddress
from [NashvilleHousing ]

SELECT 
PARSENAME( REPLACE(OwnerAddress,',','.'),3) as NewOwnerAddress,
PARSENAME( REPLACE(OwnerAddress,',','.'),2) as OwnerCity,
PARSENAME( REPLACE(OwnerAddress,',','.'),1) as OwnerState
from [NashvilleHousing ]
--Thêm cột  OwnerAddress
ALTER TABLE [NashvilleHousing ]
add  NewOwnerAddress NVARCHAR(200)

UPDATE [NashvilleHousing ]
set  NewOwnerAddress  = PARSENAME( REPLACE(OwnerAddress,',','.'),3)

-- Thêm cột OwnerCity
ALTER TABLE [NashvilleHousing ]
add OwnerCity NVARCHAR(200)

UPDATE [NashvilleHousing ]
set OwnerCity = PARSENAME( REPLACE(OwnerAddress,',','.'),2)

-- Thêm cột OwnerState
ALTER TABLE [NashvilleHousing ]
add OwnerState NVARCHAR(200)

UPDATE [NashvilleHousing ]
set OwnerState = PARSENAME( REPLACE(OwnerAddress,',','.'),1)


select *
from [NashvilleHousing ]


--đưa cột SoldAsVacant về 1 fomat nhất định y or n hoặc yes or no
select distinct SoldAsVacant, count(*)
from [NashvilleHousing ]
group by SoldAsVacant


SELECT SoldAsVacant,
case
    when SoldAsVacant = 'Y' then 'YES'
    when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant end
from [NashvilleHousing ]


UPDATE [NashvilleHousing ]
set SoldAsVacant = case
    when SoldAsVacant = 'Y' then 'YES'
    when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant end


--Loại bỏ Duplicates

with tb1 as(
select *,
ROW_NUMBER() over(PARTITION by
    ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
    Order by UniqueID
) as Num
from [NashvilleHousing ]
)
select *
from tb1 
where Num > 1


--Xóa những cột không cần thiết
select *
from [NashvilleHousing ]


ALTER TABLE [NashvilleHousing ]
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE [NashvilleHousing ]
DROP COLUMN SaleDate