*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/libraries/api/productAPI.robot
Resource            ${EXECDIR}/libraries/api/orderAPI.robot
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/Resource/POM/Seller/OrderStatus/orderstatus.resource

Suite Setup         Run Keywords    Database.Delete Product via DB
...                     AND    common.Open MarketplaceMicrosite    ${SELLER}
...                     AND    common.Navigate To Seller
Suite Teardown      DataBase.Update ProfileImage
Test Teardown       Run Keywords    Database.Delete Product via DB
...                     AND    Database.Delete all Order via DB use MC
...                     AND    common.Navigate To Seller


*** Test Cases ***
Have order : status waiting for delivery
    [Documentation]
    ...    ตรวจสอบการแสดงรายการคำสั่งซื้อ กรณีมีคำสั่งซื้อที่ต้องจัดส่ง
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    orderstatus.CLick To Ship menu
    orderstatus.Select Order

No order : status waiting for delivery
    [Documentation]
    ...    ตรวจสอบการแสดงรายการคำสั่งซื้อ กรณีไม่มีข้อมูลคำสั่งซื้อที่ต้องจัดส่ง
    [Tags]    orderstatus    seller
    [Setup]    Database.Delete all Order via DB use MC

    orderstatus.CLick To Ship menu
    orderstatus.Validation : No Order

Click delivery button
    [Documentation]
    ...    ตรวจสอบการทำงาน กรณีกดจัดส่งสำเร็จ
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    Database.Delete all Order via DB use MC
    ...    AND    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    orderstatus.CLick To Ship menu
    orderstatus.CLick Delivery
    orderstatus.Validation : Delivery    Cancel
    orderstatus.CLick Delivery
    orderstatus.Validation : Delivery    Confirm
    orderstatus.Validation : if delivery = pass

Click delivery button but order status is changed
    [Documentation]
    ...    ตรวจสอบการกด จัดส่งสำเร็จ กรณีคำสั่งซื้อถูกยกเลิกไปแล้ว
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    Database.Delete all Order via DB use MC
    ...    AND    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    orderstatus.CLick To Ship menu
    orderAPI.Change Order Status to Canceled via API
    orderstatus.CLick Delivery
    orderstatus.Validation : Delivery    Confirm
    orderstatus.Validation : if delivery = fail

Click cancel order
    [Documentation]
    ...    ตรวจสอบรายการคำสั่งซื้อ กรณีผู้ขายกดยกเลิกคำสั่งซื้อ
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    orderstatus.CLick To Ship menu
    orderstatus.Select Order
    orderstatus.Click Cancel Order
    orderstatus.Validation : cancel order    Cancel    -
    orderstatus.Click Cancel Order
    orderstatus.Validation : cancel order    Confirm    OutofStock
    orderstatus.Validation : if cancel order = pass

Click cancel order but order status is changed
    [Documentation]
    ...    ผู้ขายยกเลิกคำสั่งซื้อ ไม่สำเร็จ กรณีสถานะของคำสั่งซื้อมีการเปลี่ยนแปลง
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    orderstatus.CLick To Ship menu
    orderstatus.Select Order
    orderAPI.Change Order Status to Canceled via API
    orderstatus.Click Cancel Order
    orderstatus.Validation : cancel order    Confirm    UnabletoContactCustomer
    orderstatus.Validation : if cancel order = fail

Cancel order : no select reason
    [Documentation]
    ...    ผู้ขายยกเลิกคำสั่งซื้อ ไม่สำเร็จ กรณีไม่เลือกเหตุผลในการยกเลิกสินค้า
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API

    orderstatus.CLick To Ship menu
    orderstatus.Select Order
    orderAPI.Change Order Status to Canceled via API
    orderstatus.Click Cancel Order
    orderstatus.Click Confirm Button
    orderstatus.Required Check

Have order : status completed
    [Documentation]
    ...    ตรวจสอบการแสดงรายการคำสั่งซื้อที่มีสถานะสำเร็จ
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API
    ...    AND    orderAPI.Change Order Status to completed via API

    orderstatus.Click history
    orderstatus.Select Order

No order : status completed
    [Documentation]
    ...    ตรวจสอบการแสดงรายการคำสั่งซื้อ กรณีไม่มีข้อมูลคำสั่งซื้อที่มีสถานะสำเร็จ
    [Tags]    orderstatus    seller
    [Setup]    Database.Delete all Order via DB use MC

    orderstatus.CLick To Ship menu
    orderstatus.Validation : No Order

Have order : status canceled
    [Documentation]
    ...    ตรวจสอบการแสดงรายการคำสั่งซื้อที่ถูกยกเลิก
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    productAPI.Create Product via API
    ...    AND    orderAPI.Create Order via API
    ...    AND    orderAPI.Change Order Status to Canceled via API

    orderstatus.Click canceled menu
    orderstatus.Select Order

No order : status canceled
    [Documentation]
    ...    ตรวจสอบการแสดงรายการคำสั่งซื้อ กรณีไม่มีคำสั่งซื้อที่ถูกยกเลิก
    [Tags]    orderstatus    seller
    [Setup]    Database.Delete all Order via DB use MC

    orderstatus.Click canceled menu
    orderstatus.Validation : No Order

Validation : number of orders
    [Documentation]
    ...    ตรวจสอบการแสดงจำนวนคำสั่งซื้อสถานะ ที่ต้องจัดส่ง
    ...    ตรวจสอบการแสดงจำนวนคำสั่งซื้อสถานะ สำเร็จ
    ...    ตรวจสอบการแสดงจำนวนคำสั่งซื้อสถานะ ยกเลิก
    ...    ปุ่ม Page Back
    [Tags]    orderstatus    seller
    [Setup]    Run Keywords    orderAPI.Add orders via API    pending    2
    ...    AND    orderAPI.Add orders via API    completed    1
    ...    AND    orderAPI.Add orders via API    canceled    2
    ...    AND    Reload

    orderstatus.Validation : number of order and order status    ที่ต้องจัดส่ง
    orderstatus.Click page back
    orderstatus.Validation : number of order and order status    สำเร็จ
    orderstatus.Click page back
    orderstatus.Validation : number of order and order status    ยกเลิก
    orderstatus.Click page back
