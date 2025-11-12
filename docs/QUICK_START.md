# Giardia Annotation Pipeline v5.0 - Quick Start Guide

## 🎉 What You Have

✅ **Complete corrected pipeline** (2,206 lines, 82KB)
✅ **All 6 critical fixes applied**
✅ **Three-way consensus maintained** (Augustus + Prodigal + Glimmer)
✅ **Comprehensive documentation**

## 📥 Download Your Files

1. **[Complete Pipeline Script](computer:///home/claude/giardia_annotation_pipeline_v5.0_COMPLETE.sh)** (82KB) - Ready to run!
2. **[Corrections Summary](computer:///home/claude/PIPELINE_V5_CORRECTIONS_SUMMARY.md)** - Detailed documentation
3. **Individual Parts** (if you want to review sections):
   - [Part 1: Setup & Validation](computer:///home/claude/giardia_pipeline_v5_part1.sh)
   - [Part 2: Three-way Annotation](computer:///home/claude/giardia_pipeline_v5_part2.sh)
   - [Part 3: Consensus Building](computer:///home/claude/giardia_pipeline_v5_part3.sh)
   - [Part 4: Protein Extraction & Filtering](computer:///home/claude/giardia_pipeline_v5_part4.sh)
   - [Part 5: Taxonomic Filtering & QC](computer:///home/claude/giardia_pipeline_v5_part5.sh)
   - [Part 6: Validation & Output](computer:///home/claude/giardia_pipeline_v5_part6.sh)

## 🚀 Quick Setup

### 1. Transfer the Pipeline
```bash
# Download the complete script to your HPC
# Make it executable
chmod +x giardia_annotation_pipeline_v5.0_COMPLETE.sh
```

### 2. Create Required Directory Structure
```bash
mkdir -p databases
mkdir -p genomes
mkdir -p results
```

### 3. **CRITICAL**: Set Up Giardia Protein Database
```bash
# Option A: Download from NCBI (recommended)
cd databases
datasets download genome accession GCA_000002435.1 --include protein
unzip ncbi_dataset.zip
cat ncbi_dataset/data/*/protein.faa > giardia_proteins.fasta
cd ..

# Option B: Use your own Giardia proteins
cp your_giardia_proteins.faa databases/giardia_proteins.fasta

# Verify the database
grep -c '^>' databases/giardia_proteins.fasta
# Should show number of proteins (e.g., 5000+)
```

### 4. Place Your Genomes
```bash
# Copy your genome files to the genomes directory
cp /path/to/your/genomes/*.fna genomes/
```

### 5. Update Augustus Config Path
```bash
# Edit line 245 in the script:
# Change: export AUGUSTUS_CONFIG_PATH="/home/temidayo.elufisan/augustus_config"
# To your actual path
nano giardia_annotation_pipeline_v5.0_COMPLETE.sh
# Or:
sed -i 's|/home/temidayo.elufisan/augustus_config|/your/path/to/augustus_config|g' giardia_annotation_pipeline_v5.0_COMPLETE.sh
```

## 🎯 Running the Pipeline

### Basic Usage
```bash
./giardia_annotation_pipeline_v5.0_COMPLETE.sh \
    genome.fasta \
    StrainName \
    16 \
    intestinalis
```

### Parameters
1. **genome.fasta** - Genome filename (must be in genomes/ directory)
2. **StrainName** - Your strain identifier (no spaces)
3. **16** - Number of threads (adjust for your system)
4. **intestinalis** - Species: `intestinalis`, `muris`, or `auto`

### Examples
```bash
# G. intestinalis with 16 threads
./giardia_annotation_pipeline_v5.0_COMPLETE.sh \
    Giardia_intestinalis_WB.fna \
    GiardiaWB \
    16 \
    intestinalis

# G. muris with auto-detection
./giardia_annotation_pipeline_v5.0_COMPLETE.sh \
    Giardia_muris_P15.fna \
    GiardiaMuris_P15 \
    16 \
    auto

# Run on all genomes (batch)
for genome in genomes/*.fna; do
    strain=$(basename $genome .fna)
    ./giardia_annotation_pipeline_v5.0_COMPLETE.sh \
        $(basename $genome) \
        $strain \
        16 \
        auto
done
```

## ✅ What the Pipeline Does

### Phase 1: Genome Preparation
- Calculates genome statistics (N50, GC%, size)
- Runs BUSCO on genome assembly

### Phase 2: Three-Way Structural Annotation
- **Augustus**: With intron prediction
- **Prodigal**: Meta mode for compact genomes
- **Glimmer**: Improved training with reference CDS support
- Creates consensus (60% overlap, 2x size similarity)
- Filters for high-confidence (2+ predictors)

### Phase 3: Pseudogene Detection
- Identifies truncated genes
- Detects internal stop codons
- Separates functional vs pseudogenes

### Phase 4: Taxonomic Filtering
- **USES REQUIRED GIARDIA DATABASE**
- DIAMOND search against Giardia proteins
- Removes bacterial/viral contaminants
- Validates Giardia-specific genes

### Phase 5: Quality Control
- Length-based filtering
- Final gene count validation
- BUSCO assessment on final set

### Phase 6: Functional Annotation
- SwissProt hits (optional)
- Pfam domain predictions (optional)

### Phase 7: Giardia-Specific Analysis
- VSP candidate identification
- Species-specific parameters

### Phases 8-10: Output Generation
- Comprehensive validation
- GenBank file creation
- CDS sequence extraction
- Final reports

## 📊 Expected Output

```
results/STRAIN_TIMESTAMP/
├── STRAIN_high_confidence.gff3          # HIGH-CONFIDENCE GENES (2+)
├── STRAIN_final_proteins.faa            # Final protein sequences
├── STRAIN_final_cds.fna                 # CDS sequences
├── STRAIN_annotation.gbk                # GenBank format
├── STRAIN_consensus_normalized.gff3     # Full consensus (all predictions)
├── STRAIN_FINAL_REPORT.txt              # Comprehensive report ⭐
├── pseudogenes/
│   ├── STRAIN_pseudogenes.faa
│   └── STRAIN_functional_genes.faa
├── taxonomy/
│   ├── STRAIN_taxonomic_analysis.txt
│   └── STRAIN_giardia_genes.faa
├── functional/
│   ├── STRAIN_swissprot.tsv
│   └── STRAIN_pfam_domains.txt
└── giardia_specific/
    └── STRAIN_vsp_candidates.tsv
```

## 🔍 Monitoring Progress

```bash
# Watch the log file
tail -f STRAIN_pipeline.log

# Check validation log
cat STRAIN_validation.log

# Monitor completion
ls -lht results/
```

## 📈 Expected Results

### For G. intestinalis:
- Total genes: ~5,100
- High-confidence (2+ predictors): ~4,500-4,800
- Pseudogenes: 200-300
- VSP candidates: 80-150
- BUSCO: 18-24% (**LOW IS NORMAL!**)

### For G. muris:
- Total genes: ~4,660
- High-confidence (2+ predictors): ~4,000-4,300
- Pseudogenes: 150-200
- VSP candidates: 60-100
- BUSCO: 15-22% (**LOW IS NORMAL!**)

## ⚠️ Important Notes

1. **Giardia database is MANDATORY** - Pipeline will exit if missing
2. **Low BUSCO scores are EXPECTED** - 18-24% is normal for Giardia
3. **Three-way consensus is key** - Uses all three predictors
4. **High-confidence = 2+ predictors** - Reduces false positives

## 🐛 Troubleshooting

### "Giardia database not found"
```bash
# Check if database exists
ls -lh databases/giardia_proteins.fasta

# If missing, download it (see step 3 above)
```

### "Augustus config path not found"
```bash
# Find your Augustus config
find ~ -name "augustus_config" -type d

# Update line 245 in the script
```

### "Glimmer training failed"
```bash
# Provide reference CDS file at one of these locations:
cp reference_cds.fna databases/reference_cds.fna
# Or pipeline will use genome-based training (automatic fallback)
```

### Low gene count after filtering
```bash
# Check the validation log
cat STRAIN_validation.log

# Review taxonomic analysis
cat results/STRAIN_*/taxonomy/STRAIN_taxonomic_analysis.txt
```

## 📞 Need Help?

1. Check **PIPELINE_V5_CORRECTIONS_SUMMARY.md** for detailed explanations
2. Review the **STRAIN_FINAL_REPORT.txt** for comprehensive metrics
3. Examine **STRAIN_validation.log** for checkpoint status

## 🎓 Key Improvements in v5.0

| Feature | Status |
|---------|--------|
| Three-way consensus | ✅ Maintained |
| Glimmer training | ✅ Fixed with fallback |
| GenBank generation | ✅ Fixed (single execution) |
| BUSCO extraction | ✅ Improved with fallbacks |
| Taxonomic filtering | ✅ Streamlined & mandatory |
| Validation | ✅ Comprehensive all-file check |
| Error handling | ✅ Extensive with clear messages |

## 🎉 Ready to Go!

Your pipeline is production-ready. All critical issues have been fixed, and it maintains the three-way consensus approach you need.

**Good luck with your Giardia genome annotation!** 🦠
