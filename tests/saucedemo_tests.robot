*** Settings ***
Documentation    Sauce Demo login, cart, and checkout tests.
Resource         ../resources/keywords.robot
Test Setup       Open Application
Test Teardown    Close Application

*** Test Cases ***
TC1 Login With Valid Credentials
    [Documentation]    Valid login lands on the Products page.
    [Tags]    login    smoke
    Login With Credentials    ${VALID_USER}    ${VALID_PASS}
    Verify Products Page

TC2 Login With Invalid Credentials
    [Documentation]    Invalid login shows an error and stays on the login page.
    [Tags]    login    negative
    Login With Credentials    ${INVALID_USER}    ${INVALID_PASS}
    Verify Login Error        ${LOGIN_ERROR_TEXT}

TC3 Add Product To Cart And Verify
    [Documentation]    One product added to the cart appears in the cart.
    [Tags]    cart
    Login As Valid User
    Add Product To Cart       ${PRODUCT_1_BTN}
    Open Cart
    Verify Cart Item Count    1
    Verify Product In Cart    ${PRODUCT_1}

TC4 Checkout Summary Lists Correct Items
    [Documentation]    Two products added; the checkout overview lists both with quantity 1.
    [Tags]    checkout
    Login As Valid User
    Add Product To Cart       ${PRODUCT_1_BTN}
    Add Product To Cart       ${PRODUCT_2_BTN}
    Open Cart
    Proceed To Checkout
    Verify Cart Item Count    2
    Verify Product In Cart    ${PRODUCT_1}
    Verify Product In Cart    ${PRODUCT_2}
    Verify All Quantities Are One
