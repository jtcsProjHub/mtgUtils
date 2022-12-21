import csv
import os
import tkinter as tk
from tkinter import filedialog
import time
import requests
from requests_toolbelt.utils import dump

# Get name from set code and collector number
# Used to correct the annoying name modification that DS does to tokens
# that Moxfield doesn't accept/understand. It works better than my naive method
def get_name_from_e_and_cn(edition, collector_num):
    # Make sure that we're rate limiting ourselves. Putting the sleep at the top of all functions that perform API requests
    time.sleep(0.1)
    request_params = {'q': 'e:' + edition + ' cn:' + collector_num}
    response = requests.get('https://api.scryfall.com/cards/search', params=request_params)
    if response.status_code != 200:
        data = dump.dump_all(response)
        print(data.decode('utf-8'))
        return []
    response_json = response.json()
    card_name = response_json["data"][0]["name"]
    return card_name

# Opens up a CSV file in the same path and name as what's passed into it.
# Tacks on a .csv extension for good measure.
def prep_csv_file(file_path_and_name):
    try:
        csvfile = open(str(file_path_and_name) + "_moxfield.csv", 'w', newline='', encoding='utf-8')
    except (FileNotFoundError, IOError, FileExistsError):
        print("Error opening CSV file. Check permissions.")
        return -1

    csv_results = csv.writer(csvfile, delimiter=',')

    # Prepare to write out the Moxfield CSV format
    # "Count","Name","Edition","Condition","Language","Foil","Collector Number"
    csv_header = ["Count","Name","Edition","Condition","Language","Foil","Collector Number"]
    csv_results.writerow(csv_header)
    return csv_results

# Open the reference file from disk. This is intended to be a Dragon Shield
# CSV formatted text file, but no checks are done here.
root = tk.Tk()
root.withdraw()
file_path = filedialog.askopenfilename()
csvOutputFile = prep_csv_file(file_path)
if csvOutputFile == -1:
    os._exit(0)

# Look through each of the lines in the file and rearrange the data for the output file
# "Count","Name","Edition","Condition","Language","Foil","Collector Number"
CONDITION = 'Near Mint'
num_entries_processed = 0
TOKEN_STRING = 'Token'

try:
    with open(file_path, encoding='utf-8') as csvfile:
        card_data_all = csv.DictReader(csvfile)
        rows = list(card_data_all)
        totalrows = len(rows)
        print("Read in " + str(totalrows) + " entries.")
        for card_entry in rows:
            # Correct the for the difference in how DS and Mox handle foil designation
            FOIL = 'Foil' if card_entry["Printing"] == "Foil" else ''

            # If it's a token, DS adds Token and sometimes some other designators to
            # the name that isn't compatible with Mox (or anywhere else). For some
            # reason, this method still isn't 100% for Mox, but it's the best I've
            # tried so far. Amusingly I can add the problematic ones manually to Mox
            # using the exact same search string I use here, and there is no discernable
            # difference in name between their search and my file.
            if card_entry["Card Name"].find(TOKEN_STRING) != -1:
                cleaned_up_name = get_name_from_e_and_cn(card_entry["Set Code"], card_entry["Card Number"])
                card_entry["Card Name"] = cleaned_up_name if len(cleaned_up_name) > 0 else card_entry["Card Name"]

            # Output our new Mox-compatible entry
            csvOutputFile.writerow([card_entry["Quantity"], card_entry["Card Name"],\
                card_entry["Set Code"].lower(), CONDITION, card_entry["Language"], FOIL,\
                card_entry["Card Number"]])
            num_entries_processed = num_entries_processed + 1
except (FileExistsError, FileNotFoundError, IOError, csv.Error, KeyError) as e:
    print("Error opening or processing the CSV file.")
    print(e)

print("Processed " + str(num_entries_processed) + " entries.")
