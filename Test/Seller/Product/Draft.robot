*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/resource/POM/Seller/Product/draft.resource
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
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    monitor.jpg    mouse.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

No fill product name
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กรอก ชื่อสินค้า
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name    ${EMPTY}
    Draft.Upload Image    cap.jpg    hoodie.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Required check    กรุณากรอกชื่อสินค้า

Image type test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .jpeg
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .jpg
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .png
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ด้วยไฟล์นามสกุล .gif
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    TESTjpeg.jpeg    TESTjpg.jpg    TESTpng.png    TESTgif.gif
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

Image file size test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์ไม่เกิน 10 MB
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์ 10 MB
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ ขนาดไฟล์เกิน 10 MB
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    C.jpg    10MB.png    11MB.png
    Draft.Validation : upload image    อัปโหลดไฟล์ได้ไม่เกิน 10 MB
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

Not image file upload
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ ไม่ถูกต้องตามเงื่อนไข'
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    Note-1.txt
    Draft.Validation : upload image    กรุณาอัปโหลดไฟล์ที่เป็นรูปภาพเท่านั้น
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft

No upload image
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่อัปโหลด รูปภาพ
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Required check    กรุณาเพิ่มรูปภาพสินค้า

Upload image test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ 1รูป
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีอัปโหลด รูปภาพ 5 รูป
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีอัปโหลด รูปภาพ 6 รูป
    [Tags]    createproduct    draft    seller

    Draft.Upload image test    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product
    Database.Delete Product via DB
    common.Navigate To AddProduct
    Draft.Upload image test    5
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product
    Database.Delete Product via DB
    common.Navigate To AddProduct
    Draft.Upload image test    6
    Draft.Validation : upload image    อัปโหลดรูปภาพได้ไม่เกิน 5 รูป

No fill price
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กรอก ราคาสินค้า
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    A.jpg
    Draft.Fill Price    ${EMPTY}
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Required check    กรุณากรอกราคาสินค้า

Fill pice test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า น้อยกว่า 0 บาท
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า    0 บาท
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอก ราคาสินค้า    มากกว่า 0 บาท
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ราคาสินค้า เป็นตัวหนังสือ
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    onion.jpg
    Draft.Fill Price    -1
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    Draft.Fill Price    0
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    Draft.Fill Price    TEST
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    Draft.Fill Price    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

No fill product detail
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีไม่กรอก รายละเอียดสินค้า
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    onion.jpg
    Draft.Fill Price
    Draft.Fill Product Detail    ${EMPTY}
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

No fill Quantity
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กรอก จำนวนคลังสินค้า
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    onion.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity    ${EMPTY}
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Required check    กรุณากรอกจำนวนสินค้า

Fill quantity test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า น้อยกว่า 0 ชิ้น
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า    0 ชิ้น
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอก จำนวนคลังสินค้า    มากกว่า 0 ชิ้น
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก จำนวนคลังสินค้า เป็นตัวหนังสือ
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    onion.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity    -1
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    Draft.Fill Quantity    0
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    Draft.Fill Quantity    TEST
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    Draft.Fill Quantity    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

No select condition
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กดเลือก Condition
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    C.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    ${EMPTY}
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Required check    กรุณาเลือกประเภทสินค้า

Create product and preOrder is false
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = FALSE
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    glasses.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period    ${False}
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

Create product and preOrder is true
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = TRUE
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    housemodel.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

No fill period
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีเลือก สถานะ สินค้าพรีออเดอร์ = TRUE แต่ไม่กรอก "ระยะเวลา"
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    C.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.No fill Period
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Required check    กรุณากรอกระยะเวลา

Fill period test
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา น้อยกว่า 0
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา เท่ากับ 0
    ...    ผู้ขายเพิ่มสินค้า สำเร็จ กรณีกรอก ระยะเวลา มากกว่า 0
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีกรอก ระยะเวลา เป็นตัวหนังสือ
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    monitor.jpg    mouse.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill period test    -1
    Draft.Select Delivery    1
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    Draft.Fill period test    0
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลให้ถูกต้อง
    Draft.Fill period test    TEST
    Draft.Click Draft
    Draft.Validation : fill price , fill quantity , fill period    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น
    Draft.Fill period test    1
    Draft.Click Draft
    Draft.Validation : create product
    Draft.Validation : product

No select delivery
    [Documentation]
    ...    ผู้ขายเพิ่มสินค้า ไม่สำเร็จ กรณีไม่กดเลือก รายละเอียดการส่งสินค้า
    [Tags]    createproduct    draft    seller

    Draft.Fill Product name
    Draft.Upload Image    monitor.jpg    mouse.jpg
    Draft.Fill Price
    Draft.Fill Product Detail
    Draft.Fill Quantity
    Draft.Select Conditions    1
    Draft.Fill Period
    Draft.Select Delivery    ${EMPTY}
    Draft.Click Draft
    Draft.Required check    กรุณาเลือกวิธีการส่งสินค้า

Validation
    [Documentation]
    ...    ตรวจสอบการพรีวิวรูปภาพ
    ...    ตรวจสอบการลบรูปภาพ
    ...    ปุ่ม Page Back
    [Tags]    createproduct    draft    seller

    Draft.Upload Image    handgun.jpg    hoodie.jpg    watch.jpg    sneakers.jpg
    Draft.View image
    Draft.Delete Image
    Draft.Click pageback
