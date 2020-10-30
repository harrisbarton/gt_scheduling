from bs4 import BeautifulSoup
import requests
import json


class Course:
    def __init__(self, course=0, subject=0, term=0):
        self.course = course
        self.subject = subject
        self.section = 0
        self.start = 0
        self.end = 0
        self.professor = ""
        self.prof_gpa = 0
        self.prof_w = 0
        self.avg_gpa = 0
        self.gpa_deviation = 0
        self.skedge_score = 0
        self.days = 0
        self.location = 0
        self.term = term
        self.rmp_score = 0
        self.cios_score = 0

    def summarize(self):
        return [self.subject, self.course, self.section, self.professor, self.rmp_score, self.prof_gpa, self.cios_score]

    def get_crit_avg_gpa(self):
        req = requests.get(
            "https://critique.gatech.edu/course.php?id={sub}%20{cour}".format(sub=self.subject, cour=self.course))
        soup = BeautifulSoup(req.text, 'html.parser')
        self.avg_gpa = float(soup.select("body > div > div.row > div > table > tbody > tr > td:nth-child(2)")[0].text)

    @staticmethod
    def reverse_prof(professor):
        last_first = professor.split(" ", 1)
        return last_first[1] + ", " + last_first[0]

    def get_crit_prof_gpa(self):
        professor = self.professor
        prof_reversed = self.reverse_prof(professor)
        req = requests.get(
            "https://critique.gatech.edu/course.php?id={sub}%20{cour}".format(sub=self.subject, cour=self.course))
        soup = BeautifulSoup(req.text, 'html.parser')
        prof = None
        for item in soup.find_all("a"):
            if prof_reversed in item.text:
                prof = item
                break
        if prof is not None:
            prof_table = prof.findParent("td")
            siblings = prof_table.find_next_siblings("td")
            prof_gpa = siblings[1].text
            prof_w = siblings[7].text
            self.prof_gpa = float(prof_gpa)
            self.prof_w = int(prof_w)

    def set_rate_my_professor(self):
        with open("data.json", 'r') as file:
            data = json.load(file)
            try:
                score = data[self.professor]
            except KeyError:
                score = 0
            self.rmp_score = float(score)

    def cios_finder(self):
        with open("cios.json", 'r') as file:
            data = json.load(file)
            data = data[str(self.subject + self.course)]
            filtered = list(filter(lambda temp: temp['professor'] == self.professor, data))
            rating_temp = 0
            if len(filtered) != 0:
                for prof in filtered:
                    rating_temp += prof['rating']
                self.cios_score = rating_temp / len(filtered)
            else:
                self.cios_score = rating_temp


def get_oscar(term, subject, course):
    subject = subject.upper()
    data = [
        ('term_in', term),
        ('subj_in', subject),
        ('crse_in', course),
        ('schd_in', '%')
    ]
    response = requests.post('https://oscar.gatech.edu/pls/bprod/bwckctlg.p_disp_listcrse?', data=data)
    soup = BeautifulSoup(response.text, 'html.parser')

    # this is terrible, don't do this in real life.
    tables = soup.findAll("table", {
        'summary': 'This table lists the scheduled meeting times and assigned instructors for this class..'})
    headings = soup.findAll("th", {"class": "ddtitle"})

    course_objects = [Course(0, 0, 0) for i in range(0, len(tables))]
    for k, i in enumerate(tables):
        rows = i.findAll("tr")
        for j in rows:
            elements = j.findAll("td")
            if len(elements) != 0:
                time = elements[1].text.split("-", 1)
                if "TBA" not in time:
                    course_objects[k].start = time[0].strip()
                    course_objects[k].end = time[1].strip()
                else:
                    course_objects[k].start = "REMOVE"
                    course_objects[k].end = "REMOVE"
                course_objects[k].days = elements[2].text
                course_objects[k].location = elements[3].text
                course_objects[k].term = term
                course_objects[k].course = course
                course_objects[k].subject = subject
                index = elements[6].text.find(" (P)")
                names = elements[6].text[:index].split(' ', 2)
                names = [name.strip().title() for name in names]
                course_objects[k].professor = names[0] + " " + names[len(names)-1]
                head = headings[k].find("a")
                classes = head.text
                classes_split = classes.split(" - ", 4)
                course_objects[k].section = classes_split[3].strip()

    # Returns list of professors
    return course_objects


def term_finder() -> list:
    # Hardcoded URL for finding terms.
    url = "https://oscar.gatech.edu/pls/bprod/bwckctlg.p_disp_dyn_ctlg"
    res = None
    try:
        res = requests.get(url)
    except:
        print("Error in finding terms.")
    # Parse with BS4
    soup = BeautifulSoup(res.text, 'html.parser')

    # Create list to return all codes given
    term_list = []
    for x in soup.findAll('option'):
        if x['value'] != 'None' and x.text != 'None' and len(x.text) <= len("Summer 2020"):
            term_list.append([x.text, x['value']])
        else:
            pass
    return term_list


def dept_finder(term_code: str) -> list:
    data = {'cat_term_in': term_code}
    url = 'https://oscar.gatech.edu/pls/bprod/bwckctlg.p_disp_cat_term_date'
    try:
        res = requests.post(url, data=data)
    except requests.exceptions:
        res = None
        print("Error in finding departments.")

    soup = BeautifulSoup(res.text, 'html.parser')

    selector = soup.find('select', {'name': 'sel_subj', 'id': 'subj_id'})
    departments = []
    for option in selector.findAll('option'):
        departments.append(option['value'])

    return departments


def course_finder(term_code, department):
    url = 'https://oscar.gatech.edu/pls/bprod/bwskfcls.P_GetCrse'

    data = [
        ('term_in', term_code),
        ('call_proc_in', 'bwckctlg.p_disp_dyn_ctlg'),
        ('sel_subj', 'dummy'),
        ('sel_subj', department),
        ('sel_levl', 'dummy'),
        ('sel_levl', '%'),
        ('sel_schd', 'dummy'),
        ('sel_schd', '%'),
        ('sel_coll', 'dummy'),
        ('sel_coll', '%'),
        ('sel_divs', 'dummy'),
        ('sel_divs', '%'),
        ('sel_dept', 'dummy'),
        ('sel_dept', '%'),
        ('sel_attr', 'dummy'),
        ('sel_attr', '%'),
        ('sel_crse_strt', ''),
        ('sel_crse_end', ''),
        ('sel_title', ''),
        ('sel_from_cred', ''),
        ('sel_to_cred', ''),
    ]

    response = requests.post('https://oscar.gatech.edu/pls/bprod/bwckctlg.p_display_courses', data=data)

    soup = BeautifulSoup(response.text, 'html.parser')
    course_names = soup.findAll("td", {"class": "nttitle"})
    courses_found = []
    for course in course_names:
        course_num = course.text[len(department) + 1:len(department) + 5]
        if course_num.isdigit():
            if int(course_num) >= 1000:
                courses_found.append(course_num)
    return courses_found


terms = term_finder()
term_code = terms[0][1]
while (True):
    all_courses = []
    dept = input("DEPT: ")
    courses = input("COURSE: ")

    individuals = get_oscar(term_code, dept, courses)
    for individual in individuals:
        individual.get_crit_avg_gpa()
        individual.get_crit_prof_gpa()
        individual.set_rate_my_professor()
        individual.cios_finder()
        all_courses.append(individual)

    all_courses.sort(key=lambda individual: individual.rmp_score, reverse=True)

    for x in all_courses:
        print(x.summarize())
    if input("Quit?").upper() == "Y":
        break
