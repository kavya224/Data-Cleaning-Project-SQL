select * from nashvillehousing

---Standardazie date format

	alter table nashvillehousing
	alter column saledate date

---Populate property  address data
	update a
	set a.propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
	from nashvillehousing a inner join nashvillehousing b
	on a.parcelid=b.parcelid
	where  a.propertyaddress is null and a.uniqueid<> b.uniqueid


---Breaking out address into individual columns (address,city,state)


	select SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) from nashvillehousing
	select SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)-CHARINDEX(',',propertyaddress) )from nashvillehousing
	select SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress) )from nashvillehousing

	alter table nashvillehousing
	add  property_split_address nvarchar(255)
    update nashvillehousing
	set property_split_address= SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 

	alter table nashvillehousing
	add  property_split_city nvarchar(255)
    update nashvillehousing
	set property_split_city= SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress) ) 


	select OwnerAddress from nashvillehousing
	alter table nashvillehousing
	add owner_split_address nvarchar(255),
	owner_split_city nvarchar(255),
	owner_split_state nvarchar(255)

	update nashvillehousing
	set owner_split_address=PARSENAME(REplace(OwnerAddress,',','.'),3),
	owner_split_city=PARSENAME(REplace(OwnerAddress,',','.'),2),
	owner_split_state=PARSENAME(REplace(OwnerAddress,',','.'),1)


--- Changing Y and N to Yes and No in SolidAsVacant field

   update nashvillehousing
   set SoldAsVacant = case when SoldAsVacant='N' then 'No'
                           when SoldAsVacant='Y' then 'Yes'
						   else SoldAsVacant
						   end

--- Remove Duplicates

	WITH RowNumCTE AS(
	Select *,ROW_NUMBER() OVER (PARTITION BY 
	       ParcelID,
		   PropertyAddress,
		   SalePrice,
		   SaleDate,
		   LegalReference
		   ORDER BY
		   UniqueID
		   ) row_num

	From NashvilleHousing)
	Select *
	From RowNumCTE
	Where row_num > 1
	Order by PropertyAddress



	Select *
	From NashvilleHousing



--- Delete Unused Columns


	ALTER TABLE PortfolioProject.dbo.NashvilleHousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate