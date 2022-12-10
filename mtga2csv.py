import csv
import json
import time
import itertools
import os
import re
import tkinter as tk
from tkinter import filedialog
import requests

SetNamesFromIds = {}

# Opens up a CSV file in the same path and name as what's passed into it.
# Tacks on a .csv extension for good measure.
def prepCsvFile(filePathAndName):
    try:
        csvfile = open(str(filePathAndName) + ".csv", 'w', newline='', encoding='ascii')
    except:
        print("Error opening CSV file. Check permissions.")
        return -1
    
    csvResults = csv.writer(csvfile, delimiter=',')
    
    # Prepare to write out the DeckBox Inventory CSV format
    # Count,Tradelist Count,Name,Foil,Textless,Promo,Signed,Edition,Condition,Language,Card Number
    csvHeader = ["Count","Tradelist Count","Name","Foil","Textless","Promo","Signed","Edition","Condition","Language","Card Number"]
    csvResults.writerow(csvHeader)
    return csvResults

# Grab the full set of card details from Scryfall using their API
# It's a bit specific so we make sure that the header is forced to
# indicate that it has a JSON payload
def getFullCardDetails(cardName, setId, cardCollectionId):
    httpHeaders = {"Content-Type": "application/json"}
    scryfallQuery = json.dumps({'identifiers':[{'name': cardName}, {'set': setId, 'collector_number': cardCollectionId}]})
    r = requests.post('https://api.scryfall.com/cards/collection', headers=httpHeaders, data=scryfallQuery)
    time.sleep(0.1)
    if r.status_code == 200:
        jsonPayload = json.loads(r.text)
        #print(json.dumps(jsonPayload, indent=2))
        return jsonPayload
    else:
        print('Error with query for card ' + tokens[1] + '. Returned code ' + str(r.status_code))
        return json.loads("\{\}")
    
def getSetNameFromCode(setCode):
    r = requests.get('https://api.scryfall.com/sets/' + str(setCode))
    time.sleep(0.1)
    if r.status_code == 200:
        jsonPayload = json.loads(r.text)
        if 'name' in jsonPayload:
            setName = jsonPayload['name']
            SetNamesFromIds[setCode] = setName
            return setName
        else:
            print("Error, name not found for set " + setCode + ". Keeping as the set code.")
            return setCode
    else:
        print("Error retrieving set name using code. Received error " + str(r.status_code) + ". Setting name as set code.")

def csvLineWrite(cardData, csvFile):
    # Count,Tradelist Count,Name,Foil,Textless,Promo,Signed,Edition,Condition,Language,Card Number
    # cardData = {'cardQuantity': '', 'cardName': '', 'cardSetId': '', 'cardSetNumber': ''}
    tradelistCount = 0
    foil = ''
    textless = ''
    promo = ''
    signed = ''
    cardCondition = ''
    cardLanguage = 'English'
    setName = cardData['cardSetId']
    
    if cardData['cardSetId'] in SetNamesFromIds:
        setName = SetNamesFromIds[setName]
    else:
        setName = getSetNameFromCode(setName)
    
    csvFile.writerow([cardData['cardQuantity'], tradelistCount, cardData['cardName'],\
    foil, textless, promo,signed, setName, cardCondition, cardLanguage, cardData['cardSetNumber']])

# Open the reference file from disk. This is intended to be an
# MTGA formatted text file, but no checks are done here.
root = tk.Tk()
root.withdraw()
file_path = filedialog.askopenfilename()
try:
    contents = open(file_path, 'r', encoding='ascii').read().splitlines()
except:
    print("Error opening, reading, or parsing the reference file " + file_path)
    os._exit(0)
    
print("Read " + str(len(contents)) + " unique entries.")
csvOutputFile = prepCsvFile(file_path)
if csvOutputFile == -1:
    os._exit(0)
    
# Attempt to open the set_prefs.json file
useSetPrefs = False
try:
    setPrefs = json.loads(open('set_prefs.json', "r").read())
    setPrefs = setPrefs["set_prefs"]
    if len(setPrefs):
        useSetPrefs = True
        print("Using the following set preferences:")
        for setCode in setPrefs:
            print(setCode)
except Exception as e:
    print("File set_prefs.json not found, or the format is invalid. Data will be converted as-is.")
    print(e)
    
# Look through each of the lines in the file and attempt to parse it. The format is
# annoying and doesn't have a specific repeated delineator.
# Example: 1 Tranquil Cove (NEO) 213
# Follows the pattern: <Quantity> <Name> <(Set Code)> <Collection ID>
# Where <Collection ID> is the card number in the set
for cardEntry in contents:
    tokens = {'cardQuantity': '', 'cardName': '', 'cardSetId': '', 'cardSetNumber': ''}
    delimeters = [" ", "\(", "\)"]
    pair = ["", cardEntry]
    for (delimeter, key) in zip(delimeters, tokens):
        pair = re.split(delimeter,pair[1], maxsplit=1)
        tokens[key] = pair[0].strip()
        
    tokens['cardSetNumber'] = pair[1].strip()
    csvLineWrite(tokens, csvOutputFile)    