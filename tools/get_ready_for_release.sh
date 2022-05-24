#!/bin/bash
# Ensures that the package is ready for a release.
# 
# Will update the version.dart file and update the CHANGELOG.md.
#
# Run in current directory
# `./get_ready_for_release.sh`
#
# Try and run in given directory
# `./get_ready_for_release.sh /path/to/package`

# Move into given directory if a param was given.
if [ "$1" != "" ]; then
    cd "$1"
fi

# Check if current directory has a pubspec.yaml, if so we assume it is correctly set up.
if [ ! -f "pubspec.yaml" ]; then
    echo "$(pwd) is not a valid package, missing pubspec.yaml."
    if [ "$1" != "" ]; then
        cd - > /dev/null
    fi
    exit 1
fi

# Update dart file with new version.
dart run build_runner build --delete-conflicting-outputs

# Generate a package.json with name and version for the conventional-changelog tool.
package_version=$(dart pub deps --json | pcregrep -o1 -i '"version": "(.*?)"' | head -1)
package_name=$(dart pub deps --json | pcregrep -o1 -i '"name": "(.*?)"' | head -1)
echo '{"version": "'$package_version'", "name": "'$package_name'"}' > package.json

# Add a # to the previous version to ensure proper title hierachy.
echo -e "#$(cat CHANGELOG.md)" > CHANGELOG.md

# Generate new CHANGELOG.md
conventional-changelog -p angular -i CHANGELOG.md -s
rm package.json

echo "CHANGELOG for $package_name v$package_version generated, verify it here: $(pwd)/CHANGELOG.md"

if [ "$1" != "" ]; then
    cd - > /dev/null
fi
