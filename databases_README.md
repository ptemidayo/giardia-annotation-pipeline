# Databases Directory

This directory stores reference databases required by the annotation pipeline.

## 🔴 CRITICAL: Giardia Protein Database (REQUIRED)

**The pipeline REQUIRES a Giardia protein database and will exit if not found.**

### Quick Setup

```bash
cd databases

# Option 1: Download from NCBI (Recommended)
datasets download genome accession GCA_000002435.1 --include protein
unzip ncbi_dataset.zip
cat ncbi_dataset/data/*/protein.faa > giardia_proteins.fasta
rm -rf ncbi_dataset/ README.md ncbi_dataset.zip

# Option 2: Download from GiardiaDB
wget https://giardiadb.org/common/downloads/Current_Release/GintestinalisAssemblageA/fasta/data/GiardiaDB-XX_GintestinalisAssemblageA_AnnotatedProteins.fasta
mv GiardiaDB-*.fasta giardia_proteins.fasta

# Verify the database
grep -c '^>' giardia_proteins.fasta
# Should show: 4000-6000 proteins

# The pipeline will automatically create the DIAMOND database (.dmnd) on first run
```

---

## 📋 Required Databases

### 1. **giardia_proteins.fasta** ⭐ MANDATORY
- **Purpose**: Taxonomic filtering and contamination detection
- **Size**: ~1-2 MB
- **Format**: FASTA protein sequences
- **Expected sequences**: 4,000-6,000 proteins

**What it does:**
- Filters out non-Giardia sequences
- Detects bacterial/viral contamination
- Validates Giardia-specific genes

**Pipeline behavior:**
- ✅ If present: Pipeline runs normally
- ❌ If missing: **Pipeline exits with error**

---

## 🔵 Optional Databases (Recommended)

### 2. **SwissProt (uniprot_sprot.fasta)**
- **Purpose**: Functional annotation
- **Size**: ~300 MB (compressed)
- **Format**: FASTA protein sequences

**Setup:**
```bash
cd databases

# Download SwissProt
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz

# Decompress
gunzip uniprot_sprot.fasta.gz

# Create DIAMOND database
diamond makedb --in uniprot_sprot.fasta -d swissprot

# Clean up (optional)
rm uniprot_sprot.fasta
```

### 3. **Pfam-A.hmm**
- **Purpose**: Protein domain identification
- **Size**: ~500 MB
- **Format**: HMM profile database

**Setup:**
```bash
cd databases

# Download Pfam-A
wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz

# Decompress
gunzip Pfam-A.hmm.gz

# Prepare for hmmscan
hmmpress Pfam-A.hmm
```

---

## 📁 Directory Structure

After setup, your databases directory should look like:

```
databases/
├── giardia_proteins.fasta          # REQUIRED
├── giardia_proteins.dmnd            # Auto-created by pipeline
├── swissprot.dmnd                   # Optional (functional annotation)
├── Pfam-A.hmm                       # Optional (domain annotation)
├── Pfam-A.hmm.h3f                   # Auto-created by hmmpress
├── Pfam-A.hmm.h3i                   # Auto-created by hmmpress
├── Pfam-A.hmm.h3m                   # Auto-created by hmmpress
├── Pfam-A.hmm.h3p                   # Auto-created by hmmpress
└── README.md                        # This file
```

---

## 📊 Database Sizes

| Database | Compressed | Uncompressed | Final (.dmnd/.hmm) |
|----------|------------|--------------|-------------------|
| Giardia proteins | N/A | ~2 MB | ~1 MB |
| SwissProt | ~100 MB | ~300 MB | ~150 MB |
| Pfam | ~200 MB | ~500 MB | ~500 MB |
| **Total** | ~300 MB | ~800 MB | ~650 MB |

**Storage needed:** ~1-2 GB including temporary files

---

## 🔧 Creating DIAMOND Databases

The pipeline requires DIAMOND format (.dmnd) for protein searches:

```bash
# Giardia database (auto-created by pipeline on first run)
diamond makedb --in giardia_proteins.fasta -d giardia_proteins

# SwissProt database (if you want functional annotation)
diamond makedb --in uniprot_sprot.fasta -d swissprot
```

---

## ✅ Verify Your Setup

Run this checklist before using the pipeline:

```bash
cd databases

# 1. Check Giardia database exists
[ -f giardia_proteins.fasta ] && echo "✓ Giardia proteins: FOUND" || echo "✗ Giardia proteins: MISSING"

# 2. Count sequences
echo "Sequences in database: $(grep -c '^>' giardia_proteins.fasta)"

# 3. Check DIAMOND database (optional, auto-created if missing)
[ -f giardia_proteins.dmnd ] && echo "✓ DIAMOND database: FOUND" || echo "○ DIAMOND database: Will be auto-created"

# 4. Check optional databases
[ -f swissprot.dmnd ] && echo "✓ SwissProt: FOUND" || echo "○ SwissProt: OPTIONAL"
[ -f Pfam-A.hmm ] && echo "✓ Pfam: FOUND" || echo "○ Pfam: OPTIONAL"
```

**Expected output:**
```
✓ Giardia proteins: FOUND
Sequences in database: 5070
○ DIAMOND database: Will be auto-created
○ SwissProt: OPTIONAL
○ Pfam: OPTIONAL
```

---

## 🎯 Database Sources

### Giardia-Specific Resources

1. **NCBI RefSeq:**
   - GCA_000002435.1 (G. intestinalis WB)
   - GCA_000524195.1 (G. muris)

2. **GiardiaDB:**
   - https://giardiadb.org
   - Most comprehensive Giardia resource
   - Multiple assemblages and strains

### General Protein Databases

1. **SwissProt (UniProtKB):**
   - https://www.uniprot.org/downloads
   - Manually annotated, high quality
   - Updated monthly

2. **Pfam:**
   - http://pfam.xfam.org/
   - Protein domain families
   - Updated regularly

---

## 🔄 Updating Databases

It's good practice to update databases periodically:

```bash
# Update Giardia proteins (annually)
cd databases
mv giardia_proteins.fasta giardia_proteins.fasta.old
# Download new version using steps above
rm giardia_proteins.dmnd  # Will be recreated

# Update SwissProt (quarterly)
rm swissprot.dmnd
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
gunzip uniprot_sprot.fasta.gz
diamond makedb --in uniprot_sprot.fasta -d swissprot
rm uniprot_sprot.fasta

# Update Pfam (yearly)
rm Pfam-A.hmm*
wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
gunzip Pfam-A.hmm.gz
hmmpress Pfam-A.hmm
```

---

## ⚠️ Troubleshooting

### "Database not found" error
```bash
# Check file exists and has content
ls -lh databases/giardia_proteins.fasta
wc -l databases/giardia_proteins.fasta
```

### "Invalid FASTA format" error
```bash
# Check format
head databases/giardia_proteins.fasta
# Should start with: >protein_id
```

### "DIAMOND database creation failed"
```bash
# Check DIAMOND installation
diamond --version

# Try creating manually
diamond makedb --in giardia_proteins.fasta -d giardia_proteins
```

### "Out of disk space"
```bash
# Check available space
df -h databases/

# Clean up temporary files
rm -f databases/*.fasta  # Keep only .dmnd files
rm -rf databases/ncbi_dataset/
```

---

## 💡 Tips

### Sharing Databases Across Projects
```bash
# Use symbolic links to save space
ln -s /shared/databases/giardia_proteins.fasta databases/
ln -s /shared/databases/giardia_proteins.dmnd databases/
```

### Custom Giardia Database
If you have your own reference proteins:
```bash
# Combine multiple sources
cat reference1.faa reference2.faa > databases/giardia_proteins.fasta

# Remove duplicates (optional)
cd-hit -i databases/giardia_proteins.fasta \
       -o databases/giardia_proteins_nr.fasta \
       -c 0.95 -n 5

mv databases/giardia_proteins_nr.fasta databases/giardia_proteins.fasta
```

---

## 📞 Need Help?

- **Database setup issues?** Check the [Quick Start Guide](../docs/QUICK_START.md)
- **Download problems?** Try alternative sources above
- **Questions?** Open an [Issue](https://github.com/ptemidayo/giardia-annotation-pipeline/issues)

---

**Remember:** The Giardia protein database is MANDATORY. The pipeline will not run without it! ⭐
