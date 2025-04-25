*** Settings ***
Library         Browser
Variables       ${EXECDIR}/Config/config.yaml


*** Keywords ***
Open MarketplaceMicrosite
    [Arguments]    ${Token}
    New Browser    chromium    headless=True
    New Context    viewport={ "width": 500, "height": 888 }
    New Page    ${MICROURL}${Token}
    Wait For Load State    load    timeout=5s
    Sleep    1s

Navigate To Seller
    Go To    url=${BASEURL}/seller
    Wait For Load State    load    timeout=5s

Navigate To MyProduct
    Go To    url=${BASEURL}/seller/myProduct
    Wait For Load State    load    timeout=5s

Navigate To AddProduct
    Go To    url=${BASEURL}/seller/addProduct
    Wait For Load State    load    timeout=5s

Navigate To OrderStatus
    Go To    url=${BASEURL}/seller/orderStatus
    Wait For Load State    load    timeout=5s

Navigate To Productlist
    Go To    url=${BASEURL}/customer
    Wait For Load State    load    timeout=5s
    Reload

Navigate To CustomerProfile
    Go To    url=${BASEURL}/customer/profile
    Wait For Load State    load    timeout=5s

Navigate To Wishlist
    Go To    url=${BASEURL}/customer/wishlist-product
    Wait For Load State    load    timeout=5s
