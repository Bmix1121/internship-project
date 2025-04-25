*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/resource/POM/Seller/Product/createproduct.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    Database.Delete product via DB
...                     AND    DataBase.Update all Product via DB use MC    1
...                     AND    common.Open MarketplaceMicrosite    ${SELLER}
...                     AND    common.Navigate To AddProduct
Suite Teardown      Run Keywords    DataBase.Update all Product via DB use MC    0
...                     AND    DataBase.Update ProfileImage
Test Setup          common.Navigate To AddProduct
Test Teardown       Run Keywords    Database.Delete Product via DB
...                     AND    Reload


*** Test Cases ***
Create Product
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอกข้อมูลถูกต้องทุกเงื่อนไข
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    monitor.jpg    mouse.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

No fill product name
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กรอก ชื่อสินค้า
    [Tags]    createproduct    seller

    createproduct.Fill Product name    ${EMPTY}
    createproduct.Upload Image    cap.jpg    hoodie.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Required check    กรุณากรอกชื่อสินค้า

Image type test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .jpeg
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .jpg
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .png
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .gif
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    TESTjpeg.jpeg    TESTjpg.jpg    TESTpng.png    TESTgif.gif
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

Image file size test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์ไม่เกิน 10 MB
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์ 10 MB
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์เกิน 10 MB
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    C.jpg    10MB.png    11MB.png
    createproduct.Validation : upload image    อัปโหลดไฟล์ได้ไม่เกิน 10 MB
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

Not image file upload
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ ไม่ถูกต้องตามเงื่อนไข'
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    Note-1.txt
    createproduct.Validation : upload image    กรุณาอัปโหลดไฟล์ที่เป็นรูปภาพเท่านั้น
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create

No upload image
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่อัปโหลด รูปภาพ
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Required check    กรุณาเพิ่มรูปภาพสินค้า

Upload image test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ 1รูป
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ 5 รูป
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ 6 รูป
    [Tags]    createproduct    seller

    createproduct.Upload image test    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product
    Database.Delete Product via DB
    common.Navigate To AddProduct
    createproduct.Upload image test    5
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product
    Database.Delete Product via DB
    common.Navigate To AddProduct
    createproduct.Upload image test    6
    createproduct.Validation : upload image    อัปโหลดรูปภาพได้ไม่เกิน 5 รูป

No fill price
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กรอก ราคาสินค้า
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    A.jpg
    createproduct.Fill Price    ${EMPTY}
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Required check    กรุณากรอกราคาสินค้า

Fill pice test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า น้อยกว่า 0 บาท
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า    0 บาท
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอก ราคาสินค้า    มากกว่า 0 บาท
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า เป็นตัวหนังสือ
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    onion.jpg
    createproduct.Fill Price    -1
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    createproduct.Fill Price    0
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    createproduct.Fill Price    TEST
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    createproduct.Fill Price    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

No fill product detail
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีไม่กรอก รายละเอียดสินค้า
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    onion.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail    ${EMPTY}
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

No fill Quantity
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กรอก จำนวนคลังสินค้า
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    onion.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity    ${EMPTY}
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Required check    กรุณากรอกจำนวนสินค้า

Fill quantity test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า น้อยกว่า 0 ชิ้น
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า    0 ชิ้น
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอก จำนวนคลังสินค้า    มากกว่า 0 ชิ้น
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า เป็นตัวหนังสือ
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    onion.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity    -1
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    createproduct.Fill Quantity    0
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    createproduct.Fill Quantity    TEST
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    createproduct.Fill Quantity    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

No select condition
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กดเลือก Condition
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    C.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    ${EMPTY}
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Required check    กรุณาเลือกประเภทสินค้า

Create product and preOrder is false
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = FALSE
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    glasses.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period    ${False}
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

Create product and preOrder is true
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = TRUE
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    housemodel.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

No fill period
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = TRUE แต่ไม่กรอก "ระยะเวลา"
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    C.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.No fill Period
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Required check    กรุณากรอกระยะเวลา

Fill period test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา น้อยกว่า 0
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา เท่ากับ 0
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอก ระยะเวลา มากกว่า 0
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา เป็นตัวหนังสือ
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    monitor.jpg    mouse.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill period test    -1
    createproduct.Select Delivery    1
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    createproduct.Fill period test    0
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    createproduct.Fill period test    TEST
    createproduct.Click Create
    createproduct.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    createproduct.Fill period test    1
    createproduct.Click Create
    createproduct.Validation : create product
    createproduct.Validation : product

No select delivery
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กดเลือก รายละเอียดการส่งสินค้า
    [Tags]    createproduct    seller

    createproduct.Fill Product name
    createproduct.Upload Image    monitor.jpg    mouse.jpg
    createproduct.Fill Price
    createproduct.Fill Product Detail
    createproduct.Fill Quantity
    createproduct.Select Conditions    1
    createproduct.Fill Period
    createproduct.Select Delivery    ${EMPTY}
    createproduct.Click Create
    createproduct.Required check    กรุณาเลือกวิธีการส่งสินค้า

Validation
    [Documentation]
    ...    ตรวจสอบการพรีวิวรูปภาพ
    ...    ตรวจสอบการลบรูปภาพ
    ...    ปุ่ม Page Back
    [Tags]    createproduct    seller

    createproduct.Upload Image    handgun.jpg    hoodie.jpg    watch.jpg    sneakers.jpg
    createproduct.View image
    createproduct.Delete Image
    createproduct.Click pageback
