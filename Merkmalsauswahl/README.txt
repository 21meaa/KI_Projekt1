So wird der Datensatz in Weka verarbeitet:

- Die Datei "SMSSpamCollection_complete.arff" in Weka öffnen, diese enthält ALLE Attribute. Die Dateien SMSSpamCollection{2-9}.arff sind nur Zwischenergebnisse, die das Skript "addFeatures.sh" erzeugt.

- Das Attribut "text" entfernen (Checkbox auswählen -> Remove)

- Über den "Resample" Filter (Choose -> filters -> unsupervised -> instance -> Resample) einen Trainingsdatensatz erstellen:
    - In den Filteroptionen die Option "noReplacement" auf true setzen
    - Die Option "sampleSizePercent" auf z.B. 10.0 ändern
    - Den Filter anwenden (es sollten jetzt 557 Instanzen angezeigt werden)
    - Über "Save..." eine neue Datei anlegen, z.B. mit dem Namen "SMSSpamCollection_complete_dev.arff"
    - Über "Undo" die Filteraktion rückgängig machen
    - Die Filteroption "invertSelection" auf true setzen
    - Den Filter anwenden (es sollten jetzt 5017 Instanzen angezeigt werden)
    - Das Ergebnis des Filters muss nicht zwingend als Datei gespeichert werden, es kann direkt mit dem nächsten Schritt fortgefahren werden

- Auf "Classify" klicken

- Einen Classifier auswählen

- Den Trainingsdatensatz über "Supplied test set" öffnen (die Datei öffnen die in Schritt 3 angelegt wurde)

- Mit "Start" das Modell erstellen
