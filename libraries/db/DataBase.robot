*** Settings ***
Library         DatabaseLibrary
Library         Browser
Library         String
Library         collections
Variables       ../../config/config.yaml
# *** Test Cases ***
# TEST
#    Clear Chat via DB use ID


*** Keywords ***
Connect To "any-beyond-marketplace" Database
    Connect To Database
    ...    pymysql
    ...    ${db}[anybeyond-marketplace][options][database][0]
    ...    ${db}[anybeyond-marketplace][username]
    ...    ${db}[anybeyond-marketplace][password]
    ...    ${db}[anybeyond-marketplace][server]
    ...    ${db}[anybeyond-marketplace][options][port]

Connect To "any-beyond-cgc" Database
    Connect To Database
    ...    pymysql
    ...    ${db}[anybeyond-cgc][options][database][0]
    ...    ${db}[anybeyond-cgc][username]
    ...    ${db}[anybeyond-cgc][password]
    ...    ${db}[anybeyond-cgc][server]
    ...    ${db}[anybeyond-cgc][options][port]

Delete Product via DB
    [Documentation]
    ...    DELETE Product that has Name LIKE "Robot"
    Connect To "any-beyond-marketplace" Database
    Execute Sql String    DELETE FROM Product WHERE Name LIKE '%Robot%';
    Disconnect From Database

Update all Product via DB use MC
    [Documentation]
    ...    0 = enable
    ...    1 = disable
    [Arguments]    ${n}
    Connect To "any-beyond-marketplace" Database
    Execute Sql String    UPDATE Product SET IsDelete = '${n}' WHERE MemberCode = ${SELLER};
    Disconnect From Database

Update all Order via DB
    [Documentation]
    ...    0 = enable
    ...    1 = disable
    [Arguments]    ${n}
    Connect To "any-beyond-marketplace" Database
    Execute Sql String    UPDATE `Order` SET IsDelete = '${n}';
    Disconnect From Database

Delete all Order via DB use MC
    Connect To "any-beyond-marketplace" Database
    Execute Sql String
    ...    DELETE FROM `Order`WHERE Note LIKE '%2024%' OR Note LIKE '%2042%' OR Note LIKE '%Create Order by Robot%';
    Disconnect From Database

Update Quantity via DB
    [Documentation]
    ...    UPDATE Product Quantity that has Name LIKE "Robot"
    [Arguments]    ${Quantity}
    Connect To "any-beyond-marketplace" Database
    Execute Sql String    UPDATE Product SET Quantity = ${Quantity} WHERE Name LIKE 'Robot%'
    Disconnect From Database

Set Points for Testing via SQL
    [Arguments]    ${PointExpected}
    Connect To "any-beyond-cgc" Database
    Execute Sql String
    ...    UPDATE `cgc-beyond`.corp_employee SET balance_point = ${PointExpected} WHERE emp_id = '${CUSTOMER}';
    Execute Sql String
    ...    UPDATE `any-beyond-topup`.Users SET Point = ${PointExpected} WHERE MemberCode = '${CUSTOMER}';
    Execute Sql String
    ...    UPDATE `any-beyond-cafe`.User SET Point = ${PointExpected} WHERE MemberCode = '${CUSTOMER}';
    Disconnect From Database
    Connect To "any-beyond-marketplace" Database
    Execute Sql String
    ...    UPDATE `any-beyond-marketplace`.User SET Point = ${PointExpected} WHERE MemberCode = '${CUSTOMER}';
    Disconnect From Database
    Run Keyword And Ignore Error    Reload

Delete Order via DB
    Connect To "any-beyond-marketplace" Database
    Execute Sql String
    ...    DELETE FROM `Order` WHERE Id IN ( SELECT OrderId FROM OrderTransaction WHERE MemberCodeBuyer = ${CUSTOMER} )
    Disconnect From Database

Get productId in favorites via DB
    Connect To "any-beyond-marketplace" Database
    ${result}=    Query    SELECT ProductId FROM Favorites;
    ${id_list}=    Evaluate    [i[0] for i in ${result}]
    ${PRODUCTIDLIST.EVN}=    Evaluate    ','.join(${id_list})
    Set Global Variable    ${PRODUCTIDLIST.EVN}
    Disconnect From Database

Delete product in wishlist via DB
    Connect To "any-beyond-marketplace" Database
    Execute Sql String    DELETE FROM Favorites WHERE MemberCode = ${CUSTOMER}
    Disconnect From Database

Clear Chat via DB use ID
    Connect To "any-beyond-marketplace" Database
    Execute Sql String
    ...    DELETE FROM Chat WHERE (SenderId = '${SELLERID}' AND ReceiverId = '${CUSTOMERID}') OR (SenderId = '${CUSTOMERID}' AND ReceiverId = '${SELLERID}');
    Disconnect From Database

