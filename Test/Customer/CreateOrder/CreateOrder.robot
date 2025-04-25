*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/POM/Customer/CreateOrder/createorder.resource
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/libraries/api/productAPI.robot
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Open MarketplaceMicrosite    ${CUSTOMER}
...                     AND    common.Navigate To Productlist
Suite Teardown      DataBase.Update ProfileImage
Test Teardown       Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Navigate To Productlist


*** Test Cases ***
Create Order
    [Documentation]
    ...    สร้างคำสั่งซื้อ สำเร็จ กรณีทำถูกต้องทุกเงื่อนไข
    ...    สร้างคำสั่งซื้อ สำเร็จ กรณีซื้อสินค้าอยู่ในช่วงจำนวนคงเหลือ
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=monitor.jpg,mouse.jpg

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    2
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    รับที่ตึก2
    createorder.Fill Note
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Cancel
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Validation : create order

No Select Payment
    [Documentation]
    ...    สร้างคำสั่งซื้อ ไม่สำเร็จ กรณีไม่เลือกวิธีการชำระเงิน
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=watch.jpg,mouse.jpg

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    0
    createorder.Click BuyNow
    createorder.Select Payment    ${EMPTY}
    createorder.Select Receive    นัดรับ
    createorder.Fill Note
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Required Check    payment

Point less than Price
    [Documentation]
    ...    ลูกค้าสร้างคำสั่งซื้อ ไม่สำเร็จ กรณีมี Point ไม่เพียงพอต่อการซื้อ
    [Setup]    Run Keywords
    ...    productAPI.Create Product via API    ImageList=B.jpg    price=1000
    ...    AND    DataBase.Set Points for Testing via SQL    500

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    0
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    นัดรับ
    createorder.Fill Note    point less than price
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Required Check    point

    [Teardown]    Run Keywords
    ...    DataBase.Delete Product via DB
    ...    AND    DataBase.Set Points for Testing via SQL    4000
    ...    AND    common.Navigate To Productlist

Point equal to Price
    [Documentation]
    ...    สร้างคำสั่งซื้อ สำเร็จ กรณีจำนวน Point เท่ากับ ราคาสินค้า
    [Tags]    order    customer
    [Setup]    Run Keywords
    ...    productAPI.Create Product via API    ImageList=C.jpg    price=500
    ...    AND    DataBase.Set Points for Testing via SQL    500

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    0
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    นัดรับ
    createorder.Fill Note    point equal to price
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Validation : create order

    [Teardown]    Run Keywords    DataBase.Delete Product via DB
    ...    AND    DataBase.Set Points for Testing via SQL    4000
    ...    AND    common.Navigate To Productlist

Point more than Price
    [Documentation]
    ...    สร้างคำสั่งซื้อ สำเร็จ กรณีจำนวน Point มากกว่า ราคาสินค้า
    [Tags]    order    customer
    [Setup]    Run Keywords
    ...    productAPI.Create Product via API    ImageList=mouse.jpg    price=20
    ...    AND    DataBase.Set Points for Testing via SQL    4000

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    2
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    นัดรับ
    createorder.Fill Note    point more than price
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Validation : create order

No Select Receive
    [Documentation]
    ...    สร้างคำสั่งซื้อ ไม่สำเร็จ กรณีไม่เลือกวิธีการรับสินค้า
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=hoodie.jpg

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    1
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    ${EMPTY}
    createorder.Fill Note
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Required Check    receive

No Fill Note
    [Documentation]
    ...    สร้างคำสั่งซื้อ สำเร็จ กรณีไม่กรอกหมายเหตุ
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=glasses.jpg

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    0
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    รับที่ตึก2
    createorder.Fill Note    ${EMPTY}
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Validation : create order

Buy All Product
    [Documentation]
    ...    สร้างคำสั่งซื้อ สำเร็จ กรณีซื้อสินค้าเท่ากับจำนวนคงเหลือ
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=housemodel.jpg

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity2
    createorder.Click BuyNow
    createorder.Select Payment    point
    createorder.Select Receive    นัดรับ
    createorder.Fill Note
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Validation : create order

Product Out of Stock
    [Documentation]
    ...    สร้างคำสั่งซื้อ ไม่สำเร็จ กรณีสินค้าหมด
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=cap.jpg    quantity=10    price=10

    createorder.Select Product
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    5
    createorder.Click BuyNow
    DataBase.Update Quantity via DB    0
    createorder.Select Payment    point
    createorder.Select Receive    นัดรับ
    createorder.Fill Note    ${EMPTY}
    createorder.Click OrderNow
    createorder.Click Confirm / Cancel Button    Confirm
    createorder.Validation : Out Of Stock

Validation
    [Documentation]
    ...    ทดสอบการทำงานปุ่ม PageBack , Close , เพิ่มและลดจำนวนสินค้า
    [Tags]    order    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=phone.jpg

    createorder.Select Product
    createorder.Click Buy
    createorder.Click Close Button
    createorder.Click Buy
    createorder.Choose Quantity    เพิ่ม    8
    createorder.Choose Quantity    ลด    4
    createorder.Click BuyNow
    createorder.Click PageBack Button
    createorder.Click PageBack Button
