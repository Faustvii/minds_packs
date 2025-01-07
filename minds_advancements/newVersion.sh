# if not two arguments, print usage
if [ "$#" -ne 2 ]; then
    echo "Usage: newVersion.sh <datapack version> <mc_version>"
    exit 1
fi
zip -r "Mindsvancements v${1} (MC ${2}).zip" pack.mcmeta data