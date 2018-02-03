#!/usr/bin/env bash
set -e

function create() {
    label=${1}
    dir=${2}
    variant=${3}
    base=${4}

    mkdir --parent ${dir}

    echo "Generating ${dir}/Dockerfile file."
    echo "FROM php:${label}" > ${dir}/Dockerfile
    echo >> ${dir}/Dockerfile
    cat env.Dockerfile >> ${dir}/Dockerfile
    echo >> ${dir}/Dockerfile
    cat common.Dockerfile >> ${dir}/Dockerfile
    echo >> ${dir}/Dockerfile
    cat base-${base}.Dockerfile >> ${dir}/Dockerfile
    echo >> ${dir}/Dockerfile
    cat ${variant}.Dockerfile >> ${dir}/Dockerfile

    echo "Copying ${label} setup files."
    cp ${variant}.setup.sh ${dir}/setup.sh
    cp configure.sh ${dir}/configure.sh

    if [ -d "files/${variant}" ]; then
        echo "Copying ${label} extra files."
        cp --recursive files/${variant}/* ${dir}
    fi
}

versions=(7.1)
modes=(fpm apache)

for version in "${versions[@]}"; do
    rm --recursive --force ${version}
    create ${version} ${version} "cli" "debian"
    create "${version}-alpine" "${version}/alpine" "cli" "alpine"
    for mode in "${modes[@]}"; do
        create "${version}-${mode}" "${version}/${mode}" ${mode} "debian"

        if [[ ${mode} != "apache" ]]; then
            create "${version}-${mode}-alpine" "${version}/${mode}/alpine" ${mode} "alpine"
        fi
    done
done
