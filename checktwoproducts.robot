*** Settings ***
Library   SeleniumLibrary
Library    XML
Library    RequestsLibrary
Library    collections
Library    os
Library    String
Library    RPA.Excel.Files
Library    DateTime

*** Variables ***
${baseurl}    https://livekaarten.nl
@{products}=    Microsoft Office Pro Plus 2021 - 1 user PC     Windows 10 Pro (32-64bit OEM)

*** Test Cases ***
Get XML from site
    #Get Shopping feed
    Create Session    mysession    ${baseurl}
    ${response}=    GET On Session    mysession    /shoppingfeed/custom/google
    ${xmlstring}=    Convert To String    ${response.content}
    ${xml_obj}=    Parse Xml    ${xmlstring}
    ${count}=    XML.Get Element Count    ${xml_obj}    .//channel/item
    #Check price from feed and shop
    Create Workbook
    FOR    ${item}    IN RANGE    1    ${count}
    ${feedtitle}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${item}]/title
         IF    "${feedtitle}" in "@{products}"
                ${feedprice}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${item}]/price
                ${itemurl}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${item}]/link
                ${itemid}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${item}]/id
                ${price}=    Replace String    ${feedprice}    EUR    ${EMPTY}
                ${price}=    Replace String    ${price}    .    ,
                Run Keyword And Continue On Failure    Open Browser    ${itemurl}    headlesschrome
                Run Keyword And Continue On Failure    Wait Until Element Is Visible    (//span[@class='the-price'])[2]
                ${web_price}=    Get Text    (//span[@class='the-price'])[2]
            IF    "${price.strip()}" != "${web_price}"
                ${date}=      Get Current Date      UTC      exclude_millis=yes
                ${datetime} =     Convert Date    ${date}    datetime
                ${currenttime}=    Set Variable    ${datetime.year}${datetime.month}${datetime.day}${datetime.hour}${datetime.minute}${datetime.second}
                Log To Console    "Prices are difference!!"
                Set Cell Value    ${item}    1    ${itemid}
                Set Cell Value    ${item}    2    ${feedtitle}
                Set Cell Value    ${item}    3    ${price.strip()}
                Set Cell Value    ${item}    4    ${web_price}
                Save Workbook     ${currenttime}.xlsx
            END
    Close Browser
    Run Keyword And Continue On Failure    Should be equal    ${price.strip()}    ${web_price}
        END
    END