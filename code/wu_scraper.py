#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 00:53:02 2020

@author: benschenck
"""

import numpy as np
import pandas as pd
import requests
import datetime
from bs4 import BeautifulSoup

#Selection of PWS's in Charlottesville
pwsIDs = [105, 171, 111, 136, 112, 80, 106, 176, 134, 8]

#All dates between specified range
dates = []
start =  datetime.date(2020, 1, 1)
end = datetime.date(2020, 2,22)
current = start
while current <= end:
    dates.append(str(current))
    current += datetime.timedelta(days=1)
    
    
#A sample to get dataframe format to later append to.
url = "https://www.wunderground.com/dashboard/pws/KVACHARL105/table/2019-01-01/2019-01-01/daily"
html = requests.get(url)    
soup = BeautifulSoup(html.text, 'html')
table = soup.find_all('table')[3]  # The third table on the page is the one we want
df = pd.read_html(str(table))[0]
df["date"] = np.NaN
df["pws"] = np.NaN
df = df[:1]  #only returning the first NaN row to set columns for appending, will later be dropped

#The Algorithm
for date in dates:
    for pws in pwsIDs:
        url = "https://www.wunderground.com/dashboard/pws/KVACHARL" + str(pws) + "/table/" + date + "/" + date + "/daily"
        html = requests.get(url)
        soup = BeautifulSoup(html.text, 'html')
        try:    #if table is not there, there is no data
            table = soup.find_all('table')[3]
            tempDF = pd.read_html(str(table))[0]
            tempDF["date"] = date
            tempDF["pws"] = pws
            df = df.append(tempDF)
            print(date)
        except IndexError:  
            continue       #will skip the day instead of throwing error

#Dropping the first row of each (the ones with all NaN's)    
df = df.dropna(subset=['Time']) 
df.to_csv(str(start)+','+str(end)+'.csv')