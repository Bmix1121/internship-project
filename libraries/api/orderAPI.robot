*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         String
Variables       ${EXECDIR}/Config/config.yaml
Resource        ${EXECDIR}/libraries/api/productAPI.robot


*** Keywords ***
Create Order via API
    [Arguments]
    ...    ${productId}=${PRODUCTID.EVN}    # robotcode: ignore
    ...    ${memberCodeBuyer}=${CUSTOMER}
    ...    ${memberCodeSeller}=${SELLER}
    ...    ${quantity}=5
    ...    ${shippingLocation}=1
    ...    ${paymentMethods}=1
    ...    ${note}=Create Order by Robot
    ${memberCodeBuyer}    Convert To String    ${memberCodeBuyer}
    ${memberCodeSeller}    Convert To String    ${memberCodeSeller}
    ${quantity}    Convert To Integer    ${quantity}
    ${paymentMethods}    Convert To Integer    ${paymentMethods}
    ${shippingLocation}    Convert To Integer    ${shippingLocation}
    &{header}    Create Dictionary    Content-Type=application/json
    ${data}    Create Dictionary
    ...    productId=${productId}
    ...    memberCodeBuyer=${memberCodeBuyer}
    ...    memberCodeSeller=${memberCodeSeller}
    ...    quantity=${quantity}
    ...    shippingLocation=${paymentMethods}
    ...    paymentMethods=${shippingLocation}
    ...    note=${note}

    ${dataJSON}    Evaluate    json.dumps(${data})
    ${res}    POST    ${APIBaseURL}/Order    data=${dataJSON}    headers=${header}
    Status Should Be    200    ${res}
    ${ORDERID.EVN}    Get From Dictionary    ${res.json()}    id
    Set Global Variable    ${ORDERID.EVN}

Change Order Status to completed via API
    [Arguments]
    ...    ${OrderId}=${ORDERID.EVN}    # robotcode: ignore
    ${res}    POST    ${APIBaseURL}/Order/${OrderId}/EarnPoint
    Status Should Be    200    ${res}

Change Order Status to Canceled via API
    [Arguments]
    ...    ${OrderId}=${ORDERID.EVN}    # robotcode: ignore
    ...    ${CUSTOMER}=${CUSTOMER}
    ${data}    Create Dictionary
    ...    cancel=RobotTest : Cancel Order
    ${dataJSON}    Evaluate    json.dumps(${data})
    &{header}    Create Dictionary    Content-Type=application/json
    ${res}    POST    ${APIBaseURL}/Order/CancelOrder/${CUSTOMER}/${OrderId}    data=${dataJSON}    headers=${header}
    Status Should Be    200    ${res}

Add orders via API
    [Documentation]
    ...    pending    |    completed    |    Canceled
    [Arguments]    ${st}    ${n}

    IF    "${st}" == "pending"
        FOR    ${i}    IN RANGE    ${n}
            productAPI.Create Product via API    ImageList=onion.jpg
            Create Order via API
        END
    ELSE IF    "${st}" == "completed"
        FOR    ${i}    IN RANGE    ${n}
            productAPI.Create Product via API    ImageList=glasses.jpg
            Create Order via API
            Change Order Status to completed via API
        END
    ELSE
        FOR    ${i}    IN RANGE    ${n}
            productAPI.Create Product via API    ImageList=ring.jpg
            Create Order via API
            Change Order Status to Canceled via API
        END
    END

Create order for Best selling
    [Arguments]
    ...    ${productId}=${PRODUCTID.EVN}    # robotcode: ignore
    ...    ${memberCodeBuyer}=${CUSTOMER}
    ...    ${memberCodeSeller}=${SELLER}
    ...    ${quantity}=5
    ...    ${shippingLocation}=1
    ...    ${paymentMethods}=1
    ...    ${note}=CreateOrder_Test
    FOR    ${i}    IN RANGE    3
        ${quantity}    Convert To Integer    ${quantity}
        ${paymentMethods}    Convert To Integer    ${paymentMethods}
        ${shippingLocation}    Convert To Integer    ${shippingLocation}
        &{header}    Create Dictionary    Content-Type=application/json
        ${data}    Create Dictionary
        ...    productId=${productId}
        ...    memberCodeBuyer=${memberCodeBuyer}
        ...    memberCodeSeller=${memberCodeSeller}
        ...    quantity=${quantity}
        ...    shippingLocation=${paymentMethods}
        ...    paymentMethods=${shippingLocation}
        ...    note=${note}

        ${dataJSON}    Evaluate    json.dumps(${data})
        ${res}    POST    ${APIBaseURL}/Order    data=${dataJSON}    headers=${header}
        Status Should Be    200    ${res}
        ${ORDERID.EVN}    Get From Dictionary    ${res.json()}    id
        Set Global Variable    ${ORDERID.EVN}
    END
