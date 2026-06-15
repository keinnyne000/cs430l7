from pathlib import Path
from library_sql_builder import buildAll

PROJECT_ROOT = Path(__file__).resolve().parent.parent
OUTPUT_FILE_PATH=PROJECT_ROOT / "build" / "populateData.sql"

fullSQL = buildAll(dataDir=PROJECT_ROOT / "data")

outputFilePath = Path(OUTPUT_FILE_PATH)
outputFilePath.parent.mkdir(parents=True, exist_ok=True)
with open(outputFilePath, "w", encoding="utf-8") as file:
    file.write(fullSQL)