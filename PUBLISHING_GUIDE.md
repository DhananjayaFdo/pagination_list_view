# Publishing Guide for pagination_list_view

## Prerequisites

1. **Google Account**: You need a Google account to publish to pub.dev
2. **Git Repository**: Your package should be in a Git repository (GitHub recommended)
3. **Complete Package**: Ensure all files are ready

## Step-by-Step Publishing Process

### 1. Prepare Your Package

Before publishing, make sure you have:

- ✅ `pubspec.yaml` with correct metadata
- ✅ `README.md` with comprehensive documentation
- ✅ `CHANGELOG.md` with version history
- ✅ `LICENSE` file (MIT recommended)
- ✅ Example app in `example/` directory
- ✅ Tests in `test/` directory
- ✅ Proper package structure (`lib/`, `lib/src/`)

### 2. Update Package Files

#### pubspec.yaml
Update these fields with your actual information:
```yaml
name: pagination_list_view
description: A Flutter package providing a customizable ListView with built-in pagination, pull-to-refresh, and infinite scrolling capabilities.
version: 1.0.0
homepage: https://github.com/YOURUSERNAME/pagination_list_view
repository: https://github.com/YOURUSERNAME/pagination_list_view
issue_tracker: https://github.com/YOURUSERNAME/pagination_list_view/issues
```

#### LICENSE
Replace `[Your Name]` with your actual name:
```
Copyright (c) 2025 [Your Actual Name]
```

#### README.md
Update all GitHub URLs from `yourusername` to your actual GitHub username.

### 3. Initialize Git Repository

```bash
cd pagination_list_view
git init
git add .
git commit -m "Initial commit: pagination_list_view v1.0.0"
```

### 4. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository named `pagination_list_view`
3. Don't initialize with README (you already have one)
4. Push your local repository:

```bash
git remote add origin https://github.com/YOURUSERNAME/pagination_list_view.git
git branch -M main
git push -u origin main
```

### 5. Validate Your Package

Run these commands to check for issues:

```bash
# Check package structure and dependencies
flutter pub get

# Run static analysis
dart analyze

# Run tests
flutter test

# Validate package for publishing (DRY RUN)
dart pub publish --dry-run
```

The dry-run will check:
- Package layout conventions
- pubspec.yaml format
- File structure
- Dependencies
- Warnings and errors

**Fix all warnings and errors before proceeding!**

### 6. Sign In to pub.dev

```bash
dart pub login
```

This will:
- Open your browser
- Ask you to sign in with your Google account
- Grant permission to publish packages
- Save credentials locally

### 7. Publish Your Package

```bash
dart pub publish
```

You'll see:
- A summary of files being uploaded
- Package name and version
- A confirmation prompt

Type `y` and press Enter to confirm.

### 8. Verify Publication

1. Visit https://pub.dev/packages/pagination_list_view
2. Check that:
   - ✅ README renders correctly
   - ✅ Example code is visible
   - ✅ Changelog is displayed
   - ✅ API documentation is generated
   - ✅ All metadata is correct

### 9. Add Package Badge to README (Optional)

Add this to your README.md:

```markdown
[![pub package](https://img.shields.io/pub/v/pagination_list_view.svg)](https://pub.dev/packages/pagination_list_view)
```

## Publishing Updates

### For Bug Fixes (Patch Version: 1.0.0 → 1.0.1)

```bash
# 1. Make your fixes
# 2. Update version in pubspec.yaml
version: 1.0.1

# 3. Update CHANGELOG.md
## [1.0.1] - 2025-02-15
### Fixed
- Fixed scroll controller disposal issue

# 4. Commit changes
git add .
git commit -m "Version 1.0.1: Bug fixes"
git tag v1.0.1
git push origin main --tags

# 5. Publish
dart pub publish
```

### For New Features (Minor Version: 1.0.0 → 1.1.0)

```bash
# Update version
version: 1.1.0

# Update CHANGELOG.md
## [1.1.0] - 2025-03-01
### Added
- New parameter: onItemTap callback
- Support for custom error widgets

# Commit and publish
git add .
git commit -m "Version 1.1.0: Added new features"
git tag v1.1.0
git push origin main --tags
dart pub publish
```

### For Breaking Changes (Major Version: 1.0.0 → 2.0.0)

```bash
# Update version
version: 2.0.0

# Update CHANGELOG.md
## [2.0.0] - 2025-04-01
### Breaking Changes
- Renamed `item` parameter to `itemBuilder`
- Changed callback signature for onLoadMore

### Migration Guide
See MIGRATION.md for upgrade instructions

# Commit and publish
git add .
git commit -m "Version 2.0.0: Breaking changes"
git tag v2.0.0
git push origin main --tags
dart pub publish
```

## Best Practices

### 1. Semantic Versioning
Follow [semver.org](https://semver.org/):
- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features (backward compatible)
- **PATCH** (1.0.0 → 1.0.1): Bug fixes

### 2. Documentation
- Write clear, helpful documentation
- Include code examples
- Provide migration guides for breaking changes
- Keep CHANGELOG.md updated

### 3. Testing
- Write comprehensive tests
- Run tests before publishing
- Aim for high code coverage

### 4. Maintenance
- Respond to issues promptly
- Review pull requests
- Keep dependencies updated
- Mark deprecated features clearly

### 5. Communication
- Use GitHub Discussions for questions
- Be clear about supported platforms
- Document known issues
- Provide roadmap when possible

## Scoring on pub.dev

Your package is scored on:

1. **Likes**: Users can "like" your package
2. **Pub Points** (0-130):
   - Follow Dart conventions (30 points)
   - Provide documentation (10 points)
   - Support multiple platforms (20 points)
   - Pass static analysis (50 points)
   - Support latest SDK (20 points)

3. **Popularity**: Based on downloads

## Promoting Your Package

1. Share on social media (Twitter, Reddit, LinkedIn)
2. Write blog posts or tutorials
3. Create YouTube videos
4. Submit to awesome-flutter lists
5. Engage with the Flutter community

## Common Issues

### Issue: "Package validation failed"
**Solution**: Run `dart pub publish --dry-run` and fix all errors

### Issue: "Package name already taken"
**Solution**: Choose a unique name, check pub.dev first

### Issue: "Version already exists"
**Solution**: Increment version number in pubspec.yaml

### Issue: "Missing documentation"
**Solution**: Add doc comments (///) to all public APIs

## Getting Help

- pub.dev support: https://pub.dev/help
- Dart Discord: https://discord.gg/dart-lang
- Stack Overflow: Tag with `dart` and `flutter`

## Unpublishing (Rare Cases)

⚠️ **Warning**: Unpublishing is generally not allowed. Once published, your package is permanent.

Exceptions (must contact pub.dev):
- Package published within 7 days
- Legal/copyright issues
- Security vulnerabilities

**Instead**: Mark package as discontinued if no longer maintained.

---

**Remember**: Publishing is permanent. Take time to review everything before publishing!
