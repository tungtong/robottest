*** Settings ***
Library    RPA.Excel.Files

*** Test Cases ***
case1
    Create Workbook
    FOR    ${item}    IN RANGE    1    14
     IF    1 != 2
        Set Cell Value    ${item}    1    ${item}'test1'
        Set Cell Value    ${item}    2    ${item}'test2'
        Save Workbook    difprice.xlsx
    END
    END