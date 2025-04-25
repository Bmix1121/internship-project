*** Settings ***
Library     Browser
Library     FakerLibrary


*** Variables ***
${CloseBtn}             //button[@data-test-id="CloseBtn"]
${PageBackBtn}          //div[@data-test-id="PageBackBtn"]
${BuyBtn}               //button[@data-test-id="BuyBtn"]
${ContactBtn}           //button[@data-test-id="ContactSellerBtn"]
${AllProduct}           //button[@data-test-id="AllProduct"]
${SendBtn}              //button[@data-test-id="SendBtn"]
${MessageTxb}           //textarea[@data-test-id="MessageTxb"]
${UploadImageBtn}       //label[@data-test-id="Image_UploadBtn"]
${WishlistBtn}          //div[@data-test-id="WishlistBtn"]
${LoadBtn}              //button[@data-test-id="loadBtn"]


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

Validation : product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Scroll By    selector=//section    vertical=10000
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Validation Product is Out of Stock
    Wait For Elements State    //div[@data-test-id="OutofStockPopup"]
    Click    //span[@data-test-id="CloseBtn"]

Send Message
    ${Message}=    FakerLibrary.Text    max_nb_chars=20
    Fill Text    ${MessageTxb}    ${Message}
    Click Send
    Sleep    1s
    Wait For Elements State    //div[contains(text(),'${Message}')]    visible    2s

Upload Image
    [Arguments]    @{ImageName}
    ${Imagecount}=    Get Length    ${ImageName}
    FOR    ${i}    IN    @{ImageName}
        Sleep    0.6s
        Upload File By Selector    ${UploadImageBtn}    ${EXECDIR}/Data/image/${i}
    END
    FOR    ${i}    IN RANGE    ${Imagecount}
        Wait For Elements State    (//img[contains(@class, "max-w-xs mt-2")])[${Imagecount}]
        ${Imagecount}=    Evaluate    ${Imagecount}-1
    END

View Image
    [Documentation]
    ...    right : Press right to view next picture
    ...    left : Press left to view previous picture
    [Arguments]    ${InputR&L}    ${count}
    Click With Options    //button[contains(@class, "w-2/4 h-72 bottom-0 ${InputR&L}-0")]    clickCount=${count}

Click Buy
    Click    ${BuyBtn}

Click CloseBtn
    Click    ${CloseBtn}

Click Contact
    Click    ${ContactBtn}

Click Send
    Click    ${SendBtn}

Click PageBack
    Click    ${PageBackBtn}

Click Wishlist
    Click    ${WishlistBtn}

Click View all products
    Sleep    1s
    Click    ${AllProduct}
