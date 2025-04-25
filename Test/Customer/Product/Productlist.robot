*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/libraries/api/productAPI.robot
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/Resource/POM/Customer/Product/productlist.resource
Resource            ${EXECDIR}/libraries/api/orderAPI.robot

Suite Setup         Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Open MarketplaceMicrosite    ${CUSTOMER}
...                     AND    common.Navigate To Productlist
Suite Teardown      DataBase.Update ProfileImage
Test Teardown       Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Navigate To Productlist


*** Test Cases ***
Productlist
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า
    [Tags]    productlist    customer
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    productAPI.Create Product via API    name=RobotDraftTest    isEnable=${False}

    productlist.Select Product
    productlist.Click Pageback
    productlist.Validation : draft product

Product out of stock
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า กรณีสินค้าหมด
    [Tags]    productlist    customer
    [Setup]    productAPI.Create Product via API    quantity=0

    productlist.Validation : Product out of stock

Search : product name
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า เมื่อผู้ใช้งานค้นหาสินค้า    :
    ...    ตรวจสอบการค้นหาสินค้า กรณีไม่ระบุเงื่อนไขการค้นหา    :
    ...    ตรวจสอบการค้นหาสินค้า กรณีระบุ "ชื่อสินค้า" ที่ถูกต้อง    :
    ...    ตรวจสอบการค้นหาสินค้า กรณีระบุ "ชื่อสินค้า" ที่ใกล้เคียง
    [Tags]    productlist    customer    search
    [Setup]    productAPI.Create Product via API

    productlist.Fill Search    RobotTest
    productlist.Select Product
    productlist.Click Pageback
    productlist.Fill Search    ${EMPTY}
    Reload
    productlist.Fill Search    o
    productlist.Select Product

Search : price
    [Documentation]
    ...    ตรวจสอบการค้นหาสินค้า กรณีระบุ "ราคา" ที่ถูกต้อง
    ...    ตรวจสอบการค้นหาสินค้า กรณีระบุ "ราคา" ที่ใกล้เคียง
    [Tags]    productlist    customer    search
    [Setup]    productAPI.Create Product via API    price=25

    productlist.Fill Search    25
    productlist.Select Product
    productlist.Click Pageback
    productlist.Fill Search    2
    productlist.Select Product

Search
    [Documentation]
    ...    ตรวจสอบการค้นหาสินค้า กรณีไม่มีสินค้า
    ...    ตรวจสอบการค้นหาสินค้า กรณีสินค้าหมด
    [Tags]    productlist    customer    search
    [Setup]    productAPI.Create Product via API    quantity=0

    productlist.Fill Search    ZZZ
    productlist.Validation : no product
    productlist.Fill Search    RobotTest
    productlist.Validation : Product out of stock

Recommend
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า แนะนำ
    [Tags]    productlist    customer    recommend
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    productAPI.Create Product via API    name=RobotDraftTest    isEnable=${False}

    productlist.Click Recommend
    productlist.Select Product in recommend
    productlist.Click Pageback
    productlist.Click Recommend
    productlist.Validation : draft product

Last Upload
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า ล่าสุด
    [Tags]    productlist    customer    lastupload
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    productAPI.Create Product via API    name=RobotDraftTest    isEnable=${False}

    productlist.Click Last Upload
    productlist.Select Product
    productlist.Click Pageback
    productlist.Click Last Upload
    productlist.Validation : draft product

Best selling
    [Documentation]
    ...    ตรวจสอบการแสดงรายการสินค้า ขายดี
    [Tags]    productlist    customer    bestselling
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    productlist.Click Best selling
    productlist.Select Product
    productlist.Click Pageback
    productAPI.Create Product via API    name=RobotDraftTest    isEnable=${False}
    orderAPI.Create Order via API
    productlist.Click Best selling
    productlist.Validation : draft product

No Product in best selling
    [Documentation]
    ...    ตรวจสอบการแสดงสินค้ากรณีไม่มีสินค้าขายดี
    [Tags]    productlist    customer    bestselling
    [Setup]    DataBase.Update all Order via DB    1

    productlist.Click Best selling
    productlist.Validation : no product

    [Teardown]    DataBase.Update all Order via DB    0

Search Test
    [Documentation]
    ...    ทดสอบการค้นหาสินค้าในหัวข้อ ทั้งหมด สินค้าแนะนำ ล่าสุด ขายดี
    [Tags]    productlist    customer    search
    [Setup]    Run Keywords    productAPI.Create Product via API    price=35
    ...    AND    orderAPI.Create Order via API
    ...    AND    Reload

    productlist.Fill Search    5
    productlist.Select Product
    productlist.Click Pageback
    productlist.Fill Search    3
    productlist.Click Recommend
    productlist.Select Product in recommend
    productlist.Click Pageback
    productlist.Fill Search    5
    productlist.Click Last Upload
    productlist.Select Product
    productlist.Click Pageback
    productlist.Fill Search    3
    productlist.Click Best selling
    productlist.Select Product
