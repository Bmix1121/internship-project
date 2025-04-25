*** Settings ***
Library         RequestsLibrary
Library         OperatingSystem
Library         Collections
Library         String
Variables       ${EXECDIR}/Config/config.yaml


*** Keywords ***
Create Product via API
    [Documentation]
    ...    Create Product via API : POST /Product
    [Arguments]
    ...    ${name}=RobotTest
    ...    ${quantity}=20
    ...    ${price}=1
    ...    ${description}=Create Product by Robot
    ...    ${memberCode}=${SELLER}
    ...    ${period}=7
    ...    ${isPreOrder}=${True}
    ...    ${isEnable}=${True}
    ...    ${shippingLocation}=1
    ...    ${productStatus}=1
    ...    ${grade}=1
    ...    ${ImageList}=laptop.jpg,laptop2.jpg,laptop3.jpg,laptop4.jpg
    ${quantity}    Convert To Integer    ${quantity}
    ${price}    Convert To Integer    ${price}
    ${memberCode}    Convert To String    ${memberCode}
    ${shippingLocation}    Convert To Integer    ${shippingLocation}
    ${productStatus}    Convert To Integer    ${productStatus}
    ${grade}    Convert To Integer    ${grade}
    &{data}    Create Dictionary
    ...    name=${name}
    ...    quantity=${quantity}
    ...    price=${price}
    ...    description=${description}
    ...    memberCode=${memberCode}
    ...    period=${period}
    ...    isPreOrder=${isPreOrder}
    ...    isEnable=${isEnable}
    ...    shippingLocation=${shippingLocation}
    ...    productStatus=${productStatus}
    ...    grade=${grade}
    &{header}    Create Dictionary    Content-Type=application/json
    ${dataJSON}    Evaluate    json.dumps(${data})
    ${res}    POST    ${APIBaseURL}/Product    data=${dataJSON}    headers=${header}
    Status Should Be    200    ${res}
    ${PRODUCTID.EVN}    Get From Dictionary    ${res.json()}    productId
    Set Global Variable    ${PRODUCTID.EVN}
    Add Image Via API    ProductId=${PRODUCTID.EVN}    ImageList=${ImageList}

Add Image Via API
    [Documentation]
    ...    Add Image Via API : /Product/ProductImage
    [Arguments]
    ...    ${ProductId}
    ...    ${ImageList}
    @{ImageList}    String.Split String    ${ImageList}    ,

    &{data}    Create Dictionary
    ...    ProductId=${ProductId}

    FOR    ${ImageName}    IN    @{ImageList}
        &{files}    Create Dictionary
        Create Multi Part    ${files}    Files    ${EXECDIR}${ImagePath}/${ImageName}    contentType=image/jpeg
        ${res}    POST    ${APIBaseURL}/Product/ProductImage    files=${files}    data=${data}
        Status Should Be    200    ${res}
    END

Delete product via API
    [Arguments]
    ...    ${productId}=${PRODUCTID.EVN}    # robotcode: ignore

    ${res}    DELETE    ${APIBaseURL}/Product/${productId}
    Status Should Be    200    ${res}

Create Multi Part
    [Arguments]    ${addTo}    ${partName}    ${filePath}    ${contentType}
    ${fileData}    Get Binary File    ${filePath}
    ${fileDir}    ${fileName}    Split Path    ${filePath}
    ${partData}    Create List    ${fileName}    ${fileData}    ${contentType}
    Set To Dictionary    ${addTo}    ${partName}=${partData}
