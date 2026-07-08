# Leapmotor zu ABRP (A Better Routeplanner)

Dieses Projekt verbindet Deinen Leapmotor automatisch mit ABRP (A Better Routeplanner), um Deine aktuellen Fahrzeugdaten (Ladezustand / SoC, Parkstatus, etc.) für eine genaue Navigation zu nutzen.

**Die Lösung ohne eigenen Server:** Da die kostenlosen GitHub-Actions sehr unzuverlässig für Live-Daten im Minutentakt sind, nutzt dieses Setup das kostenlose Cloud-Hosting von **Render.com**. Das Skript läuft völlig automatisch in der Cloud und aktualisiert Deinen Ladestand zuverlässig alle 5 Minuten.

---

## 🚀 Einrichtung in 2 simplen Schritten

### Schritt 1: Das Skript bei Render starten
Du musst dafür nichts herunterladen und auch keinen eigenen GitHub Account besitzen!

1. Gehe auf **[Render.com](https://render.com/)** und erstelle dir einen kostenlosen Account (oder logge dich ein).
2. Klicke im Dashboard oben rechts auf **"New"** und wähle **"Web Service"**.
3. Wähle **"Public Git repository"** aus und kopiere diesen Link in das Textfeld:
   `https://github.com/kerniger/leapmotor-abrp-sync`
   Klicke dann auf **"Continue"**.
4. Fülle die Einstellungen wie folgt aus:
   - **Name:** beliebig (z.B. `leapmotor-abrp`)
   - **Runtime:** `Python 3`
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `python render_app.py`
   - **Instance Type:** Ganz unten sicherstellen, dass **"Free"** ($0/month) ausgewählt ist.
5. Klappe den Bereich **"Advanced"** (oder Environment Variables) auf und klicke auf **"Add Environment Variable"**. Füge folgende drei Passwörter ein:
   - `LEAPMOTOR_USERNAME` = (Deine E-Mail-Adresse der Leapmotor App)
   - `LEAPMOTOR_PASSWORD` = (Dein Leapmotor Passwort)
   - `ABRP_TOKEN` = (Dein ABRP Telemetry Token. In der ABRP App unter "Live-Daten" -> "Verknüpfen" generieren)
6. Klicke ganz unten auf **"Create Web Service"**.

Render startet nun Dein persönliches Skript. Oben links im Dashboard siehst Du eine URL (z.B. `https://leapmotor-abrp-xyz.onrender.com`). 

### Schritt 2: Den "Schlaf-Modus" austricksen (Wichtig!)
Kostenlose Server bei Render.com schalten sich nach 15 Minuten ab, wenn niemand die Website besucht. Um den 5-Minuten-Takt von ABRP 24/7 am Leben zu erhalten, nutzen wir einen simplen Trick:

1. Kopiere dir die oben genannte URL deines Render-Services.
2. Gehe auf **[UptimeRobot.com](https://uptimerobot.com/)** und erstelle einen kostenlosen Account.
3. Klicke auf **"Add New Monitor"**:
   - **Monitor Type:** `HTTP(s)`
   - **Friendly Name:** `Render Wachhalter`
   - **URL (or IP):** *(Hier die Render URL einfügen)*
   - **Monitoring Interval:** `10 minutes` (oder 5 minutes)
4. Klicke auf **"Create Monitor"**.

**Fertig!** UptimeRobot ruft nun rund um die Uhr automatisch deine Render-URL auf. Das Skript läuft dauerhaft im Hintergrund und schickt Deinen Akkustand alle 5 Minuten live an ABRP.

### Spätere Updates einspielen
Da Du das Repository "Public" verknüpft hast, musst Du Updates manuell anstoßen:
Wenn es neue Funktionen gibt, logge Dich einfach bei Render.com ein, klicke auf Deinen Web Service und drücke oben rechts auf **"Manual Deploy" -> "Deploy latest commit"**.

---

## Sicherheit & Privatsphäre
- **Verschlüsselte Zugangsdaten:** Bei Render liegen Deine Umgebungsvariablen stark verschlüsselt auf Enterprise-Servern. Sie tauchen nie öffentlich im Code auf.
- **Keine Fernsteuerung möglich:** Um Deine Sicherheit zu garantieren, wurden in diesem Skript alle Funktionen zur Fernsteuerung (Auto aufschließen, Klimaanlage starten) aus dem Code **restlos entfernt**. Dieses Skript kann Deine Daten nur **lesen** (Read-Only Prinzip).
- **Zertifikate & API:** Da die Leapmotor-API keinen echten "Nur-Lese"-Login anbietet, nutzt das Skript Deinen regulären Login. Die Zertifikate für den Login holt sich das Skript beim Start automatisch.
- **Haftungsausschluss:** Die Nutzung erfolgt auf eigene Gefahr. Weder der Entwickler dieses Skripts noch die Cloud-Anbieter übernehmen Haftung für gesperrte Accounts oder unerwartetes Verhalten der Leapmotor API.
