# Genomes Directory

Place your input genome FASTA files in this directory.

## 📁 File Requirements

### Supported Formats
- `.fna` - FASTA nucleotide format (recommended)
- `.fasta` - FASTA format
- `.fa` - FASTA format

### File Naming
Your genome files should follow these naming conventions:

**Good examples:**
- `Giardia_intestinalis_WB.fna`
- `Giardia_muris_P15.fna`
- `GiardiaAssemblageA.fasta`
- `Strain_XYZ.fna`

**Avoid:**
- Spaces in filenames: `My Genome File.fna` ❌
- Special characters: `Genome@2024!.fna` ❌
- Very long names: `This_is_a_very_long_genome_name_with_too_many_characters.fna` ❌

## 📊 Genome Quality Requirements

For best annotation results, your genome assembly should have:

| Metric | Minimum | Recommended |
|--------|---------|-------------|
| **Total size** | 8 MB | 10-12 MB |
| **N50** | > 50 kb | > 100 kb |
| **Number of scaffolds** | < 1,000 | < 500 |
| **Completeness (BUSCO)** | > 70% | > 85% |
| **Contamination** | < 5% | < 2% |

### For *G. intestinalis*:
- Expected genome size: ~11-12 MB
- Expected scaffolds: 50-500
- GC content: ~45-50%

### For *G. muris*:
- Expected genome size: ~10-11 MB
- Expected scaffolds: 50-400
- GC content: ~46-48%

## 🔧 How to Add Your Genomes

### Method 1: Copy Files
```bash
# Copy from your data directory
cp /path/to/your/genomes/*.fna genomes/

# Or copy a single genome
cp /path/to/genome.fna genomes/Giardia_strain1.fna
```

### Method 2: Symbolic Links (if files are large)
```bash
# Create symbolic links instead of copying
ln -s /path/to/your/genomes/genome1.fna genomes/
ln -s /path/to/your/genomes/genome2.fna genomes/
```

### Method 3: Download from NCBI
```bash
cd genomes

# Using NCBI datasets tool
datasets download genome accession GCA_000002435.1 \
    --filename giardia_wb.zip

unzip giardia_wb.zip
mv ncbi_dataset/data/*/GCA*.fna Giardia_intestinalis_WB.fna

# Clean up
rm -rf ncbi_dataset/ README.md giardia_wb.zip
```

## 📝 Example Genome Files

This directory does **not** include example genome files to keep the repository size small. You need to provide your own genomes or download from public databases.

### Where to Get Giardia Genomes

1. **NCBI GenBank:**
   - https://www.ncbi.nlm.nih.gov/genome/
   - Search: "Giardia intestinalis" or "Giardia muris"

2. **GiardiaDB:**
   - https://giardiadb.org
   - Comprehensive *Giardia* genomics resource

3. **ENA (European Nucleotide Archive):**
   - https://www.ebi.ac.uk/ena

### Reference Genomes

**G. intestinalis Assemblage A (WB):**
- Accession: GCA_000002435.1
- Size: ~11.7 MB
- Chromosomes: 5

**G. muris:**
- Accession: GCA_000524195.1
- Size: ~10.7 MB

## ⚠️ Before Running the Pipeline

### 1. Check Your Genome Quality
```bash
# Get basic statistics
seqkit stats genomes/*.fna

# Check for N content
seqkit fx2tab -n -g genomes/your_genome.fna
```

### 2. Ensure Proper Formatting
```bash
# Check FASTA format
head -20 genomes/your_genome.fna

# Should show:
# >scaffold_1
# ATCGATCGATCG...
# >scaffold_2
# ATCGATCGATCG...
```

### 3. Verify File Integrity
```bash
# Check file is not corrupted
file genomes/*.fna

# Should show: ASCII text
```

## 🎯 Ready to Annotate?

Once your genomes are in this directory:

```bash
# Annotate a single genome
./giardia_annotation_pipeline.sh \
    your_genome.fna \
    StrainName \
    16 \
    auto

# Batch annotate all genomes
cd examples
./example_batch_run.sh
```

## 💡 Tips

### Compressing Large Genomes
If you need to save space, compress finished genomes:
```bash
# Compress genome (keeps original)
gzip -k genomes/finished_genome.fna

# Later, decompress when needed
gunzip genomes/finished_genome.fna.gz
```

### Organizing Multiple Species
```bash
genomes/
├── intestinalis/
│   ├── strain_A.fna
│   └── strain_B.fna
└── muris/
    ├── strain_1.fna
    └── strain_2.fna
```

### Renaming Multiple Files
```bash
# Add prefix to all genomes
for f in genomes/*.fna; do
    mv "$f" "genomes/Giardia_$(basename $f)"
done
```

## 📞 Need Help?

- **File format issues?** Check the [Quick Start Guide](../docs/QUICK_START.md)
- **Quality concerns?** See [Troubleshooting](../docs/QUICK_START.md#troubleshooting)
- **Questions?** Open an [Issue](https://github.com/ptemidayo/giardia-annotation-pipeline/issues)

---

**Remember:** The pipeline expects genome files to be in this directory!
