# Robot Framework Automation - Sauce Demo

Keyword-driven test suite (Robot Framework + SeleniumLibrary) for https://www.saucedemo.com/

## Test cases
1. TC1 - Login with valid credentials, verify Products page
2. TC2 - Login with invalid credentials, verify error message
3. TC3 - Add a product to the cart, verify it is listed in the cart
4. TC4 - Add multiple products, proceed to checkout, verify items and quantities in the summary

Note: Sauce Demo has no quantity editor (each product is added with quantity 1), so TC4 verifies the quantity column shows 1 for every listed item.

## Structure
- `tests/saucedemo_tests.robot` - test cases
- `resources/keywords.robot` - variables and reusable keywords
- `requirements.txt` - dependencies

## Setup
```bash
python -m venv venv
venv\Scripts\activate        # Windows
python -m pip install -r requirements.txt
```
Google Chrome must be installed (Selenium Manager fetches the driver automatically).

## Run
```bash
python -m robot -d results tests/saucedemo_tests.robot
```
Reports: `results/report.html`, `results/log.html`
