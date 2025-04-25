*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/Resource/POM/Customer/MyPurchases/mypurchases.resource
Resource            ${EXECDIR}/libraries/api/orderAPI.robot
Resource            ${EXECDIR}/libraries/api/productAPI.robot    # robotcode: ignore
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    common.OpenMarketplaceMicrosite    ${CUSTOMER}
...                     AND    common.Navigate To CustomerProfile
...                     AND    Database.Delete Product via DB
Suite Teardown      DataBase.Update ProfileImage
Test Teardown       Run Keywords    Database.Delete Product via DB
...                     AND    DataBase.Delete all Order via DB use MC
...                     AND    Database.Clear Chat via DB use ID
...                     AND    common.Navigate To CustomerProfile


*** Test Cases ***
Have order,status: Waiting for delivery
    [Documentation]
    ...    ตรวจสอบการแสดงคำสั่งซื้อ กรณีมีข้อมูลคำสั่งซื้อสถานะ รอจัดส่ง
    [Tags]    pending    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=ring.jpg
    ...    AND    orderAPI.Create Order via API

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation order status
    mypurchases.Select Order
    mypurchases.Click Pageback

No order,status: Waiting for delivery
    [Documentation]
    ...    ตรวจสอบการแสดงคำสั่งซื้อ กรณีไม่มีข้อมูลคำสั่งซื้อสถานะ รอจัดส่ง
    [Tags]    pending    mypurchases    customer    and    reload
    [Setup]    DataBase.Delete all Order via DB use MC

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation no order
    mypurchases.Click Pageback

Contact seller in pending page
   [Documentation]
   ...    ตรวจสอบการทำงาน กรณีลูกค้าติดต่อผู้ขาย
   ...    ตรวจสอบการทำงาน กรณีลูกค้ากดส่งข้อความ
   ...    ตรวจสอบการทำงาน กรณีลูกค้ากดส่งรูปภาพ
   [Tags]    pending    mypurchases    customer
   [Setup]    Run Keywords    DataBase.Delete all Order via DB use MC
   ...    AND    productAPI.Create Product via API
   ...    AND    orderAPI.Create Order via API
   ...    AND    Database.Clear Chat via DB use ID

   mypurchases.Select menu : Waiting for delivery
   mypurchases.Click Contact Seller
   mypurchases.Send Message
   mypurchases.Upload Image    laptop.jpg
   mypurchases.Click Pageback
   mypurchases.Validation order status
   mypurchases.Select Order
   mypurchases.Click Contact Seller
   mypurchases.Send Message
   mypurchases.Upload Image    onion.jpg
   mypurchases.Click Pageback

Cancel Order
    [Documentation]
    ...    ตรวจสอบรายการคำสั่งซื้อ กรณีลูกค้ากดยกเลิกคำสั่งซื้อ
    [Tags]    pending    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=A.jpg
    ...    AND    orderAPI.Create Order via API

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation order status
    mypurchases.Select Order
    mypurchases.Click Cancel Order
    mypurchases.Validation : cancel order    Cancel    -
    mypurchases.Click Cancel Order
    mypurchases.Validation : cancel order    Confirm    ChangedMind
    mypurchases.Validation : if cancel order = pass
    mypurchases.Select Order

Click cancel order but order status is changed
    [Documentation]
    ...    ลูกค้ายกเลิกคำสั่งซื้อ ไม่สำเร็จ กรณีสถานะของคำสั่งซื้อมีการเปลี่ยนแปลง
    [Tags]    pending    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation order status
    mypurchases.Select Order
    orderAPI.Change Order Status to Canceled via API
    mypurchases.Click Cancel Order
    mypurchases.Validation : cancel order    Confirm    PaymentIssue
    mypurchases.Validation : if cancel order = fail

Cancel order : no select reason
    [Documentation]
    ...    ผู้ขายยกเลิกคำสั่งซื้อ ไม่สำเร็จ กรณีไม่เลือกเหตุผลในการยกเลิกสินค้า
    [Tags]    pending    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation order status
    mypurchases.Select Order
    orderAPI.Change Order Status to Canceled via API
    mypurchases.Click Cancel Order
    mypurchases.Click Confirm Button
    mypurchases.Required Check

Click Copy Order Number
    [Documentation]
    ...    ตรวจสอบการทำงาน ปุ่ม Copy
    [Tags]    pending    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation order status
    mypurchases.Select Order
    mypurchases.Validate Click Copy

Have order,status: Completed
    [Documentation]
    ...    ตรวจสอบการแสดงคำสั่งซื้อ กรณีมีคำสั่งซื้อสถานะ สำเร็จ
    [Tags]    completed    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=housemodel.jpg
    ...    AND    orderAPI.Create Order via API
    ...    AND    orderAPI.Change Order Status to completed via API

    mypurchases.Select menu : Completed
    mypurchases.Validation order status
    mypurchases.Select Order
    mypurchases.Click Pageback

No order,status: Completed
    [Documentation]
    ...    ตรวจสอบการแสดงคำสั่งซื้อ กรณีไม่มีข้อมูลคำสั่งซื้อสถานะ สำเร็จ
    [Tags]    completed    mypurchases    customer    and    reload
    [Setup]    DataBase.Delete all Order via DB use MC

    mypurchases.Select menu : Completed
    mypurchases.Validation no order
    mypurchases.Click Pageback

Contact seller in completed page
   [Documentation]
   ...    ตรวจสอบการทำงาน กรณีลูกค้าติดต่อผู้ขาย
   ...    ตรวจสอบการทำงาน กรณีลูกค้ากดส่งข้อความ
   ...    ตรวจสอบการทำงาน กรณีลูกค้ากดส่งรูปภาพ
   [Tags]    completed    mypurchases    customer
   [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=C.jpg
   ...    AND    orderAPI.Create Order via API
   ...    AND    orderAPI.Change Order Status to completed via API
   ...    AND    Database.Clear Chat via DB use ID

   mypurchases.Select menu : Completed
   mypurchases.Validation order status
   mypurchases.Select Order
   mypurchases.Click Contact Seller
   mypurchases.Send Message
   mypurchases.Upload Image    donut.jpg
   mypurchases.Click Pageback

Have order,status: Canceled
    [Documentation]
    ...    ตรวจสอบการแสดงคำสั่งซื้อ กรณีมีคำสั่งซื้อสถานะ สำเร็จ
    [Tags]    canceled    mypurchases    customer
    [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=glasses.jpg
    ...    AND    orderAPI.Create Order via API
    ...    AND    orderAPI.Change Order Status to Canceled via API

    mypurchases.Select menu : Canceled
    mypurchases.Validation order status
    mypurchases.Select Order
    mypurchases.Click Pageback

No order,status: Canceled
    [Documentation]
    ...    ตรวจสอบการแสดงคำสั่งซื้อ กรณีไม่มีข้อมูลคำสั่งซื้อสถานะ สำเร็จ
    [Tags]    canceled    mypurchases    customer    and    reload
    [Setup]    Run Keyword    DataBase.Delete all Order via DB use MC

    mypurchases.Select menu : Canceled
    mypurchases.Validation no order
    mypurchases.Click Pageback

Contact seller in Canceled page
   [Documentation]
   ...    ตรวจสอบการทำงาน กรณีลูกค้าติดต่อผู้ขาย
   ...    ตรวจสอบการทำงาน กรณีลูกค้ากดส่งข้อความ
   ...    ตรวจสอบการทำงาน กรณีลูกค้ากดส่งรูปภาพ
   [Tags]    canceled    mypurchases    customer
   [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=handgun.jpg
   ...    AND    orderAPI.Create Order via API
   ...    AND    orderAPI.Change Order Status to Canceled via API
   ...    AND    Database.Clear Chat via DB use ID

   mypurchases.Select menu : Canceled
   mypurchases.Validation order status
   mypurchases.Select Order
   mypurchases.Click Contact Seller
   mypurchases.Send Message
   mypurchases.Upload Image    cake.jpg    donut.jpg
   mypurchases.Click Pageback

Validation : number of orders
    [Documentation]
    ...    ตรวจสอบการแสดงจำนวนคำสั่งซื้อ สถานะรอจัดส่ง
    ...    ตรวจสอบการแสดงจำนวนคำสั่งซื้อ สถานะสำเร็จ
    ...    ตรวจสอบการแสดงจำนวนคำสั่งซื้อ สถานะยกเลิก
    [Tags]    mypurchases    customer
    [Setup]    Run Keywords    orderAPI.Add orders via API    pending    2
    ...    AND    orderAPI.Add orders via API    completed    1
    ...    AND    orderAPI.Add orders via API    canceled    2
    ...    AND    DataBase.Update all Product via DB use MC    0

    mypurchases.Select menu : Waiting for delivery
    mypurchases.Validation Number of orders    1

    mypurchases.Select menu : Completed
    mypurchases.Validation Number of orders    2

    mypurchases.Select menu : Canceled
    mypurchases.Validation Number of orders    3
