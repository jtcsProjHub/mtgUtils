# Main System Contexts
In contrast to the example given from the [Repository Pattern](https://davidserrano.io/data-layer-in-flutter-use-the-repository-pattern-to-keep-a-local-copy-of-your-api-data) example that I found online, this example more follows a "waterfall" type of model. The preference for data access is overwhelmingly in favor of local data access and search. In fact, the main intent of this application is to deck build and explore your personal collection, as opposed to digging through the wide world of full magic card collections. That really leaves us a few main working contexts for the system.

## Passionately Casual MTG Player
When looking around at deck building tools, a trend that I found was that they didn't accommodate my use case. You were either entering in your collection so that you could put them up for sale, or you were deck building using the entirety of all cards legal for your format. The tools then of course tell you how you can buy all of those cards. The closest I've seen a tool come to utilizing your own personal collection was [Moxfield](https://moxfield.com/), which at least says "hey BTW you own these". They've actually even gotten a little better by saying, "...and these you own but it's a different printing than you selected for this deck." 

But you can't search strictly against your own collection, and some of the search options are limited when compared to the now deprecated and poorly functioning standalone tool that I have - Magic Assistant. No, not that one. Or the other one that Google will show you.

So anyway, this tool is for someone like me who has 1000's of cards and is like, "come on, there has to be some solid decks I can make out of these that are at least pretty fun".

```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

Person(user, "Passionately Casual MTG Player")

System_Boundary(context, "Default Service") {   
    Component(controller, "MTG Collection Manager", "Flutter Desktop App", "Supports all necessary components and workflows") {
    }  
    
    Component(handler, "Query Handler", "Translation, Source Management, DB Syncing", "Triggered by receiving a card query.") {
    } 
            
    ComponentDb(db, "Databases", "sqflite")
}

System_Ext(scryfall, "Scryfall"){
}

AddRelTag("eventing", $lineStyle = DashedLine())

BiRel(controller, handler, "Data Query and Response")
BiRel(handler, db, "Data Query and Response")

Rel(user, controller, "Card Query", "UI Input")
Rel(scryfall, handler, "API Request", "REST")

SHOW_LEGEND()

@enduml
```

## Front-end Application
This is the first layer that the User will interact with. There are a few major components to the tool that they will be interested in, but generally speaking it will support the following workflows:

* Collection viewing and sorting
* Deck building
* Card importing
* Card exporting

## Local Database Store
I can't tell you how much I don't want this to require constant Internet connectivity. Obviously you'll need it when grabbing data on something new to the system. But for anything that I pre-existing in your collection that you already imported? Don't bother. Just grab the local data. It's what you'll be primarily searching through anyway.

## Scryfall API
The source of all of our data. This will be used primarily when we import data, but can also be used in deck building activities.
