from selenium import webdriver
from selenium import common
from bs4 import BeautifulSoup
import json

def check_link_load():
    try:
        driver.find_element_by_id("_ctl0_masterBody")
    except common.exceptions.NoSuchElementException:
        pass
    finally:
        return True

def download_pages(username, password):
    driver = webdriver.Chrome(executable_path="./chromedriver.exe")
    driver.get("https://gatech.smartevals.com")

    driver.find_element_by_id("username").send_keys(username)
    driver.find_element_by_id("password").send_keys(password)
    driver.find_element_by_class_name("btn-submit").click()
    driver.implicitly_wait(5)

    driver.switch_to.frame(driver.find_element_by_id("duo_iframe"))
    driver.find_element_by_xpath("//*[@id=\"auth_methods\"]/fieldset/div[1]/button").click()
    driver.switch_to.default_content()
    while not check_link_load():
        pass
    driver.find_element_by_id("lnkSeeResultsImg").click()
    driver.implicitly_wait(10)
    driver.switch_to.default_content()

    driver.get("https://wwwh3.smartevals.com/Reporting/Students/Results.aspx?Type=Instructors&ShowAll=Chosen")

    driver.switch_to.default_content()
    nav_buttons = driver.find_elements_by_id("dxp-num")
    for x in range(0, 1):
        driver.execute_script("ASPx.GVPagerOnClick('_ctl0_cphContent_grd1','PN" + str(x + 1) + "');")
        with open("file" + str(x) + ".html", 'w') as file:
            file.write(driver.page_source)

course_dict = {}

for x in range(0,458):
    with open("file"+str(x)+".html") as file:
        soup = BeautifulSoup(file, 'html.parser')
        table = soup.find('table', {'id':'_ctl0_cphContent_grd1_DXMainTable'})
        table = table.find('tbody')
        rows = table.find_all('tr', recursive=False)
        for row in rows[3:len(rows)-1]:
            cells = row.find_all('td')
            name_reversed = cells[3].text.split(',')
            name = name_reversed[1].strip().capitalize() + " " + name_reversed[0].strip().title()
            course = cells[4].text + cells[5].text
            rating = cells[8].text
            year = cells[0].text
            if rating == " " or rating == "":
                rating = 0.0
            else:
                try:
                    rating = float(rating)
                except:
                    pass
            if course in course_dict:
                course_dict[course].append({'professor':name,'rating':rating,'year':year})
            else:
                course_dict[course] = [{'professor':name,'rating':rating,'year':year}]



with open('cios.json', 'w') as outfile:
    json.dump(course_dict, outfile)