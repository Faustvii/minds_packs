# if not two arguments, print usage
if [ "$#" -ne 2 ]; then
    echo "Usage: newVersion.sh <datapack version> <mc_version>"
    exit 1
fi
zip -r "MindsMemories v${1} (MC ${2})_rp.zip" pack.mcmeta data
zip -r "MindsMemories v${1} (MC ${2})_dp.zip" pack.mcmeta assets