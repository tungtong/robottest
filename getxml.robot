*** Settings ***
Library   SeleniumLibrary
Library    XML
Library    RequestsLibrary
Library    collections
Library    os
Library    String

*** Variables ***
${baseurl}    https://livekaarten.nl
@{products}=    Xbox Live Gold 12 months EU    Microsoft Office Pro Plus 2021 - 1 user PC    Playstation Network Card - Denmark DKK 400, Windows 10 Pro (32-64bit OEM)    Xbox Live Gold 3 months EU

*** Test Cases ***
Get XML from site
    Create Session    mysession    ${baseurl}
    ${response}=    GET On Session    mysession    /shoppingfeed/custom/google
    ${xmlstring}=    Convert To String    ${response.content}
    ${xml_obj}=    Parse Xml    ${xmlstring}
    ${count}=    XML.Get Element Count    ${xml_obj}    .//channel/item
   # FOR    ${sample}    IN    @{products}
   #     FOR    ${item}    IN RANGE    1    ${count}
   #         ${feedprice}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${item}]/title
   #         Run Keyword If    "${sample}" == "${feedprice}"
   #         ...    Should Be Equal    1    5
   #     END
   # END
    FOR    ${item}    IN RANGE    1    ${count}
    ${feedprice}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${item}]/title
        Run Keyword If    "${feedprice}" in "${products}"
        ...     Run Keyword And Continue On Failure    Should Be Equal    1    5
        Log Many    ${feedprice}   ${products}
    END
   # FOR    ${i}    IN RANGE    1    5
   # ${feedprice}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${i}]/title
   # FOR    ${product}    IN    @{products}
   # TRY
   #     WHILE    '${feedprice}' == '${product}'
   #          Log    'test'
   #     END    
   # EXCEPT
   #     Log    Fail
   # END
   #     
   # END
    

    #product
    #FOR    ${i}    IN RANGE    1    5
    #${feedprice}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${i}]/price
    #${itemurl}=    XML.Get Element Text    ${xml_obj}    .//channel/item[${i}]/link
    #${price}=    Replace String    ${feedprice}    EUR    ${EMPTY}
    #${price}=    Replace String    ${price}    .    ,
    ## Log    ${price.strip()}
    ## Log    ${itemurl}
    #Open Browser    ${itemurl}    headlesschrome 
    #Wait Until Element Is Visible    (//span[@class='the-price'])[2]
    #${web_price}=    Get Text    (//span[@class='the-price'])[2]
    #Should Be Equal    $#{price.strip()}    ${web_price}
    #Close Browser
    #END
    
    #s${child_elements}=    Get Child Elements    ${xml_obj}    .//channel/item
    #s${i}=    Create List
    #sFOR    ${item}    IN    @{item}
    #s     Append To List    ${i}    ${item}
    #sLog Many    ${i}`
    #s#Should Not Be Empty    ${child_elements}
    #s#${title}=    Get Element Text    ${child_elements[i]}
    #sEND