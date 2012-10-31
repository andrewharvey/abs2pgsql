#!/bin/bash

# This script will repack an ABS DataPack DVD into a .tar.xz. It will also
# produce a CSV-Minimal variant.

# first argument is either,
#   1. path to CDROM directory
#   2. path to already unzipped DataPack

# check correct usage
if [ -z $1 ] ; then
    echo "Usage: $0 </path/to/cdrom>|</path/to/unzipped/datapack>"
    exit
fi

# declare rexz function
function retar () {
    # FIXME: how do I get this to run from within the script keeping while dealing with glob expansion and spaces properly?
    echo "Please run:"
    echo "cd $unzipped_dir"
    echo tar \
        --create \
        --xz \
        --file "$PWD/$full_xz_name" \
        --owner root --group root \
        "$@"

    # check if tar succeeded (can't do this as we don't run tar from within this script)
    #if [ "$?" = 0 ] ; then
    #    echo "Created $full_xz_name"
    #else
    #    echo "Failed to create $full_xz_name"
    #fi

    echo "...then press enter after it has finished."
    read
}

# determine if we have the CDROM or unzipped contents
top_level_zip_files=`ls -1 $1/*.zip 2> /dev/null`
found_zip=$?

if [ $found_zip -eq 0 ] ; then # we found something
    echo "Found a .zip file in $1. Treating this is the CDROM path."

    # extract just the zip basename
    zip_basename=`basename "$top_level_zip_files"`

    case $zip_basename in
        '2011 DataPacks BCP_IP_TSP_Release 1.zip')
            datapack="BCP_IP_TSP.R1"
            ;;
        '2011 DataPacks BCP_IP_TSP_Release 1.1.zip')
            datapack="BCP_IP_TSP.R1.1"
            ;;
        '2011 Datapacks BCP_IP_TSP_Release 2.zip')
            datapack="BCP_IP_TSP.R2"
            ;;
        *)
            echo "Although we found a zip file, $zip_basename isn't recognised."
            exit
            ;;
    esac

    echo "unzipping $zip_basename..."
    unzipped_dir=`mktemp -d datapack-dvd-XXX`
    must_rm_unzipped_dir=yes # set this flag for later removal of this temp dir
    rm -rf $unzipped_dir # need this because unzip will complain if the directory already exists
    unzip "$1/$base" -d $unzipped_dir/

else # didn't find a zip. perhaps this is an unzipped directory?
    if [ -d "$1/Metadata" ] ; then
        echo "Found an unzipped directory"
        unzipped_dir=$1

        if [ -d "$1/2011 Basic Community Profile Release 1" ] ; then
            datapack="BCP_IP_TSP.R1"
        elif [ -d "$1/2011 Basic Community Profile Release 1.1" ] ; then
            datapack="BCP_IP_TSP.R1.1"
        elif [ -d "$1/2011 Basic Community Profile Release 2" ] ; then
            datapack="BCP_IP_TSP.R2"
        fi
    else
        echo "$1 doesn't appear to be a valid unzipped DataPack directory. We expected to find a Metadata folder but didn't."
        exit
    fi
fi

if [ -z $datapack ] ; then
    echo "Unable to determine datapack variant."
    exit
fi

case $datapack in
    'BCP_IP_TSP.R2'|'BCP_IP_TSP.R1'|'BCP_IP_TSP.R1.1')
        xz_name="ABS.2011.Census.DataPacks.$datapack"

        # create the CSV-Minimal tar.xz
        full_xz_name="$xz_name.CSV-Minimal.tar.xz"
        retar \
            'About\ DataPacks/*.docx' \
            'Metadata/*.xlsx' \
            '2011\ */Sequential\ Number\ Descriptor/*/AUST/*.csv'

        # create the full DVD tar.xz
        full_xz_name="$xz_name.DVD.tar.xz"
        retar '*'
        ;;
esac

if [ "$must_rm_unzipped_dir" = "yes" ] ; then
    echo "rm $unzipped_dir"
    rm -rf $unzipped_dir
fi


