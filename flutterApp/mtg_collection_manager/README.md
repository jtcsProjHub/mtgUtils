# mtg_collection_manager

This project is based on the data layer pattern outlined in this example: https://davidserrano.io/data-layer-in-flutter-use-the-repository-pattern-to-keep-a-local-copy-of-your-api-data

I understand the basic criticism of it, where you don't necessarily need to have separate, independent classes for each of the layers (network API data, database, and local programs). Sure there are times where you will have different needs for each of these layers, so having different classes for each would be warranted. Especially between the data sources (database and network) and the local program. The most compelling argument can be made for the database and network layers being the same at the least, since the program itself is essentially asking itself if it needs to fetch the data or if it is going to grab it locally. But then again, they're receiving the data in different forms (I know, that can be accommodated with the generated JSON to/from code that the example has you add).

Anyway, I digress. Since the objective of the example is to accomplish what I was looking to do for this project, I figured I'd try it essentially as-is and then see what (if any) optimizations I wanted to make. So what is the objective you ask?

## Project purposes

There are a few things I was looking to get out of this project. First was to play around with developing a desktop application in Flutter, which is a UI language that I really got an appreciation for. As a completely new mobile UI dev, the speed with which I was able to get a complex, multi-screen, reactive app written and fielded for IAM really blew me away. Especially after trying to get going with Ionic, Andoid Native, and React Native prior to that. The learning curve was just so much lower, and setup was quick and easy. So the prospect of using the same language for desktop was appealing. So really the primary objective is to be a learning tool and a figdet. I'm not even particular about whether or not I 100% finish or not.

Second was to make a better, more modern program for searching and managing my Magic card collection. There are plenty of online tools that are _really_ great at deck building, but from what I've seen across all of these tools is that deck building and collection management are viewed as two separate functions. You deck build searching through all cards that are legal in your format. When you're done you get a final report on what you already own, which is very version specific. Have a copy of something from Time Spiral Remastered but inserted the one from Time Spiral? Then looks like you don't own it. Sorry.

Then for collection management, it's viewed purely from a buy/sell trading card standpoint. The focus is on price lists with minimal sorting, filtering, and statistics gathering. Heck, you can't even filter by set for most of these sites. Moxfield was probably one of the best, but none of them matched the old, now unsupported desktop tool that I was using - Magic Assistant from Sourceforge. 

I'd keep using that tool, honestly, if it didn't have two major flaws. (1) Data imports are very difficult since it's so out of date. Especially since the mobile app I use for scanning in my cards outputs data in the modern MTGA format, which isn't a CSV format. See the Python utility in this repository for some details on the annoyances of parsing it.  (2) Some of the guards it seems to have on the card data it pulls from whatever API it uses conflict with existing card names and descriptions. For instance, it rejects the card '+2 Mace' in the AFR set, presumably because it has the special character in the card name. AFR was the worst for this kind of issue, and something like 63 of my cards didn't import.

So here I am, trying to make a new standalone desktop utility where: 
* I can import my card data using a modern format like MTGA
* All necessary card detail data is pulled from a free API like Scryfall
* The data gets stored locally so that I only need network access when performing imports on cards I don't already have
* I can sort and search by all of the different card parameters that I can Magic Assistant, which is any combination of anything
* The deckbuilding feature is more modern, like you see in something like Moxfield

## Getting Started with Flutter

This app is written in Flutter and was a way for me to play around with their desktop app support. I've only done mobile development so this was a good excuse. There are no special setup requirements for building the app outside of what the basic instructions on their site indicate.

If you'd like some beginner info on getting started with the Flutter language, they recommend these resources. Personally I really like the language, coming from a C++/OOP background. It feels very much like C# and I can follow familiar design patterns and program structures.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Additional configurations for this repository

I'll assume that you followed their instructions on setting up a Flutter environment. In addition to that, I happen to use [PlantUML](https://github.com/plantuml-stdlib/C4-PlantUML) for my design diagrams. If you'd like to view them and not just read the Markdown they're embedded in, you'll have to configure your system correctly.

### VS Code setup for PlantUML
* Using VSCode, install the [PlantUML plugin developed by jebbs](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml).  
* Right click the plugin and click "Add to Workspace Recommendations" on the right-click menu.
* Follow the plugin's documentation to install Java and GraphViz
* Right click the plugin and go to the "Extension Settings"
* Set the "Diagram Root" as _diagrams_
* Set "Render" to _PlantUMLServer_
* Set "Server" to _http://www.plantuml.com/plantuml_
* Restart VS Code