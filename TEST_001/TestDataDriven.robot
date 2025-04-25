*** Settings ***
Library             Browser    auto_closing_level=TEST
Library             DataDriver    file=Test_DataDriven.xlsx    sheet_name=Sheet1
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/TEST_001/testdatadriven.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    DataBase.Update all Product via DB    1
...                     AND    common.Open MarketplaceMicrosite
...                     AND    common.Navigate To AddProduct
Suite Teardown      DataBase.Update all Product via DB    0
Test Setup          common.Navigate To AddProduct
Test Teardown       Run Keywords    Reload
Test Template       TEST


*** Test Cases ***
Create Product
    TEST


*** Keywords ***
TEST
    [Arguments]
    ...    ${ProductName}
    ...    ${imageName}
    ...    ${Price}
    ...    ${Des}
    ...    ${Stock}
    ...    ${Condition}
    ...    ${isPreOrder}
    ...    ${Delivery}
    # ${log}    Catenate    
    # ...    ${\n}*********************
    # ...    ${\n}Data : ${ProductName} | ${imageName} | ${Price} | ${Des} | ${Stock} | ${Condition} | ${isPreOrder} | ${Delivery}
    # Log To Console    ${log}

    Fill Text    ${ProductNameTxb}    ${Productname}
    FOR    ${i}    IN    ${imageName}
        Run Keyword And Continue On Failure
        ...    Upload File By Selector    ${ImageUpload}    ${EXECDIR}${ImagePath}${i}
    END
    Fill Text    ${PriceTxb}    ${Price}
    Fill Text    ${ProductDetailTxb}    ${Des}
    Fill Text    ${QuantityTxb}    ${Stock}
    IF    '${Condition}' == '1'
        Click    ${Condition1}
    ELSE IF    '${Condition}' == '2'
        Click    ${Condition2}
    END
    ${isChecking}=    Run Keyword And Return Status
    ...    Wait For Elements State    selector=//input[@data-test-id='PeriodTxb']    state=visible    timeout=1s
    IF    ${isPreOrder} != ${False}
        IF    ${isChecking} == ${False}
            Click    ${PreOrderSwitch}
            Fill Text    ${PeriodTxb}    ${isPreOrder}
        ELSE IF    ${isChecking} == ${True}
            Fill Text    ${PeriodTxb}    ${isPreOrder}
        END
    ELSE IF    ${isPreOrder} == ${False}
        IF    ${isChecking} == ${True}    Click    ${PreOrderSwitch}
    END
    IF    '${Delivery}' == '1'
        Click    ${Delivery1}
    ELSE IF    '${Delivery}' == '2'
        Click    ${Delivery2}
    END
    Click Create
    Validation : create product
    Validation : product    ${ProductName}
