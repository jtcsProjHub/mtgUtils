# mtgUtils
Random utilities for getting data between apps, possibly some Flutter GUI projects to mess around with.

# Python Scripts
The script in the main directory, mtga2csv.py, was made to convert data sets from the inconsistently delimited MTGA format into a CSV file so that it could be imported into other online tools. The driver for this was that the card scanning app I was using (MTG Search) output in this format, but it's basically not used on any of the card organizing sites. So far I don't have any other Python scripts. I'm just continuing to build out that one.

## mtga2csv.py usage
It's not very fancy, since I made it to process a handful of files for myself. The bulk of the fancy things I'm trying to instead build into a Flutter app with an actual UI. I'm also using the Dragon Shield app for scanning now anyway, and it is much better so the need for this script has mainly been overcome by events.

Since the MTG Search app doesn't do anything to try and select the correct set or printing, the data from it is almost always incorrect. This program allows you to try and clean it up to at least the correct set code (correct printing would require image data that it of course doesn't have).

Before launching, check the file _set_prefs.json_ to make sure that either your set code preferences are entered into the JSON list or that it is cleared if you don't want to attempt any forced set specifications. If it is populated, the program will query Scryfall for each entry to see if a card with that name exists within the sets specified. If it does and the existing set code doesn't match, it will change the set code to the newest printing among the supplied set codes. Otherwise if the file is blank, it will just keep everything as-is.

When you launch the script, a TK file dialog window will open for you to select your MTGA file from. Once you click 'open' the script will chug away and populate the CSV file in the DeckStats format, which has the following headers and general format:

'''
amount,card_name,is_foil,is_pinned,is_signed,set_id,set_code,collector_number,language,condition,comment,added
4,Abzan Charm,,,,,KTK,161,en,NM,,
1,Abzan Falconer,,,,,KTK,2,en,NM,,
1,Academy Ruins,,,,,2XM,,,,,
'''

It will assume the language is english and everything is in NM condition.