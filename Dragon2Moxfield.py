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
        csvfile = open(str(file_path_and_name) + ".csv", 'w', newline='', encoding='ascii')
    except (FileNotFoundError, IOError, FileExistsError):
        print("Error opening CSV file. Check permissions.")
        return -1

    csv_results = csv.writer(csvfile, delimiter=',')

    # Prepare to write out the Moxfield CSV format
    # Count,Tradelist Count,Name,Edition,Condition,Language,Foil,Tags,Last Modified,Collector Number
    csv_header = ["Count","Tradelist","Count","Name","Edition","Condition","Language","Foil","Tags","Last Modified","Collector Number"]
    csv_results.writerow(csv_header)
    return csv_results

def csv_line_write(card_data, csv_file):
    # Count,Tradelist Count,Name,Edition,Condition,Language,Foil,Tags,Last Modified,Collector Number
    foil = ''
    is_pinned = ''
    signed = ''
    set_uid = ''
    card_condition = 'NM'
    card_language = 'en'
    card_set_code = card_data['cardSetId'].upper()

    csv_file.writerow([card_data['cardQuantity'], card_data['cardName'], foil, is_pinned, signed, set_uid\
        , card_set_code, card_data['cardSetNumber'], card_language, card_condition,'',''])

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
tradelist_count = '0'
condition = 'Near Mint'
language = 'English'
tags = ''
today = date.today()
last_modified = today.strftime("%m/%d/%y")

try:
    with open(file_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            print(row)
except (FileExistsError, FileNotFoundError, IOError, csv.Error) as e:
    print("Error opening or processing the CSV file.")
    print(e)
    