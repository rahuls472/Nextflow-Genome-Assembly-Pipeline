#!/usr/bin/env nextflow

process FASTQC {
    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "results/fastqc_reports", mode: "copy"

    input:
    tuple val(sample), path(reads)

    output:
    path "*.html", emit: html
    path "*.zip",  emit: zip

    script:
    """
    fastqc -o . -t ${task.cpus} ${reads}
    """
}