#!/usr/bin/env bash

# Script to deploy from Github to WordPress.org Plugin Repository
# A modification of Ben Balter's deploy script as found here: https://github.com/benbalter/Github-to-WordPress-Plugin-Directory-Deployment-Script
# The difference is that this script works with Scatter: https://github.com/evansolomon/scatter/

# WordPress.org username
if [ -z "$WPORG_USER" ]; then
    echo "You need to set the \$WPORG_USER environment variable"
    echo "Try adding something like \`export WPORG_USER=myusername\` to your shell profile"
    exit 1
fi

# Setup plugin details
PLUGINPATH=$1
PLUGINSLUG=$(basename $PLUGINPATH | sed 's/^wp-//g')
MAINFILE=$2

cd $PLUGINPATH

# Make sure the repo is clean
git fetch --all
if [[ $(git status --porcelain) != "" ]]
then
  echo "Dirty branch, exiting"
  exit 1
fi

# Default main file
if [[ $MAINFILE == "" ]]
then
  MAINFILE=$(ack "^Plugin Name:" -l | xargs ack "^Version:" -l)
  if [[ $MAINFILE == "" ]]
  then
    echo "Could not find the main plugin file, exiting..."
    exit 1
  fi
fi

# Version control settings
SVNPATH="/tmp/wp-svn-$PLUGINSLUG"                      # Path to a temp SVN repo
rm -fr $SVNPATH/                                       # Just in case
SVNURL="http://plugins.svn.wordpress.org/$PLUGINSLUG/" # Remote SVN repo on WordPress.org

# Let's begin...
echo ".........................................."
echo
echo "Preparing to deploy WordPress plugin"
echo
echo ".........................................."
echo

# Check version in readme.txt is the same as plugin file
README_VERSION=`grep "^Stable tag" $PLUGINPATH/readme.txt | awk -F' ' '{print $3}'`
echo "readme version: $README_VERSION"
HEADER_VERSION=`grep "^Version" $PLUGINPATH/$MAINFILE | awk -F' ' '{print $2}'`
echo "$MAINFILE version: $HEADER_VERSION"

# Bail if they don't match
if [ "$README_VERSION" != "$HEADER_VERSION" ]; then echo "Versions don't match. Exiting...."; exit 1; fi

echo "Versions match in readme.txt and PHP file. Let's proceed..."

# Make sure the tag doesn't already exist in Git
if git show-ref --tags --quiet --verify -- "refs/tags/$README_VERSION"
  then
    echo "Version $README_VERSION already exists as git tag. Exiting...."
    exit 1
  else
    echo "Git version does not exist. Let's proceed..."
fi

# Tag the new version in Git
echo "Tagging new version in git"
git tag -a "$README_VERSION" -m "Tagging version $README_VERSION"

echo "Pushing tags to origin"
git push origin master --tags

# Checkout the SVN repo
echo
echo "Creating local copy of SVN repo ..."
svn co $SVNURL $SVNPATH

# Remove Git-only files from SVN
echo "Ignoring github specific files and deployment script"
svn propset svn:ignore ".git .gitignore" "$SVNPATH/trunk/"

# Reset files so that we can find all changes
rm -rf $SVNPATH/trunk/*

# Export Git -> SVN
echo "Exporting the HEAD of master from git to the trunk of SVN"
cp -r . $SVNPATH/trunk/

# If submodule exist, recursively check out their indexes
if [ -f ".gitmodules" ]
then
echo "Exporting the HEAD of each submodule from git to the trunk of SVN"
git submodule init
git submodule update
git submodule foreach --recursive 'git checkout-index -a -f --prefix=$SVNPATH/trunk/$path/'
fi

# Go to SVN directory
echo "Changing directory to SVN and committing to trunk"
cd $SVNPATH/trunk/

# Make sure SVN tag doesn't exist yet
if [ -d "tags/$README_VERSION/" ]; then
  echo "The $README_VERSION tag already exists in SVN, exiting..."
  exit 1
fi

# svn rm deleted files
svn st | grep "^\!" | awk '{print $2}' | xargs svn rm

# Add all new files that are not set to be ignored
svn status | grep -v "^.[ \t]*\..*" | grep "^?" | awk '{print $2}' | xargs svn add

# Commit to SVN
svn commit --username=$WPORG_USER -m "Publishing version: $README_VERSION"
echo "Creating new SVN tag & committing it"
cd $SVNPATH
svn copy trunk/ tags/$README_VERSION/
cd $SVNPATH/tags/$README_VERSION
svn commit --username=$WPORG_USER -m "Tagging version $README_VERSION"

# Cleanup after ourselves
echo "Removing temporary directory $SVNPATH"
rm -rf $SVNPATH/

echo "*** FIN ***"
