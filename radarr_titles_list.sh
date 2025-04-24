#!/bin/bash

sqlite3 radarr.db 'SELECT Title FROM MovieTranslations WHERE Language = "1";'  | sort -u
