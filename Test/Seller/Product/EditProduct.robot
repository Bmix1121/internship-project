*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/resource/POM/Seller/Product/editproduct.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/libraries/api/productAPI.robot

Suite Setup         Run Keywords    Database.Delete product via DB
...                     AND    DataBase.Update all Product via DB use MC    1
...                     AND    common.Open MarketplaceMicrosite    ${SELLER}
...                     AND    common.Navigate To MyProduct
Suite Teardown      Run Keywords    DataBase.Update all Product via DB use MC    0
...                     AND    DataBase.Update ProfileImage
Test Setup          Run Keywords    productAPI.Create Product via API    description=Edit Test
...                     AND    common.Navigate To MyProduct
Test Teardown       Run Keywords    Database.Delete Product via DB
...                     AND    common.Navigate To MyProduct


*** Test Cases ***
Edit product
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกรอกข้อมูลถูกต้องทุกเงื่อนไข
    ...    ตรวจสอบการลบรูปภาพ
    ...    ตรวจสอบการพรีวิวรูปภาพ
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.View image
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Cancel
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

No fill product name
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีไม่กรอก ชื่อสินค้า
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name    ${EMPTY}
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Required check    กรุณากรอกชื่อสินค้า

Image type test
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .jpeg
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .jpg
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .png
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .gif
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload Image    TESTjpeg.jpeg    TESTjpg.jpg    TESTpng.png    TESTgif.gif
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Image file size test
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์ไม่เกิน 10MB
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์ 10 MB
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์เกิน 10 MB
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload Image    onion.jpg    10MB.png    11MB.png
    editproduct.Validation : upload image    อัปโหลดไฟล์ได้ไม่เกิน 10 MB
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Not image file upload
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ ไม่ถูกต้องตามเงื่อนไข
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    Note-1.txt
    editproduct.Validation : upload image    กรุณาอัปโหลดไฟล์ที่เป็นรูปภาพเท่านั้น

Delete all image
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีลบรูปภาพทั้งหมด
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Delete image
    editproduct.Validation : Delete Image

Upload 1 image
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีลบ รูปภาพ จนเหลือเพียง 1 รูป
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Upload 5 image
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ 5 รูป
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload image test    5
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Upload 6 image
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ 6 รูป
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload image test    6
    editproduct.Validation : upload image    อัปโหลดรูปภาพได้ไม่เกิน 5 รูป

No fill price
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีไม่กรอก ราคาสินค้า
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price    ${EMPTY}
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Required check    กรุณากรอกราคาสินค้า

Fill pice test
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า น้อยกว่า 0 บาท
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า    0 บาท
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกรอก ราคาสินค้า    มากกว่า 0 บาท
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า เป็นตัวหนังสือ
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price    -1
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    editproduct.Fill Price    0
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    editproduct.Fill Price    TEST
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    editproduct.Fill Price    1
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

No fill product detail
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีไม่กรอก รายละเอียดสินค้า
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail    ${EMPTY}
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

No fill Quantity
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีไม่กรอก จำนวนคลังสินค้า
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity    ${EMPTY}
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Required check    กรุณากรอกจำนวนสินค้า

Fill quantity test
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า น้อยกว่า 0 ชิ้น
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า    0 ชิ้น
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกรอก จำนวนคลังสินค้า    มากกว่า 0 ชิ้น
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า เป็นตัวหนังสือ
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity    -1
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    editproduct.Fill Quantity    0
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    editproduct.Fill Quantity    TEST
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    editproduct.Fill Quantity    1
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Change condition
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกดเปลี่ยน Condition
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Edit product and preOrder is false
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = FALSE
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period    ${False}
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Edit product and preOrder is true
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = TRUE
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

No fill period
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = TRUE แต่ไม่กรอก "ระยะเวลา"
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.No fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Required check    กรุณากรอกระยะเวลา

Fill period test
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา น้อยกว่า 0
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา เท่ากับ 0
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกรอก ระยะเวลา มากกว่า 0
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา เป็นตัวหนังสือ
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill period test    -1
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    editproduct.Fill period test    0
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    editproduct.Fill period test    TEST
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    editproduct.Fill period test    1
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Change delivery
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกดเปลี่ยน รายละเอียดการส่งสินค้า
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product

Edit product in out of stock page : Fill quantity
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีเพิ่มจำนวนคลังสินค้า ของสินค้าในหน้ารายการสินค้าหมด
    [Tags]    editproduct    seller
    [Setup]    productAPI.Create Product via API    description=Edit Test    quantity=0

    editproduct.Click Out of Stock menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Quantity
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product    RobotTest
    editproduct.Click pageback
    editproduct.Click Out of Stock menu
    editproduct.Validation : No Product

    [Teardown]    Run Keywords    Database.Delete Product via DB
    ...    AND    common.Navigate To MyProduct

Edit product in out of stock page : No fill quantity
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า ไม่สำเร็จ กรณีไม่กรอกจำนวนคลังสินค้า ของสินค้าในหน้ารายการสินค้าหมด
    [Tags]    editproduct    seller
    [Setup]    productAPI.Create Product via API    description=Edit Test    quantity=0

    editproduct.Click Out of Stock menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Fill Quantity    ${EMPTY}
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Fail
    editproduct.Required check    กรุณากรอกจำนวนสินค้า

    [Teardown]    Run Keywords    Database.Delete Product via DB
    ...    AND    common.Navigate To MyProduct

Change status : Not show to Show
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีเปลี่ยนสินค้าจากสถานะ ไม่แสดง เป็นสถานะ เผยแพร่
    [Tags]    editproduct    seller
    [Setup]    productAPI.Create Product via API    description=Edit Test    isEnable=${False}

    editproduct.Click Draft menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.CLick Update Button
    editproduct.Validation : Edit Product    Confirm
    editproduct.Validation : Product    RobotTest

    [Teardown]    Run Keywords    Database.Delete Product via DB
    ...    AND    common.Navigate To MyProduct

Change status : Show to Not show
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีเปลี่ยนสินค้าจากสถานะ เผยแพร่ เป็นสถานะ ไม่แสดง
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.CLick Draft Button
    editproduct.Validation : Draft Product    Confirm
    editproduct.Validation : Product    RobotTest

Edit product in Not Show
    [Documentation]
    ...    ผู้ขายแก้ไขสินค้า สำเร็จ กรณีกรอกข้อมูลถูกต้องทุกเงื่อนไขของสินค้าที่มีสถานะ ไม่แสดง
    [Tags]    editproduct    seller
    [Setup]    productAPI.Create Product via API    description=Edit Test    isEnable=${False}

    editproduct.Click Draft menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.CLick Draft Button
    editproduct.Validation : Draft Product    Confirm
    editproduct.Validation : Product

    [Teardown]    Run Keywords    Database.Delete Product via DB
    ...    AND    common.Navigate To MyProduct

Validation
    [Documentation]
    ...    ปุ่ม Page Back
    [Tags]    editproduct    seller

    editproduct.Click Products menu
    editproduct.CLick Ellipsis
    editproduct.Click Edit Button
    editproduct.Delete image
    editproduct.Fill Product name
    editproduct.Upload Image    truck.jpg
    editproduct.Fill Price
    editproduct.Fill Product Detail
    editproduct.Fill Quantity
    editproduct.Select Conditions    2
    editproduct.Fill Period
    editproduct.Select Delivery    2
    editproduct.Click pageback
    editproduct.Validation : Pageback    Cancel
    editproduct.Click pageback
    editproduct.Validation : Pageback    Confirm
    editproduct.Validation : Product    RobotTest
