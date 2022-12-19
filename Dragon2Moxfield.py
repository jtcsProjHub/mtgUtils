import csv
import os
import time
from datetime import date
import tkinter as tk
from tkinter import filedialog

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
    # Count,Tradelist Count,Name,Edition,Condition,Language,Foil,Tags,Last Modified,Collector Number
    csv_header = ["Count","Tradelist","Name","Edition","Condition","Language","Foil","Tags","Last Modified","Collector Number"]
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
# Count,Tradelist Count,Name,Edition,Condition,Language,Foil,Tags,Last Modified,Collector Number
TRADELIST_COUNT = '0'
CONDITION = 'Near Mint'
TAGS = ''
today = date.today()
last_modified = today.strftime("%m/%d/%y")

try:
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        card_data_all = csv.DictReader(csvfile)
        for card_entry in card_data_all:
            foil = 'Foil' if card_entry["Printing"] == "Foil" else ''
            csvOutputFile.writerow([card_entry["Quantity"], TRADELIST_COUNT, card_entry["Card Name"],\
                card_entry["Set Code"].lower(), CONDITION, card_entry["Language"], foil, TAGS,\
                last_modified, card_entry["Card Number"]])
except (FileExistsError, FileNotFoundError, IOError, csv.Error, KeyError) as e:
    print("Error opening or processing the CSV file.")
    print(e)
    