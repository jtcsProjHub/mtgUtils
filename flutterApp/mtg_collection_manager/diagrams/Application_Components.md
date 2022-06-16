# Application Components
As covered in the [context document](Collection_Manager_Context.md), the application supports a few core functions. Many of the functions are just front ends that all utilize the same data interface. The basic application layout is:

```plantuml
@startuml

!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

Person(user, "Passionately Casual MTG Player")

System_Boundary(context, "Flutter Desktop App Components") {   
    System_Boundary(collectionManager, "Collection Manager", "Desktop Application") {
        Component(sortableList, "Card List", "Sortable and scrollable")
        Component(search, "Search Interface", "Unified interface", "Option to include Scryfall results. Database-only by default")
        Component(decks, "Deck Management")
        Component(import, "Card Import Manager", "From CSV or MTGA files")
        Component(export, "Card Export Manager", "To CSV or MTGA")
    }
    
    Component(handler, "Query Handler", "Translation, Source Management, DB Syncing", "Triggered by receiving a card query.") {
    } 
            
    ComponentDb(db, "Databases", "sqflite")
}

System_Ext(scryfall, "Scryfall"){
}

AddRelTag("eventing", $lineStyle = DashedLine())

BiRel(handler, db, "Data Query and Response")

Rel(user, collectionManager, "Card Query", "UI Input")
Rel(scryfall, handler, "API Request", "REST")
Rel(decks, search, "")
Rel(sortableList, search, "")
Rel(search, handler, "")
Rel(sortableList, export, "")
Rel(import, handler, "")

SHOW_LEGEND()

@enduml
```
This document will start detailing the main components and how their internals will function. I'll try to follow some reasonable documentation practices and save the class diagrams for supporting documents.

