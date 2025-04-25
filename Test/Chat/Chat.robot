*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/Resource/POM/Chat/Chat.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot
Resource            ${EXECDIR}/libraries/api/productAPI.robot

Suite Setup         Run Keywords    Database.Clear Chat via DB use ID
...                     AND    DataBase.Delete Product via DB
...                     AND    common.Open MarketplaceMicrosite    ${CUSTOMER}
...                     AND    common.Navigate To Productlist
Suite Teardown      Run Keywords    DataBase.Update ProfileImage
...                     AND    DataBase.Delete Product via DB


*** Test Cases ***
Chat Test
    [Setup]    productAPI.Create Product via API

    Chat.Select Product
    Chat.Click Contact Seller
    Chat.Send Message
    Close Page
    New Page    ${MICROURL}${SELLER}
    common.Navigate To Seller
    Chat.Click Message Menu
    Chat.Validate Message
    Chat.Send Message    0123ABC
    Close Page
    New Page    ${MICROURL}${CUSTOMER}
    common.Navigate To Seller
    Chat.Click Message Menu
    Chat.Validate Message    0123ABC
