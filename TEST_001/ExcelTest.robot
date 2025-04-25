*** Settings ***
Library     ExcelLibrary
Library     FakerLibrary
Library     Collections
# *** Variables ***
# @{dataList}    @{EMPTY}


*** Test Cases ***
TC-01 
    Create Excel File


*** Keywords ***
Create Excel File
    Open Excel Document    filename=${EXECDIR}/Data/ExcelTestTemplat.xlsx    doc_id=0

    FOR    ${i}    IN RANGE    1
        ${Firstname}    FakerLibrary.First Name
        ${Lastname}    FakerLibrary.Last Name
        ${Email}    FakerLibrary.Email
        ${Address}    FakerLibrary.Street Address
        # Append To List    ${dataList}    ${Firstname}    ${Lastname}    ${Address}
        ${row_num}    Evaluate    ${i}+2
        # Write Excel Row    row_data=@{dataList}    row_num=${row_num}
        Write Excel Cell    row_num=${row_num}    col_num=1    value=${Firstname}    sheet_name=Sheet
        Write Excel Cell    row_num=${row_num}    col_num=2    value=${Lastname}    sheet_name=Sheet
        Write Excel Cell    row_num=${row_num}    col_num=3    value=${Email}    sheet_name=Sheet
        Write Excel Cell    row_num=${row_num}    col_num=4    value=${Address}    sheet_name=Sheet
    END

    Save Excel Document    filename=${EXECDIR}/Excel/ExcelTest.xlsx
