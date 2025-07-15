# if not two arguments, print usage
if [ "$#" -ne 2 ]; then
    echo "Usage: newVersion.sh <datapack version> <mc_version>"
    exit 1
fi

(cd datapack/minds_memories/ && zip -r "../../MindsMemories v${1} (MC ${2})_dp.zip" .)
(cd resourcepack/minds_memories/ && zip -r "../../MindsMemories v${1} (MC ${2})_rp.zip" .)