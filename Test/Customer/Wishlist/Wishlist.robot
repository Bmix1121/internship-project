*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/Resource/POM/Customer/Wishlist/wishlist.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/libraries/api/wishlistAPI.robot
Resource            ${EXECDIR}/libraries/api/productAPI.robot

Suite Setup         Run Keywords    DataBase.Delete Product via DB
...                     AND    common.OpenMarketplaceMicrosite    ${CUSTOMER}
...                     AND    common.Navigate To Wishlist
Suite Teardown      DataBase.Update ProfileImage
Test Teardown       Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Navigate To Wishlist


*** Test Cases ***
Have product in the wishlist
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณี มี ข้อมูลสินค้าที่ถูกใจ
    [Tags]    wishlist
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    wishlistAPI.Add&Delete product to wishlist via API
    ...    AND    Reload

    wishlist.Select Product

product has more than 0
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีมีจำนวนสินค้าในคลังมากกว่า 0
    [Tags]    wishlist
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    wishlistAPI.Add&Delete product to wishlist via API
    ...    AND    Reload

    wishlist.Select Product
    wishlist.Validation product has more than 0

No products in the wishlist
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณี ไม่มี ข้อมูลสินค้าที่ถูกใจ
    [Tags]    wishlist    and    reload
    [Setup]    DataBase.Delete product in wishlist via DB

    wishlist.Validation No products in the wishlist

Out of stock
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีสินค้าหมด
    [Tags]    wishlist
    [Setup]    Run Keywords    productAPI.Create Product via API    quantity=0    ImageList=glasses.jpg
    ...    AND    wishlistAPI.Add&Delete product to wishlist via API
    ...    AND    Reload

    wishlist.Select Product
    wishlist.Validation Product Out of Stock

product has been deleted
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีสินค้าถูกลบ
    ...    ปุ่ม Page Back
    [Tags]    wishlist
    [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=housemodel.jpg
    ...    AND    wishlistAPI.Add&Delete product to wishlist via API
    ...    AND    Reload

    wishlist.Select Product
    wishlist.Click Pageback
    DataBase.Delete Product via DB
    Reload
    wishlist.Validation : delete product
    wishlist.Click Pageback
