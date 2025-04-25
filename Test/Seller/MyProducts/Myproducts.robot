*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/libraries/api/productAPI.robot
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/Resource/POM/Seller/MyProduct/myproduct.resource

Suite Setup         Run Keywords    Database.Delete Product via DB
...                     AND    DataBase.Update all Product via DB use MC    1
...                     AND    common.Open MarketplaceMicrosite    ${SELLER}
...                     AND    common.Navigate To Seller
Suite Teardown      Run Keywords    DataBase.Update all Product via DB use MC    0
...                     AND    DataBase.Update ProfileImage
Test Teardown       Run Keywords    Database.Delete Product via DB
...                     AND    common.Navigate To Seller


*** Test Cases ***
Have product in my product
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีผู้ขายเพิ่มสินค้าสำเร็จ    :
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีมีคลังสินค้ามากกว่า 0
    [Tags]    myproducts    seller
    [Setup]    productAPI.Create Product via API

    myproduct.Click My Product
    myproduct.Validation : product

No product in my product
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีไม่มีข้อมูลสินค้า
    [Tags]    myproducts    seller

    myproduct.Click My Product
    myproduct.Validation : no product

Product has been delete in my product
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีรายการสินค้าถูกลบ
    [Tags]    myproducts    seller
    [Setup]    productAPI.Create Product via API

    myproduct.Click My Product
    myproduct.Validation : product
    myproduct.Click Pageback
    Database.Delete Product via DB
    Reload
    myproduct.Validation : no product

Have product in out of stock page
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้าหมด กรณีจำนวนสินค้าคงเหลือเท่ากับ 0
    [Tags]    myproducts    seller    outofstock
    [Setup]    productAPI.Create Product via API    quantity=0

    myproduct.Click My Product
    myproduct.Click Out of Stock Menu
    myproduct.Validation : product

No product in out of stock page
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้าหมด กรณีไม่มีข้อมูลสินค้าที่หมด stock
    [Tags]    myproducts    seller    outofstock

    myproduct.Click My Product
    myproduct.Click Out of Stock Menu
    myproduct.Validation : no product

Product has been delete in out of stock page
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้าหมด กรณีรายการสินค้าถูกลบ
    [Tags]    myproducts    seller    outofstock
    [Setup]    productAPI.Create Product via API    quantity=0

    myproduct.Click My Product
    myproduct.Click Out of Stock Menu
    myproduct.Validation : product
    myproduct.Click Pageback
    Database.Delete Product via DB
    Reload
    myproduct.Validation : no product

Have product in draft page
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีมีสินค้าแบบ Draft
    [Tags]    myproducts    seller    draft
    [Setup]    productAPI.Create Product via API    isEnable=${False}

    myproduct.Click My Product
    myproduct.Click Not Show Menu
    myproduct.Validation : product

No product in draft page
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า เมื่อไม่มีข้อมูลสินค้าแบบ Draft
    [Tags]    myproducts    seller    draft

    myproduct.Click My Product
    myproduct.Click Not Show Menu
    myproduct.Validation : no product

Product has been delete in draft page
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีรายการสินค้าถูกลบ
    [Tags]    myproducts    seller    draft
    [Setup]    productAPI.Create Product via API    isEnable=${False}

    myproduct.Click My Product
    myproduct.Click Not Show Menu
    myproduct.Validation : product
    myproduct.Click Pageback
    Database.Delete Product via DB
    Reload
    myproduct.Validation : no product

Validation
    [Documentation]
    ...    ปุ่ม Page Back
    ...    ปุ่ม Add New Product
    [Tags]    myproducts    seller

    myproduct.Click My Product
    myproduct.Click Pageback
    myproduct.Click My Product
    myproduct.Click Add new product
