*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/Resource/POM/Seller/Profile/sellerprofile.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    common.OpenMarketplaceMicrosite    ${SELLER}    AND    common.Navigate To Seller
Suite Teardown      DataBase.Update ProfileImage


*** Test Cases ***
Test
    sellerprofile.Seller Profile Test
