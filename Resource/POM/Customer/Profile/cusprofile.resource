*** Settings ***
Library     Browser


*** Variables ***
${Pending}          //div[@data-test-id="Pending"]
${Complete}         //div[@data-test-id="Complete"]
${Cancel}           //div[@data-test-id="Cancel"]
${History}          //a[@data-test-id="Order_History"]
${Wishlist}         //div[@data-test-id="Wishlist"]
${AddProduct}       //div[@data-test-id="AddProduct"]

${Pageback}         //div[@data-test-id="PageBackBtn"]

${Menu1}            //*[@data-test-id="Pending_Order"]
${Menu2}            //*[@data-test-id="Complete_Order"]
${Menu3}            //*[@data-test-id="Cancel_Order"]


*** Keywords ***
Customer Profile Test
    @{elements}=    Create List    ${Pending}    ${Complete}    ${Cancel}
    @{elements2}=    Create List    ${History}    ${Menu2}    ${Menu3}    ${Menu1}

    FOR    ${i}    IN    @{elements2}
        Click    ${i}
        Sleep    0.1s
    END
    Click    ${Pageback}
    FOR    ${i}    IN    @{elements}
        Click    ${i}
        Sleep    0.1s
        Click    ${Pageback}
    END
    Click    ${Wishlist}
    Click    ${Pageback}
    Click    ${AddProduct}
