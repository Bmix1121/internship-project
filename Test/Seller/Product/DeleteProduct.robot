*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/POM/Seller/Product/deleteproduct.resource
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/libraries/api/productAPI.robot
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    Database.Delete product via DB
...                     AND    DataBase.Update all Product via DB use MC    1
...                     AND    common.Open MarketplaceMicrosite    ${SELLER}
...                     AND    common.Navigate To MyProduct
Suite Teardown      Run Keywords    DataBase.Update all Product via DB use MC    0
...                     AND    DataBase.Update ProfileImage
Test Setup          common.Navigate To MyProduct
# Test Teardown    Run Keyword    common.Navigate To MyProduct


*** Test Cases ***
Delete product in products page
    [Documentation]
    ...    ตรวจสอบการลบสินค้า กรณีผู้ขายกดลบรายการสินค้า ในหน้ารายการสินค้า
    [Tags]    deleteproduct    seller
    [Setup]    productAPI.Create Product via API

    deleteproduct.Click Products menu
    deleteproduct.Click Ellipsis
    deleteproduct.Click Delete Button
    deleteproduct.Validation : Delete product    Confirm
    deleteproduct.Validation : No Product

Delete product in out of stock page
    [Documentation]
    ...    ตรวจสอบการลบสินค้า กรณีผู้ขายกดลบรายการสินค้า ในหน้าสินค้าหมด
    [Tags]    deleteproduct    seller
    [Setup]    productAPI.Create Product via API    quantity=0

    deleteproduct.Click Out of Stock menu
    deleteproduct.Click Ellipsis
    deleteproduct.Click Delete Button
    deleteproduct.Validation : Delete product    Confirm
    deleteproduct.Validation : No Product

Delete product in not show page
    [Documentation]
    ...    ตรวจสอบการลบสินค้า กรณีผู้ขายกดลบรายการสินค้า ในหน้าไม่แสดง
    [Tags]    deleteproduct    seller
    [Setup]    productAPI.Create Product via API    isEnable=${False}

    deleteproduct.Click Draft menu
    deleteproduct.Click Ellipsis
    deleteproduct.Click Delete Button
    deleteproduct.Validation : Delete product    Confirm
    deleteproduct.Validation : No Product

Validation
    [Documentation]
    ...    CancelBtn
    [Tags]    deleteproduct    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    productAPI.Create Product via API    quantity=0
    ...    AND    productAPI.Create Product via API    isEnable=${False}

    deleteproduct.Click Products menu
    deleteproduct.Click Ellipsis
    deleteproduct.Click Delete Button
    deleteproduct.Validation : Delete product    Cancel
    deleteproduct.Validation : Product
    deleteproduct.Click Pageback
    deleteproduct.Click Out of Stock menu
    deleteproduct.Click Ellipsis
    deleteproduct.Click Delete Button
    deleteproduct.Validation : Delete product    Cancel
    deleteproduct.Validation : Product
    deleteproduct.Click Pageback
    deleteproduct.Click Draft menu
    deleteproduct.Click Ellipsis
    deleteproduct.Click Delete Button
    deleteproduct.Validation : Delete product    Cancel
    deleteproduct.Validation : Product
