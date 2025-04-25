*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/libraries/api/productAPI.robot
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/Resource/POM/Customer/Product/productdetail.resource

Suite Setup         Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Open MarketplaceMicrosite    ${CUSTOMER}
...                     AND    common.Navigate To Productlist
Suite Teardown      DataBase.Update ProfileImage
Test Teardown       Run Keywords    DataBase.Delete Product via DB
...                     AND    common.Navigate To Productlist
...                     AND    Database.Clear Chat via DB use ID


*** Test Cases ***
Buy Product
    [Documentation]
    ...    ตรวจสอบการซื้อสินค้า
    ...    ตรวจสอบการทำงาน กรณีดูรูปภาพสินค้า
    [Tags]    productdetail    customer
    [Setup]    Run Keyword    productAPI.Create Product via API
    # ...    AND    Reload

    productdetail.Select Product
    productdetail.View Image    right    3
    productdetail.View Image    left    2
    productdetail.Click Buy

Out of Stock
    [Documentation]
    ...    ตรวจสอบการซื้อสินค้า กรณีสินค้าหมด
    [Tags]    productdetail    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=ring.jpg    quantity=0
    # ...    AND    Reload

    productdetail.Select Product
    productdetail.Click Buy
    productdetail.Validation Product is Out of Stock

Contact Seller
   [Documentation]
   ...    กดติดต่อผู้ขาย    :
   ...    ส่งข้อความ    :
   ...    ส่งรูปภาพ    :
   ...    กดปุ่มPageBack
   [Tags]    productdetail    customer
   [Setup]    Run Keywords    productAPI.Create Product via API    ImageList=mouse.jpg
   ...    AND    Database.Clear Chat via DB use ID
   # ...    AND    Reload

   productdetail.Select Product
   productdetail.Click Contact
   productdetail.Send Message
   productdetail.Upload Image    Cap.jpg    sneakers.jpg    hoodie.jpg    glasses.jpg
   productdetail.Click PageBack
   productdetail.Click PageBack

Add&Remove product to Wishlist
    [Documentation]
    ...    กดเพิ่มรายการสินค้าไปยังรายการโปรดและนำสินค้าออกจากรายการโปรด
    [Tags]    productdetail    wishlist    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=glasses.jpg
    # ...    AND    Reload

    productdetail.Select Product
    productdetail.Click Wishlist
    common.Navigate To Wishlist
    productdetail.Validation : product
    productdetail.Click Wishlist
    productdetail.Click PageBack

View all products of the seller
    [Documentation]
    ...    ตรวจสอบการทำงาน กรณีกดดูสินค้าทั้งหมดของผู้ขาย
    [Tags]    productdetail    customer
    [Setup]    Run Keyword    productAPI.Create Product via API    ImageList=monitor.jpg
    # ...    AND    Reload

    productdetail.Select Product
    productdetail.Click View all products
    productdetail.Validation : product
