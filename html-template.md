# HTML Template Reference

Full architecture for every generated presentation. Read this before generating Phase 3 output.

---

## File Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[DECK TITLE]</title>

    <!-- FONTS: always Google Fonts, never system fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="[GOOGLE FONTS URL]" rel="stylesheet">

    <style>
        /* === VIEWPORT BASE === */
        /* PASTE FULL CONTENTS OF viewport-base.css HERE */

        /* === THEME === */
        :root {
            /* All preset variables here */
        }

        /* === SLIDE-SPECIFIC STYLES === */
        /* One comment block per slide type */
    </style>
</head>
<body>

<!-- === SLIDESHOW CONTAINER === -->
<div class="slideshow" id="slideshow">

    <!-- === SLIDE 1: TITLE === -->
    <div class="slide active" id="slide-1">
        <!-- slide content -->
    </div>

    <!-- === SLIDE N === -->
    <div class="slide" id="slide-[N]">
        <!-- slide content -->
    </div>

</div>

<!-- === PROGRESS BAR === -->
<div class="progress-bar" id="progressBar"></div>

<!-- === NAV DOTS === -->
<div class="nav-dots" id="navDots"></div>

<!-- === SLIDE COUNTER === -->
<div class="slide-counter" id="slideCounter"></div>

<!-- === SCRIPTS === -->
<script>
    /* === NAVIGATION === */
    /* === REVEAL ANIMATIONS === */
    /* === EDIT MODE (if enabled) === */
</script>

</body>
</html>
```

---

## JavaScript: Navigation

Paste this exact block into every presentation. Replace nothing — it's self-contained.

```javascript
/* === NAVIGATION === */
const slides = document.querySelectorAll('.slide');
const progressBar = document.getElementById('progressBar');
const navDotsContainer = document.getElementById('navDots');
const slideCounter = document.getElementById('slideCounter');
let current = 0;

// Build nav dots
slides.forEach((_, i) => {
    const dot = document.createElement('div');
    dot.className = 'nav-dot' + (i === 0 ? ' active' : '');
    dot.addEventListener('click', () => goTo(i));
    navDotsContainer.appendChild(dot);
});

function goTo(index) {
    const prev = current;
    slides[prev].classList.remove('active');
    slides[prev].classList.add(index > prev ? 'exit-left' : 'exit-right');
    setTimeout(() => slides[prev].classList.remove('exit-left', 'exit-right'), 400);

    current = Math.max(0, Math.min(index, slides.length - 1));
    slides[current].classList.add('active');

    // Update UI
    document.querySelectorAll('.nav-dot').forEach((d, i) =>
        d.classList.toggle('active', i === current));
    progressBar.style.width = ((current + 1) / slides.length * 100) + '%';
    slideCounter.textContent = `${current + 1} / ${slides.length}`;

    // Trigger reveals
    triggerReveals(slides[current]);
}

function triggerReveals(slide) {
    slide.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.setProperty('--delay', (i * 60) + 'ms');
        requestAnimationFrame(() => el.classList.add('visible'));
    });
}

// Keyboard navigation
document.addEventListener('keydown', e => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown' || e.key === ' ') {
        e.preventDefault(); goTo(current + 1);
    }
    if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
        e.preventDefault(); goTo(current - 1);
    }
    if (e.key === 'Home') goTo(0);
    if (e.key === 'End') goTo(slides.length - 1);
});

// Touch / swipe
let touchStartX = 0;
document.addEventListener('touchstart', e => { touchStartX = e.touches[0].clientX; });
document.addEventListener('touchend', e => {
    const dx = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(dx) > 50) goTo(current + (dx > 0 ? 1 : -1));
});

// Init
goTo(0);
```

---

## JavaScript: Edit Mode (include only if user requested)

```javascript
/* === EDIT MODE === */
let editMode = false;

function toggleEditMode() {
    editMode = !editMode;
    document.body.classList.toggle('edit-mode', editMode);
    document.querySelectorAll('[data-editable]').forEach(el => {
        el.contentEditable = editMode ? 'true' : 'false';
    });
}

// Trigger: press E or hover top-left corner
document.addEventListener('keydown', e => {
    if (e.key === 'e' || e.key === 'E') toggleEditMode();
});

// Auto-save to localStorage
document.addEventListener('keydown', e => {
    if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        const slides = {};
        document.querySelectorAll('[data-editable]').forEach((el, i) => {
            slides[el.dataset.editable || i] = el.innerHTML;
        });
        localStorage.setItem('biz-slides-edits', JSON.stringify(slides));
        showToast('Saved');
    }
});

// Restore saved edits on load
const saved = localStorage.getItem('biz-slides-edits');
if (saved) {
    const edits = JSON.parse(saved);
    Object.entries(edits).forEach(([key, val]) => {
        const el = document.querySelector(`[data-editable="${key}"]`);
        if (el) el.innerHTML = val;
    });
}

function showToast(msg) {
    const t = Object.assign(document.createElement('div'), {
        textContent: msg,
        style: `position:fixed;bottom:48px;left:50%;transform:translateX(-50%);
                background:var(--accent);color:var(--bg);padding:8px 20px;
                border-radius:4px;font-size:0.8rem;letter-spacing:0.08em;
                opacity:1;transition:opacity 0.4s;z-index:999;`
    });
    document.body.appendChild(t);
    setTimeout(() => { t.style.opacity = 0; setTimeout(() => t.remove(), 400); }, 1500);
}
```

Add `data-editable="[unique-key]"` to any element that should be editable.  
Example: `<h1 data-editable="title-headline">Our Q3 Performance</h1>`

---

## Data Slides: CSS-Only Patterns

### KPI Row (no JS required)
```html
<div class="kpi-grid">
    <div class="kpi-card">
        <div class="kpi-number reveal">+34%</div>
        <div class="kpi-label reveal">GMV Growth</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-number reveal">2.1×</div>
        <div class="kpi-label reveal">Subscriber Base</div>
    </div>
</div>
```

### Horizontal Bar Chart (CSS only)
```html
<div class="bar-chart">
    <div class="bar-chart-row reveal">
        <span class="bar-label">SEA</span>
        <div class="bar-track">
            <div class="bar-fill" style="width: 82%; background: var(--accent);"></div>
        </div>
        <span class="bar-value">82%</span>
    </div>
    <div class="bar-chart-row reveal">
        <span class="bar-label">India</span>
        <div class="bar-track">
            <div class="bar-fill" style="width: 61%; background: var(--accent);"></div>
        </div>
        <span class="bar-value">61%</span>
    </div>
</div>
```

### Two-Column Comparison
```html
<div class="two-col">
    <div class="col-left">
        <div class="eyebrow reveal">Before</div>
        <ul class="bullet-list">
            <li class="reveal">Point A</li>
            <li class="reveal">Point B</li>
        </ul>
    </div>
    <div class="col-right">
        <div class="eyebrow reveal">After</div>
        <ul class="bullet-list">
            <li class="reveal">Point A</li>
            <li class="reveal">Point B</li>
        </ul>
    </div>
</div>
```

---

## Code Quality Standards

- Every `<style>` major section gets a `/* === SECTION NAME === */` comment block
- Every `<script>` function gets a one-line comment above it
- Each slide gets an HTML comment: `<!-- === SLIDE N: [TITLE] === -->`
- `:root` CSS variables for all colours — never hardcode hex in slide styles
- No `!important` except inside `prefers-reduced-motion` block
- Test: does content fit at 1280×720? At 1024×600? At 800×500?
