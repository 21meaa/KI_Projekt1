Um der Datei "SMSSpamCollection.arff" einige Features (Attribute) hinzuzufügen, einfach das Skript "addFeatures.sh" in dem Verzeichnis ausführen, in dem erstere Datei liegt. Alternativ können die Befehle aus dem Shell Skript auch manuell ausgeführt werden.

Anschließend kann die Datei "SMSSpamCollection6.arff", in der alle Features hinzugefügt sind, in Weka geöffnet werden. Dabei ist zu beachten, die richtige Target Class ("Class: class (Nom)") auszuwählen.
Außerdem muss das Attribut "text" entfernt werden, da ansonsten u.U. kein Modell unter "Classify" erstellt werden kann.

Wenn unter "Classify" nun ein Modell erstellt werden soll, muss auch hier wieder die richtige Target Class ausgewählt werden. Mit dem Algorithmus J48 sollte der F-Wert ca. 0.98 betragen.

TODO:
- Andere Algorithmen in Weka testen
- Evtl. mehr Features hinzufügen
- Dokumentation schreiben
