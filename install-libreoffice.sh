#!/bin/sh
    
# A script to install or update libreoffice releases properly
# Originally from https://wiki.documentfoundation.org/Documentation/Install/Linux#Script_For_Installing
# Changes:
# AG: switched from bash to sh

if [[ "$1" == "-x" ]]; then
    shift
    set -x
fi
    
me=`basename $0`
Usage() {
    echo "Usage: $me [-x][-h|--help] <gzipped-tarball> [<gzipped-tarball>...]"
    exit 0
}
    
if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then Usage; fi
    
# Change these to install on rpm base systems
tgt=DEBS
cmd="dpkg -i"
sfx=deb
    
for tb in $*; do
    if [[ ! -f $tb ]]; then
        if [[ -f "$tb.tgz" ]]; then
            tb="$tb.tgz"
        elif [[ -f "$tb.tar.gz" ]]; then
            tb="$tb.tar.gz"
        else
            echo "Can't find $tb or $tb.tgz or $tb.tar.gz - skipping..."
            read ln
            continue
        fi
    fi
    
    # find out what the name of the uncompressed subdirectory will be
    dst=`tar tzf $tb 2> /dev/null | head -1 | awk -F/ '{print $1}'`
    tar xzf $tb
    if [[ ! -d $dst/$tgt ]]; then
        echo "Can't find $me directory $dst/$tgt - skipping..."
        read ln
        continue
    fi
    
    # install or update, depending on how I was called
    cd $dst/$tgt
    case $me in
        loinst)
            sudo $cmd *.$sfx
            if [[ -d desktop-integration ]]; then
                cd desktop-integration
                sudo $cmd *.$sfx
                cd ..
            fi
            cd ../..
        ;;
        loupdate)
            cd ..
            sudo ./update
            cd ..
        ;;
    esac
    
    # delete the installation directory
    /bin/rm -rf $dst
done
    
echo ""

