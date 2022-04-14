import csv
import json
import time
import re
import tkinter as tk
from tkinter import filedialog
import requests

root = tk.Tk()
root.withdraw()

file_path = filedialog.askopenfilename()

contents = open(file_path, 'r', encoding='ascii').read().splitlines()
print("Read " + str(len(contents)) + " unique entries.")
csvfile = open(str(file_path) + ".csv", 'w', newline='', encoding='ascii')
csvResults = csv.writer(csvfile, delimiter=',')
httpHeaders = {"Content-Type": "application/json"}

# Prepare to write out the DeckBox Inventory CSV format
# Count,Tradelist Count,Name,Foil,Textless,Promo,Signed,Edition,Condition,Language,Card Number
csvHeader = ["Count","Tradelist Count","Name","Foil","Textless","Promo","Signed","Edition","Condition","Language","Card Number"]
tradelistCount = 0
foil = ''
textless = ''
promo = ''
signed = ''
cardCondition = ''
cardLanguage = 'English'
csvResults.writerow(csvHeader)
for cardEntry in contents:
    tokens = []
    delimeters = [" ", "\(", "\)"]
    pair = ["", cardEntry]
    for delimeter in delimeters:
        pair = re.split(delimeter,pair[1], maxsplit=1)
        tokens.append(pair[0].strip())
    tokens.append(pair[1].strip())
    cardQuantity = tokens[0]
    cardName = tokens[1]
    cardSetId = tokens[2].lower()
    cardSetNumber = tokens[3]
    scryfallQuery = json.dumps({'identifiers':[{'name': cardName}, {'set': cardSetId, 'collector_number': cardSetNumber}]})
    r = requests.post('https://api.scryfall.com/cards/collection', headers=httpHeaders, data=scryfallQuery)
    if r.status_code == 200:
        jsonPayload = json.loads(r.text)
        #print(json.dumps(jsonPayload, indent=2))
        
    else:
        print('Error with query for card ' + tokens[1] + '. Returned code ' + str(r.status_code))
    time.sleep(0.1)
