*** Settings ***
Documentation    Reusable keywords and variables for Sauce Demo tests.
Library          SeleniumLibrary
Library          BuiltIn

*** Variables ***
${URL}                  https://www.saucedemo.com/
${BROWSER}              chrome
${TIMEOUT}              10s
${VALID_USER}           standard_user
${VALID_PASS}           secret_sauce
${INVALID_USER}         wrong_user
${INVALID_PASS}         wrong_pass
${FIRST_NAME}           Prafful
${LAST_NAME}            Vats
${POSTAL_CODE}          110001
${PRODUCT_1}            Sauce Labs Backpack
${PRODUCT_1_BTN}        add-to-cart-sauce-labs-backpack
${PRODUCT_2}            Sauce Labs Bike Light
${PRODUCT_2_BTN}        add-to-cart-sauce-labs-bike-light
${LOGIN_ERROR_TEXT}     Username and password do not match
# Disables Chrome's password-manager popups, which can block clicks on this site
${CHROME_OPTIONS}       add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_enabled": False, "profile.password_manager_leak_detection": False})

*** Keywords ***
Open Application
    [Documentation]    Opens Chrome (password popups disabled), maximizes it, and loads Sauce Demo.
    Open Browser    ${URL}    ${BROWSER}    options=${CHROME_OPTIONS}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}
    Wait Until Element Is Visible    id:login-button

Login With Credentials
    [Documentation]    Enters the given username and password and clicks Login.
    [Arguments]    ${user}    ${pass}
    Input Text        id:user-name    ${user}
    Input Password    id:password    ${pass}
    Click Button      id:login-button

Login As Valid User
    [Documentation]    Logs in with the valid standard_user credentials.
    Login With Credentials    ${VALID_USER}    ${VALID_PASS}
    Verify Products Page

Verify Products Page
    [Documentation]    Confirms the user landed on the Products page (URL and page title).
    Wait Until Element Is Visible    css:.title
    Location Should Contain          inventory.html
    Element Text Should Be           css:.title    Products

Verify Login Error
    [Documentation]    Checks that an error banner appears containing the expected text.
    [Arguments]    ${expected}
    Wait Until Element Is Visible    css:[data-test="error"]
    Element Should Contain           css:[data-test="error"]    ${expected}
    # Make sure we were NOT logged in
    ${url}=    Get Location
    Should Not Contain    ${url}    inventory.html

Add Product To Cart
    [Documentation]    Clicks the Add to cart button identified by its element id.
    [Arguments]    ${button_id}
    Click Button    id:${button_id}

Open Cart
    [Documentation]    Clicks the cart icon and verifies the cart page opened.
    Click Link                       css:.shopping_cart_link
    Wait Until Element Is Visible    css:.cart_list
    Location Should Contain          cart.html

Verify Product In Cart
    [Documentation]    Checks that an item with the given name is listed.
    [Arguments]    ${name}
    Page Should Contain Element    xpath://div[@class='inventory_item_name' and normalize-space()='${name}']

Verify Cart Item Count
    [Documentation]    Checks the number of line items listed.
    [Arguments]    ${expected}
    ${count}=    Get Element Count    css:.cart_item
    Should Be Equal As Integers    ${count}    ${expected}

Verify All Quantities Are One
    [Documentation]    Sauce Demo adds one unit per product, so every listed quantity should be 1.
    @{quantities}=    Get WebElements    css:.cart_quantity
    FOR    ${q}    IN    @{quantities}
        Should Be Equal    ${q.text}    1
    END

Proceed To Checkout
    [Documentation]    Clicks Checkout, fills the customer info form, and continues to the overview page.
    Click Button    id:checkout
    Input Text      id:first-name     ${FIRST_NAME}
    Input Text      id:last-name      ${LAST_NAME}
    Input Text      id:postal-code    ${POSTAL_CODE}
    Click Button    id:continue
    Location Should Contain    checkout-step-two.html

Close Application
    [Documentation]    Closes all browser windows.
    Close All Browsers
