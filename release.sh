#!/bin/bash

# Helper script to create a properly formatted release tag
# Usage: ./release.sh <datapack version> <mc_version>

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: release.sh <datapack version> <mc_version>"
    echo ""
    echo "Example:"
    echo "  ./release.sh 0.0.2 1.21.11"
    echo ""
    echo "This will create and push tag: v0.0.2-mc1.21.11"
    exit 1
fi

VERSION="$1"
MC_VERSION="$2"

# Validate version format (basic semver: X.Y.Z)
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Datapack version must be in semver format (e.g., 0.0.2)"
    echo "Provided: $VERSION"
    exit 1
fi

# Validate MC version is not empty
if [ -z "$MC_VERSION" ]; then
    echo "Error: Minecraft version cannot be empty"
    exit 1
fi

TAG="v${VERSION}-mc${MC_VERSION}"

echo "======================================================================"
echo "Creating Release Tag"
echo "======================================================================"
echo ""
echo "Datapack Version: $VERSION"
echo "Minecraft Version: $MC_VERSION"
echo "Tag: $TAG"
echo ""

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "Error: Tag '$TAG' already exists"
    echo ""
    echo "To delete the existing tag locally and remotely, run:"
    echo "  git tag -d $TAG"
    echo "  git push origin :refs/tags/$TAG"
    exit 1
fi

# Create annotated tag
echo "Creating tag..."
git tag -a "$TAG" -m "Release v${VERSION} for Minecraft ${MC_VERSION}"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create tag"
    exit 1
fi

echo "✓ Tag created successfully"
echo ""

# Ask if tag should be pushed
read -p "Push tag to origin? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Tag created locally but not pushed."
    echo "To push later, run: git push origin $TAG"
    echo "To delete the local tag, run: git tag -d $TAG"
    exit 0
fi

# Push tag to origin
echo ""
echo "Pushing tag to origin..."
git push origin "$TAG"

if [ $? -ne 0 ]; then
    echo "Error: Failed to push tag"
    echo "To delete the local tag, run: git tag -d $TAG"
    exit 1
fi

echo "✓ Tag pushed successfully"
echo ""
echo "======================================================================"
echo "✓ Done! GitHub Actions will now build and create the release."
echo "======================================================================"
echo ""
echo "View the release workflow at:"
echo "  https://github.com/Faustvii/minds_packs/actions"
