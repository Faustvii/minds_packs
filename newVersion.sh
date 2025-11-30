# if not two arguments, print usage
if [ "$#" -ne 2 ]; then
    echo "Usage: newVersion.sh <datapack version> <mc_version>"
    exit 1
fi

(cd minds_resourcepack/ && zip -r "../MindsResources_v${1}_(MC ${2})_rp.zip" pack.mcmeta pack.png assets)
(cd minds_advancements/ && zip -r "../MindsAdvancements_v${1}_(MC ${2})_dp.zip" pack.mcmeta data)
(cd minds_memories/ && zip -r "../MindsMemories_v${1}_(MC ${2})_dp.zip" pack.mcmeta data)
(cd minds_ghasts/ && zip -r "../MindsGhasts_v${1}_(MC ${2})_dp.zip" pack.mcmeta data)
(cd deepcutting/ && zip -r "../MindsDeepcutting_v${1}_(MC ${2})_dp.zip" pack.mcmeta data)
