# Verdikta Documentation

This repository contains the unified documentation site for the Verdikta ecosystem - a decentralized AI-powered dispute resolution platform built on blockchain technology.

## 🌐 Live Site

The documentation is available at: [docs.verdikta.org](https://docs.verdikta.org)

## 📋 Overview

This documentation site aggregates content from multiple Verdikta repositories using MkDocs with the monorepo plugin. The site automatically updates when source repositories change, providing a single source of truth for all Verdikta documentation.

## 🏗️ Architecture

```
verdikta-docs/                 ← This repository
├── mkdocs.yml                 ← Main configuration
├── requirements.txt           ← Python dependencies
├── docs/                      ← Root-level docs
│   ├── index.md               ← Homepage
│   ├── overview/              ← High-level documentation
│   └── changelog/             ← Release notes
├── assets/                    ← Shared assets
│   ├── stylesheets/
│   └── images/
└── sources/                   ← Git submodules
    ├── arbiter/               ← verdikta-arbiter repo
    ├── dispatcher/            ← verdikta-dispatcher repo
    └── apps/                  ← verdikta-applications repo
```

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- Git with submodule support

### Local Development

1. **Clone the repository**:
   ```bash
   git clone --recursive https://github.com/verdikta/verdikta-docs.git
   cd verdikta-docs
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Serve locally**:
   ```bash
   mkdocs serve
   ```

4. **View the site**:
   Open [http://localhost:8000](http://localhost:8000) in your browser

### Building for Production

```bash
mkdocs build
```

The built site will be in the `site/` directory.

## 🔄 Content Updates

### Automatic Updates

The site automatically updates when:
- Source repositories push changes to their `docs/` folders
- GitHub Actions runs every 6 hours to check for updates
- Manual trigger via GitHub Actions workflow

### Manual Updates

To manually update submodules:

```bash
git submodule update --remote --recursive
git add sources/
git commit -m "Update documentation submodules"
git push
```

## 📝 Contributing

### Adding New Content

#### To the Main Site
1. Edit files in the `docs/` directory
2. Update `mkdocs.yml` navigation if needed
3. Test locally with `mkdocs serve`
4. Submit a pull request

#### To Component Documentation
1. Edit files in the respective source repository's `docs/` folder
2. The changes will automatically appear here when the submodules update

### Content Structure

Each source repository should maintain:
- A single `docs/` folder at the root level
- Markdown files with proper frontmatter
- Images in `docs/_assets/` subdirectory
- Relative links for navigation

### Style Guide

- Use descriptive headings and subheadings
- Include code examples with proper syntax highlighting
- Add admonitions (tips, warnings, notes) for important information
- Use consistent formatting and terminology

## 🛠️ Technical Details

### MkDocs Configuration

The site uses:
- **MkDocs Material**: Modern theme with advanced features
- **Monorepo Plugin**: Aggregates content from multiple repositories
- **Search Plugin**: Full-text search across all content
- **Various Extensions**: Code highlighting, tables, admonitions, etc.

### Deployment

- **Hosting**: Vercel with automatic deployments
- **Domain**: docs.verdikta.org
- **SSL**: Automatic HTTPS with Vercel
- **CDN**: Global edge caching for fast loading

### Monitoring

- **GitHub Actions**: Automated builds and updates
- **Vercel Analytics**: Performance and usage metrics
- **Error Tracking**: Build failures and broken links

## 📚 Documentation Sections

### For Node Operators
- Installation guides and prerequisites
- Configuration and management
- Troubleshooting and maintenance
- Performance optimization

### For Developers  
- API documentation and examples
- SDK integration guides
- Smart contract interfaces
- Testing and development tools

### For Everyone
- Project overview and architecture
- Whitepapers and research
- Changelog and release notes
- Community resources

## 🔗 Related Repositories

- [verdikta-arbiter](https://github.com/verdikta/verdikta-arbiter) - Arbiter node software
- [verdikta-dispatcher](https://github.com/verdikta/verdikta-dispatcher) - Smart contracts
- [verdikta-applications](https://github.com/verdikta/verdikta-applications) - Example applications

## 📞 Support

- **Documentation Issues**: [GitHub Issues](https://github.com/verdikta/verdikta-docs/issues)
- **General Questions**: [Discord Community](https://discord.gg/verdikta)
- **Email**: [docs@verdikta.org](mailto:docs@verdikta.org)

## 📄 License

This documentation is licensed under the [MIT License](LICENSE).

---

Built with ❤️ using [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
