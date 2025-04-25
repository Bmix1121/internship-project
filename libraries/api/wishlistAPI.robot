*** Settings ***
Library         RequestsLibrary
Library         String
Variables       ${EXECDIR}/Config/config.yaml
Resource        ${EXECDIR}/libraries/db/DataBase.robot


*** Keywords ***
Add&Delete product to wishlist via API
    [Documentation]
    ...    Add product to wishlist via API : /Favoriter
    [Arguments]
    ...    ${productId}=${PRODUCTID.EVN}    # robotcode: ignore
    ...    ${MemberCode}=${CUSTOMER}
    ${params}    Create Dictionary
    ...    MemberCode=${MemberCode}
    ...    productId=${productId}
    ${MemberCode}    Convert To String    ${MemberCode}

    ${res}    POST    ${APIBaseURL}/Favorites    params=${params}

Add&Delete for no product in wishlist via API
    [Documentation]
    ...    Add product to wishlist via API : /Favoriter
    [Arguments]
    ...    ${MemberCode}=${CUSTOMER}
    ${MemberCode}    Convert To String    ${MemberCode}

    @{ProductIdlist}    String.Split String    ${PRODUCTIDLIST.EVN}    ,    # robotcode: ignore

    FOR    ${i}    IN    @{ProductIdlist}
        ${params}    Create Dictionary
        ...    MemberCode=${MemberCode}
        ...    productId=${i}
        ${res}    POST    ${APIBaseURL}/Favorites    params=${params}
    END
