#!/usr/bin/env bash
set -e

versions=(7.0 7.1)
variants=(cli fpm apache)

for version in "${versions[@]}"; do
    rm --recursive --force ${version}
    mkdir ${version}
    for variant in "${variants[@]}"; do
        label="${version}-${variant}"
        dir="${version}/${variant}"

        if [[ ${variant} == "cli" ]]; then
            label=${version}
            dir=${version}
        fi

        mkdir --parent ${dir}

        echo "Generating ${dir}/Dockerfile file."
        echo "FROM php:${label}" > ${dir}/Dockerfile
        echo >> ${dir}/Dockerfile
        cat common.1.Dockerfile >> ${dir}/Dockerfile
        echo >> ${dir}/Dockerfile
        cat ${variant}.Dockerfile >> ${dir}/Dockerfile
        echo >> ${dir}/Dockerfile
        cat common.2.Dockerfile >> ${dir}/Dockerfile

        echo "Copying ${label} setup file."
        cp ${variant}.setup.sh ${dir}/setup.sh

        if [ -d "files/${variant}" ]; then
            echo "Copying ${label} extra files."
            cp --recursive files/${variant}/* ${dir}
        fi
    done
done
