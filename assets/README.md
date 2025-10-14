# Assets Folder

This folder contains shared resources used across course materials.

## Files

### adci-template.pptx

PowerPoint template for all lecture slides (Weeks 1-12).

**Purpose:** Provides consistent branding and formatting for all lecture presentations.

**Usage in lecture .qmd files:**

```yaml
---
title: "Your Lecture Title"
subtitle: "Week X: Topic"
author: "CYB205 Computer Forensics"
format:
  pptx:
    reference-doc: ../assets/adci-template.pptx  # Add this line
---
```

**Important Notes:**

- **Path:** Use `../assets/adci-template.pptx` from week folders
- **Customization:** Edit template in PowerPoint to update branding across all lectures
- **Slide masters:** Template defines title slides, content slides, section headers

---

### activity-styles.css

Centralized CSS stylesheet for all activity `.qmd` files (Weeks 1-12).

**Purpose:** Eliminates CSS duplication across 30+ activity files.

**Usage in .qmd files:**

```yaml
---
title: "Your Activity Title"
format:
  html:
    theme: cosmo
    toc: true
    code-copy: true
    embed-resources: true
    css: ../assets/activity-styles.css  # Add this line
  pdf:
    toc: true
  docx:
    toc: true
---
```

**Important Notes:**

- **Path varies by week:** Use `../assets/activity-styles.css` from week folders
- **embed-resources: true** is required for standalone HTML export (CSS inlined at build time)
- PDF/DOCX formats ignore CSS (use default Quarto styling)

**Available CSS Classes:**

See `activity-styles.css` for full list. Common classes:

- `.activity-header` - Hero section with gradient background
- `.success-box`, `.warning-box`, `.error-box`, `.info-box` - Colored message boxes
- `.checkpoint`, `.checklist` - Student progress indicators
- `.example-box`, `.good-example`, `.bad-example` - Code/text examples
- `.scenario-box`, `.decision-table` - Interactive activities
- `.command-box`, `.template-box` - Code formatting
- `.print-button`, `.reveal-button`, `.check-button` - Interactive buttons
- `.ai-prompt-box` - AI integration examples

**Customization:**

If activity-specific styles needed:

```html
<!-- Add custom styles AFTER CSS link in YAML -->
```{=html}
<style>
.custom-class {
    /* Your custom styles here */
}
</style>
```
```

**Maintenance:**

- **Single source of truth:** Edit `activity-styles.css` to update ALL activities
- **Version control:** Test changes across multiple weeks before committing
- **Browser compatibility:** Styles tested on Chrome, Firefox, Safari, Edge

## Future Assets

This folder may contain:

- `adci-template.pptx` - PowerPoint template (if not in root)
- `images/` - Shared diagrams, logos, screenshots
- `scripts/` - JavaScript for interactive activities
- `fonts/` - Custom typography (if needed)

---

**Last Updated:** [Current Date]
