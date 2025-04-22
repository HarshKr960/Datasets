#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Define input channel with dummy FASTQ files
Channel.fromPath('data/*.fastq') \
    .set { fastq_files }

// Process to simulate alignment
process ALIGN_READS {
    tag "$sample_id"

    input:
    path fastq_file
    val sample_id = fastq_file.getBaseName()

    output:
    path "${sample_id}.bam"

    script:
    """
    echo "Simulating alignment for ${sample_id}" > ${sample_id}.bam
    """
}

// Process to summarize output
process SUMMARIZE {
    input:
    path bam_file

    output:
    path "summary.txt", append: true

    script:
    """
    echo "Processed ${bam_file}" >> summary.txt
    """
}

// Launch the pipeline
workflow {
    fastq_files | ALIGN_READS | SUMMARIZE
}
