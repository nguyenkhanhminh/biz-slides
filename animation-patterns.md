# Animation Patterns Reference

Business presentations should feel precise and confident — not flashy.  
Choose the right animation weight for the mood. Most slides need one type only.

---

## Mood → Animation Weight Guide

| Mood        | Weight       | Pattern to Use          |
| ----------- | ------------ | ----------------------- |
| Confident   | Medium       | Stagger Reveal + Metric Counter |
| Strategic   | Light        | Fade Shift              |
| Energised   | Medium-Heavy | Slide In + Bar Grow     |
| Credible    | Light        | Fade Only               |

**Rule:** One orchestrated page-load sequence > scattered micro-interactions.  
If in doubt, use Stagger Reveal and nothing else.

---

## 1. Stagger Reveal (Default — use for most slides)

Triggers automatically via JS `triggerReveals()` on slide entry.  
Add `class="reveal"` to any element. Stagger is automatic via `--delay`.

```css
/* Already in viewport-base.css — no extra CSS needed */
```

```html
<!-- Each element reveals 60ms after the previous -->
<div class="eyebrow reveal">Q3 2025</div>
<h1 class="reveal">Revenue grew 34%</h1>
<p class="reveal">Driven by VIP subscriber expansion across SEA</p>
```

---

## 2. Fade Shift (Light — strategic / credible moods)

Subtle lift with no transform. Calm, professional.

```css
@keyframes fadeShift {
    from { opacity: 0; transform: translateY(6px); }
    to   { opacity: 1; transform: translateY(0); }
}

.fade-shift {
    animation: fadeShift 0.55s cubic-bezier(0.25, 0.46, 0.45, 0.94) both;
    animation-delay: var(--delay, 0ms);
}
```

```html
<h2 class="fade-shift" style="--delay:0ms">Strategic priorities</h2>
<p class="fade-shift" style="--delay:80ms">Supporting context here</p>
```

---

## 3. Metric Counter (for KPI number slides)

Counts up from 0 to target value on slide entry. Good for numbers with impact.

```javascript
/* === METRIC COUNTER === */
function animateCounter(el) {
    const target = parseFloat(el.dataset.target);
    const isPercent = el.dataset.suffix === '%';
    const isMultiple = el.dataset.suffix === '×';
    const prefix = el.dataset.prefix || '';
    const suffix = el.dataset.suffix || '';
    const duration = 900;
    const start = performance.now();

    function tick(now) {
        const elapsed = now - start;
        const progress = Math.min(elapsed / duration, 1);
        // Ease out cubic
        const eased = 1 - Math.pow(1 - progress, 3);
        const current = target * eased;
        const display = isPercent || isMultiple
            ? current.toFixed(1)
            : Math.round(current).toLocaleString();
        el.textContent = prefix + display + suffix;
        if (progress < 1) requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
}

// Auto-trigger counters on slide entry (add to triggerReveals function)
// or call manually: animateCounter(element)
```

```html
<!-- Usage: -->
<div class="kpi-number"
     data-target="34"
     data-suffix="%"
     data-prefix="+">+34%</div>
```

---

## 4. Bar Grow (for chart slides)

CSS animation — already in viewport-base.css. Just add `.bar-fill` class.

```html
<div class="bar-track">
    <div class="bar-fill" style="width: 82%; background: var(--accent);
         animation-delay: 200ms;"></div>
</div>
```

Stagger bars by incrementing `animation-delay` by 100ms per row.

---

## 5. Title Slide Impact (for opening slide only)

Dramatic entrance for the first slide only. Use sparingly.

```css
@keyframes titleDrop {
    from {
        opacity: 0;
        transform: translateY(24px) scale(0.97);
        filter: blur(4px);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
        filter: blur(0);
    }
}

.title-impact {
    animation: titleDrop 0.7s cubic-bezier(0.16, 1, 0.3, 1) both;
    animation-delay: var(--delay, 0ms);
}
```

---

## 6. Slide Transitions

Already in viewport-base.css. The default is opacity + 40px horizontal shift.  
Do not override unless the chosen preset calls for a different transition.

For dark/bold presets, optionally increase the shift:
```css
.slide.exit-left  { opacity: 0; transform: translateX(-60px); }
.slide.exit-right { opacity: 0; transform: translateX(60px); }
```

---

## DO NOT USE

- Parallax or scroll-based effects (slides are full-screen, no scroll)
- Looping animations on non-title slides (distracting during presentation)
- `animation-iteration-count: infinite` on anything visible during content
- 3D transforms (`rotateY`, `perspective`) — unpredictable across screens
- `animation-duration` over 1000ms (feels sluggish in presentation context)
