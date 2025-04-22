#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Generate synthetic FASTQ files if they don't exist
process GENERATE_FASTQ {
    tag "generate"

    output:
    path "data/sample1.fastq"
    path "data/sample2.fastq"

    script:
    """
    mkdir -p data
    echo -e "@SEQ_ID\\nGATTTGGGG\\n+\\nIIIIIIIII" > data/sample1.fastq
    echo -e "@SEQ_ID\\nCCTTAGGGA\\n+\\nIIIIIIIII" > data/sample2.fastq
    """
}

// Define input channel with generated FASTQ files
workflow {
    generate_fastq_output = GENERATE_FASTQ()

    Channel
        .fromPath(generate_fastq_output)
        .set { fastq_files }

    fastq_files | ALIGN_READS | SUMMARIZE
}

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
