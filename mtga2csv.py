import csv
import json
import os
import re
import time
from datetime import datetime
import tkinter as tk
from tkinter import filedialog
import requests
from requests_toolbelt.utils import dump

# Opens up a CSV file in the same path and name as what's passed into it.
# Tacks on a .csv extension for good measure.
def prepCsvFile(filePathAndName):
    try:
        csvfile = open(str(filePathAndName) + ".csv", 'w', newline='', encoding='ascii')
    except:
        print("Error opening CSV file. Check permissions.")
        return -1

    csvResults = csv.writer(csvfile, delimiter=',')

    # Prepare to write out the DeckStats CSV format
    # amount,card_name,is_foil,is_pinned,is_signed,set_id,set_code,collector_number,language,condition,comment,added
    #csvHeader = ["amount","card_name","is_foil","is_pinned","is_signed","set_id","set_code","collector_number","language","condition","comment","added"]
    #Folder Name,Quantity,Trade Quantity,Card Name,Set Code,Set Name,Card Number,Condition,Printing,Language,Price Bought,Date Bought
    csvHeader = ["Folder Name","Quantity","Trade Quantity","Card Name","Set Code","Set Name","Card Number","Condition","Printing","Language","Price Bought","Date Bought"]
    csvResults.writerow(csvHeader)
    return csvResults

# Grab all of the prints of a card with a specific name. Orders them newest to oldest
def get_all_prints_of_name(card_name):
    # Make sure that we're rate limiting ourselves. Putting the sleep at the top of all functions that perform API requests
    time.sleep(0.1)
    request_params = {'unique': 'prints', 'order': 'released', 'include_extras': 'true', 'dir': 'desc', 'q': card_name}
    response = requests.get('https://api.scryfall.com/cards/search', params=request_params)
    if response.status_code != 200:
        data = dump.dump_all(response)
        print(data.decode('utf-8'))
        return []
    response_json = response.json()
    return response_json["data"]

def csvLineWrite(cardData, csvFile):
    # amount,card_name,is_foil,is_pinned,is_signed,set_id,set_code,collector_number,language,condition,comment,added
    # cardData = {'cardQuantity': '', 'cardName': '', 'cardSetId': '', 'cardSetNumber': ''}
    foil = ''
    is_pinned = ''
    signed = ''
    setUID = ''
    cardCondition = 'NM'
    cardLanguage = 'en'
    cardSetCode = cardData['cardSetId'].upper()
    if cardSetCode not in setPrefs:
        # Looks through all of the prints of a card with the specified name to find the one with the correct printing
        card_list = get_all_prints_of_name(card_name=cardData['cardName'])
        
        # Iterate through the cards, newest to oldest
        for card in card_list:
            if card["set"].upper() in setPrefs:
                print("Found correction for " + cardData['cardName'] + ". Changing from " + cardSetCode + " to " + card["set"].upper())
                cardSetCode = card["set"].upper()
                cardData['cardSetNumber'] = card["collector_number"]
                break

    csvFile.writerow([cardData['cardQuantity'], cardData['cardName'], foil, is_pinned, signed, setUID\
        , cardSetCode, cardData['cardSetNumber'], cardLanguage, cardCondition,'',''])

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
        setPrefs = [x.upper() for x in setPrefs]
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
