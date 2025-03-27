#!/bin/bash
set -euo pipefail

# Search your Sonarr downloads for downloaded files that only have a matching langauge track
#
# USAGE:
# - WARNING: THIS WILL DELETE ALL THE FILES FOUND:
# language_query.sh sonarr.db | tr '\n' '\0' | xargs -0 -n 1 rm -f '{}'
#
# index of Languages
# https://github.com/Sonarr/Sonarr/blob/b103005aa23baffcf95ade6a2fa3b9923cddc167/src/NzbDrone.Core/Languages/Language.cs
# 0 Unknown
# 1 English
# 4 German
# 5 Italian
# -2 Original
#
# index of EventType
# https://github.com/Sonarr/Sonarr/blob/b103005aa23baffcf95ade6a2fa3b9923cddc167/src/NzbDrone.Core/History/EpisodeHistory.cs#L37
# Unknown = 0,
# Grabbed = 1,
# SeriesFolderImported = 2,
# DownloadFolderImported = 3,
# DownloadFailed = 4,
# EpisodeFileDeleted = 5,
# EpisodeFileRenamed = 6,
# DownloadIgnored = 7

DB="${1:-}"
LANG="4"

#
# only one Language present, and it is German (LANG)
# and the file was imported via Download
# return the Series dir Path and File Path
#
sqlite3 -readonly -separator '/' "${DB}" "
SELECT S.Path, EF.RelativePath
FROM History AS H
JOIN Episodes AS E ON H.EpisodeId = E.Id
JOIN Series AS S ON H.SeriesID = S.Id
JOIN EpisodeFiles AS EF ON E.EpisodeFileId = EF.Id
WHERE H.EventType = 3
  AND (SELECT COUNT(*) FROM json_each(H.Languages)) = 1
  AND EXISTS (
    SELECT 1
    FROM json_each(H.Languages)
    WHERE json_each.value = $LANG
  );
"


#
# # one of the Languages is German but it might contain other languages as well
#
# sqlite3 -readonly "${DB}" "
# SELECT Id, EpisodeId, SeriesID, EventType, SourceTitle, Languages
# FROM History
# WHERE EXISTS (
#     SELECT 1
#     FROM json_each(Languages)
#     WHERE json_each.value = $LANG
#   ) AND EventType=3
# ;
# "
