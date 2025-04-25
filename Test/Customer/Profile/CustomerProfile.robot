*** Settings ***
Library             Browser    auto_closing_level=TEST
Resource            ${EXECDIR}/Resource/Common/common.resource
Resource            ${EXECDIR}/Resource/POM/Customer/Profile/cusprofile.resource
Resource            ${EXECDIR}/libraries/db/DataBase.robot

Suite Setup         Run Keywords    common.OpenMarketplaceMicrosite    ${CUSTOMER}    AND    common.Navigate To CustomerProfile
Suite Teardown      DataBase.Update ProfileImage


*** Test Cases ***
Test
    cusprofile.Customer Profile Test
