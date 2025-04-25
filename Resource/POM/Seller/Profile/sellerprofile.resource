*** Settings ***
Library     Browser


*** Variables ***
${History}          //*[@data-test-id="Sell_History"]
${ToShip}           //*[@data-test-id="ToShip"]
${Canceled}         //*[@data-test-id="Canceled"]
${Completed}        //*[@data-test-id="Completed"]
${MyProduct}        //*[@data-test-id="MyProduct"]
${AddProductBtn}    //button[@data-test-id="AddNewProduct"]
${PageBack}         //*[@data-test-id="PageBackBtn"]


*** Keywords ***
Seller Profile Test
    @{elements}    Create List    ${History}    ${ToShip}    ${Canceled}    ${Completed}
    @{elements2}    Create List    ${ToShip}    ${Canceled}    ${MyProduct}    ${AddProductBtn}

    FOR    ${i}    IN    @{elements}
        Click    ${i}
        Sleep    0.1s
    END
    Click    ${PageBack}
    FOR    ${i}    IN    @{elements2}
        Click    ${i}
        Sleep    0.1s
        Click    ${PageBack}
    END
