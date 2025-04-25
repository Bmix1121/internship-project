*** Settings ***
Library     Browser


*** Variables ***
${SendBtn}              //button[@data-test-id="SendBtn"]
${MessageTxb}           //textarea[@data-test-id="MessageTxb"]
${UploadImageBtn}       //label[@data-test-id="Image_UploadBtn"]
${LoadBtn}              //button[@data-test-id="loadBtn"]
${ContactSellerBtn}     //button[@data-test-id="ContactSellerBtn"]
${MessageMenu}          //div[contains(@class, "flex border-b-2")]/div[text()="ข้อความ"]


*** Keywords ***
Select Product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Scroll By    selector=//section[2]    vertical=10000
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Click Contact Seller
    Click    ${ContactSellerBtn}

Send Message
    [Arguments]    ${message}=MessageTest
    Fill Text    ${MessageTxb}    ${message}
    Click    ${SendBtn}
    Wait For Elements State    //div[text()="${message}"]    visible    5s

Click Message Menu
    Click    ${MessageMenu}

Validate Message
    [Arguments]    ${text}=MessageTest
    ${ChatCheck}=    Run Keyword And Return Status
    ...    Wait For Elements State
    ...    //div[contains(@class, "block font-sans text-xl antialiased") and text()=" TEST01 "]    visible    2s
    IF    ${ChatCheck} == ${True}
        Click    //div[contains(@class, "block font-sans text-xl antialiased") and text()=" TEST01 "]
    ELSE
        Wait For Elements State
        ...    //div[contains(@class, "block font-sans text-xl antialiased") and text()=" TEST02 "]
        ...    visible
        ...    2s
        Click    //div[contains(@class, "block font-sans text-xl antialiased") and text()=" TEST02 "]
    END
    Wait For Elements State    //div[text()="${text}"]    visible    5s
