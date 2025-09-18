# Documentation Integration Guide

This guide ensures that new documentation in Verdikta submodules is properly integrated into the main [docs.verdikta.org](https://docs.verdikta.org) site.

## 🎯 Problem

When developers add new documentation folders to submodules (like `sources/arbiter/docs/`), they often aren't accessible from the main documentation site because they lack proper integration with the monorepo documentation system.

## ✅ Solution Pattern

To make documentation accessible from the main site, **every documentation folder** needs:

1. **mkdocs.yml configuration file**
2. **Navigation entry in main mkdocs.yml**

## 📋 Integration Checklist

### Step 1: Create mkdocs.yml in Documentation Folder

Create a `mkdocs.yml` file in your documentation folder (e.g., `sources/your-repo/docs/mkdocs.yml`):

```yaml
site_name: Your Component Documentation
site_description: Brief description of what this documentation covers

# Docs directory (set to current directory)
docs_dir: .

theme:
  name: material

nav:
  - Home: index.md
  - Your Sections:
    - Guide: your-guide.md
    - Reference: your-reference.md

markdown_extensions:
  - admonition
  - codehilite
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
  - pymdownx.tabbed
  - pymdownx.details
  - attr_list
  - def_list
  - footnotes
  - md_in_html
  - toc:
      permalink: true
```

### Step 2: Add Navigation Entry

In the main `mkdocs.yml` file, add your documentation to the navigation:

```yaml
nav:
  - Home: index.md
  - Overview: [...]
  - Your Section: '!include sources/your-repo/docs/mkdocs.yml'
  - Other Sections: [...]
```

### Step 3: Test Integration

```bash
# Test the build
mkdocs build --quiet

# Test locally
mkdocs serve --dev-addr 127.0.0.1:8000
```

## 📁 Current Documentation Structure

As of the latest update, the main documentation includes:

| Section | Source | Type |
|---------|--------|------|
| **Node Operators** | `sources/arbiter/installer/docs/` | Installation & Management |
| **Developers** | `sources/apps/docs/` | Application Development & Contributing |
| **Common Library** | `sources/common/docs/` | Library Usage |
| **Smart Contracts** | `sources/dispatcher/docs/` | Contract Integration |

### Developers Section Structure
- **Integration Guide** - For 3rd party developers integrating Verdikta
- **Example Frontend** - Complete integration example
- **Contributors** - For developers contributing to Verdikta itself
  - Contributing guidelines (`sources/arbiter/docs/CONTRIBUTING.md`)
  - Development setup (`sources/arbiter/docs/development/setup.md`)
  - Architecture (`sources/arbiter/docs/development/architecture.md`)

## 🔄 Deployment Process

When documentation is properly integrated:

1. **Commit changes** to the source repository
2. **Update submodules** in verdikta-docs
3. **Push to main branch** triggers automatic deployment
4. **GitHub Actions** builds and deploys to Vercel
5. **docs.verdikta.org** updates automatically

## 🚨 Common Issues

### Issue: Documentation Not Appearing
**Cause**: Missing mkdocs.yml in documentation folder
**Fix**: Create mkdocs.yml following the pattern above

### Issue: Build Fails
**Cause**: Navigation syntax error or missing files
**Fix**: Test with `mkdocs build --verbose` to see detailed errors

### Issue: Links Broken
**Cause**: Incorrect relative paths or missing docs_dir configuration
**Fix**: Set `docs_dir: .` and use relative paths from the docs folder

## 🎯 Best Practices

1. **Consistent Structure**: Follow the established navigation patterns
2. **Clear Naming**: Use descriptive section names in navigation
3. **Test Locally**: Always test with `mkdocs serve` before committing
4. **Document Purpose**: Include clear descriptions in site_description
5. **Follow Conventions**: Use the same markdown extensions as other sections

## 📖 Examples

See these working examples:
- **Node Operators**: `sources/arbiter/installer/docs/mkdocs.yml`
- **Applications**: `sources/apps/docs/mkdocs.yml` 
- **Common Library**: `sources/common/mkdocs.yml`
- **Smart Contracts**: `sources/dispatcher/mkdocs.yml`
- **Developer Docs**: Integrated into Developers section

---

Following this guide ensures your documentation will be accessible from the main documentation site and properly integrated into the Verdikta ecosystem.
